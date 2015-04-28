//
//  RCObjectManager.m
//  CarMap
//
//  Created by  APPLE on 2014/7/26.
//  Copyright (c) 2014年 温鹏辉. All rights reserved.
//

#import "RCObjectManager.h"


@implementation RCObjectManager

@synthesize netType;

+(RCObjectManager *)shared{
    static dispatch_once_t once = 0;
	static RCObjectManager *OM;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dispatch_once(&once, ^{ OM = [[RCObjectManager alloc] init]; });
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return OM;
}

-(id)init{
    if (self = [super init]) {
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dPath = [array objectAtIndex:0];
        NSString *dbPath = [dPath stringByAppendingPathComponent:@"CarMap.db"];
        dbQueue = [[FMDatabaseQueue alloc]initWithPath:dbPath];
        [dbQueue inDatabase:^(FMDatabase *_db) {
            [_db open];
            [_db executeUpdate:@"create table t_park(mID integer primary key autoincrement,mPark_ID text, mPark_Name text,mAddress text,mType text)"];
            [_db executeUpdate:@"create table t_flow(mID integer primary key autoincrement,mDate text, mByte decimal(19,2),mType text)"];
            [_db executeUpdate:@"create table t_info(mID integer primary key autoincrement,mTel text)"];
            [_db executeUpdate:@"create table t_order(mID integer primary key autoincrement,mCode text,mContent text)"];
            NSLog(@"%@",[_db lastError]);
            [_db close];
        }];
    }
    return self;
}

-(void)saveOrder:(NSDictionary *)dic{
    [dbQueue inDatabase:^(FMDatabase *_db) {
        [_db open];
        [_db executeUpdate:[NSString stringWithFormat:@"delete from t_order where mCode = '%@'",[dic strForKey:@"mCode"]]];
        [_db executeUpdate:[NSString stringWithFormat:@" insert into t_order (mCode,mContent)values('%@','%@')",[dic strForKey:@"mCode"],[[dic objectForKey:@"mContent"] JSONString]]];
        [_db close];
    }];
}

-(NSDictionary *)getOrder:(NSString *)code{
    __block NSMutableDictionary *dic = nil;
    
    [dbQueue inDatabase:^(FMDatabase *_db) {
        [_db open];
        NSString *strSql = [NSString stringWithFormat:@" select mCode,mContent from t_order where mCode='%@'",code];
        FMResultSet *rs = [_db executeQuery:strSql];
        
        if ([rs next]){
//            [dic setObject:[rs stringForColumnIndex:0] forKey:@"mCode"] ;
            dic = [[rs stringForColumnIndex:1] objectFromJSONString];
        }
        [_db close];
    }];
    
    return dic;
}

-(NSString *)getTel{
    __block NSString *tel = nil;
    
    [dbQueue inDatabase:^(FMDatabase *_db) {
        [_db open];
        NSString *strSql = [NSString stringWithFormat:@" select mTel from t_info  "];
        FMResultSet *rs = [_db executeQuery:strSql];
        
        if ([rs next])
            tel = [rs stringForColumnIndex:0];
        
        [_db close];
    }];
    
    return tel;
    
}

-(void)saveTel:(NSString *)tel{
    [dbQueue inDatabase:^(FMDatabase *_db) {
        [_db open];
        [_db executeUpdate:@"delete from t_info"];
        [_db executeUpdate:[NSString stringWithFormat:@" insert into t_info (mTel)values('%@')",tel]];
        [_db close];
    }];
}

-(NSString *)GetCurrentDate{
    NSDateFormatter *format = [[[NSDateFormatter alloc]init] autorelease];
    [format setDateFormat:@"YYYY-MM-dd"];
    return [format stringFromDate:[NSDate date]];
}

-(void)saveFlow:(NSString *)strDate byte:(NSUInteger)ibyte type:(NSUInteger)itype{
    NSString *mDate = strDate;
    if (mDate == nil){
        mDate = [self GetCurrentDate];
    }
    [dbQueue inDatabase:^(FMDatabase *_db) {
        [_db open];
        NSString *strSql = [NSString stringWithFormat:@"select * from t_flow where mDate='%@' and mType=%d",mDate,self.netType];
        FMResultSet *rs = [_db executeQuery:strSql];

        if ([rs next])
            strSql =  [NSString stringWithFormat:@"update t_flow set mByte = mByte + %d where mDate = '%@' and mType = %d",
                               ibyte,mDate,itype];
        else
            strSql =  [NSString stringWithFormat:@"insert into t_flow(mDate,mByte,mType)values('%@','%d','%d')",
                       mDate,ibyte,itype];
        

        [_db executeUpdate:strSql];
        [_db close];
    }];
}

-(NSMutableDictionary *)getFlowDate{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[NSDate date] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 2))];
    NSDate *thisWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - 7)];
    NSDate *lastWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - ([components day] -1))];
    NSDate *thisMonth = [cal dateFromComponents:components];
    
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    
    NSDateFormatter *format = [[[NSDateFormatter alloc]init] autorelease];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    [dic setObject:[format stringFromDate:today] forKey:@"Today"];
    [dic setObject:[format stringFromDate:yesterday] forKey:@"yesterday"];
    [dic setObject:[format stringFromDate:thisWeek] forKey:@"thisWeek"];
    [dic setObject:[format stringFromDate:lastWeek] forKey:@"lastWeek"];
    [dic setObject:[format stringFromDate:thisMonth] forKey:@"thisMonth"];
    [dic setObject:[format stringFromDate:lastMonth] forKey:@"lastMonth"];
    return dic;
}

-(NSMutableArray *)getFlow{
    NSMutableArray *arrs =  [NSMutableArray array];
    [dbQueue inDatabase:^(FMDatabase *_db) {
        [_db open];
        
        NSMutableDictionary *flowDate =  [self getFlowDate];
        NSString *strSql = [NSString stringWithFormat:@"select sum(mByte) as byte,mType from t_flow where mDate >='%@' group by mType",[flowDate strForKey:@"today"]];
        NSMutableArray *today = [NSMutableArray arrayWithObjects:@"今日",@"0",@"0",@"0",nil];
        
        FMResultSet *rs = [_db executeQuery:strSql];
        while ([rs next]) {
            NSUInteger total = 0;
            NSUInteger index = [[rs resultDictionary] intForKey:@"mType"] == 1?1:2;
            [today replaceObjectAtIndex:index withObject:[self getDataSizeString:[[rs resultDictionary] intForKey:@"byte"]]];
            total += [[rs resultDictionary] intForKey:@"byte"];
            [today replaceObjectAtIndex:3 withObject:[self getDataSizeString:total]];

        }
        [arrs addObject:today];
        strSql = [NSString stringWithFormat:@"select sum(mByte) as byte,mType from t_flow where mDate >='%@' group by mType",[flowDate strForKey:@"today"]];
        rs = [_db executeQuery:strSql];
        NSMutableArray *thisWeek = [NSMutableArray arrayWithObjects:@"本周",@"0",@"0",@"0",nil];
        while ([rs next]) {
            NSUInteger total = 0;
            NSUInteger index = [[rs resultDictionary] intForKey:@"mType"] == 1?1:2;
            [thisWeek replaceObjectAtIndex:index withObject:[self getDataSizeString:[[rs resultDictionary] intForKey:@"byte"]]];
            total += [[rs resultDictionary] intForKey:@"byte"];
            [thisWeek replaceObjectAtIndex:3 withObject:[self getDataSizeString:total]];
        }
        [arrs addObject:thisWeek];
        strSql = [NSString stringWithFormat:@"select sum(mByte) as byte,mType from t_flow where mDate >='%@' group by mType",[flowDate strForKey:@"today"]];
        rs = [_db executeQuery:strSql];
        NSMutableArray *thisMonth = [NSMutableArray arrayWithObjects:@"本月",@"0",@"0",@"0",nil];
        while ([rs next]) {
            NSUInteger total = 0;
            NSUInteger index = [[rs resultDictionary] intForKey:@"mType"] == 1?1:2;
            [thisMonth replaceObjectAtIndex:index withObject:[self getDataSizeString:[[rs resultDictionary] intForKey:@"byte"]]];
            total += [[rs resultDictionary] intForKey:@"byte"];
            [thisMonth replaceObjectAtIndex:3 withObject:[self getDataSizeString:total]];
        }
        [arrs addObject:thisMonth];
        [_db close];
    }];
    
    return arrs;
}

-(void)clearFlow{
    [dbQueue inDatabase:^(FMDatabase *_db) {
        [_db open];
        NSString *strSql = [NSString stringWithFormat:@"delete from t_flow"];
        [_db executeUpdate:strSql];
        [_db close];
    }];
    
}

-(NSString *)getDataSizeString:(int) nSize
{
    NSString *string = nil;
    if (nSize<1024)
    {
        string = [NSString stringWithFormat:@"%dB", nSize];
    }
    else if (nSize<1048576)
    {
        string = [NSString stringWithFormat:@"%dK", (nSize/1024)];
    }
    else if (nSize<1073741824)
    {
        if ((nSize%1048576)== 0 )
        {
            string = [NSString stringWithFormat:@"%dM", nSize/1048576];
        }
        else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%dMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%d.%@M", nSize/1048576, decimalStr];
            }
        }
    }
    else	// >1G
    {
        string = [NSString stringWithFormat:@"%dG", nSize/1073741824];
    }
    
    return string;
}

-(BOOL)SaveParkInfo:(NSDictionary *)dic{
    __block BOOL result = NO;
    [dbQueue inDatabase:^(FMDatabase *_db) {
        [_db open];
        NSString *strSql = [NSString stringWithFormat:@"insert into t_park(mPark_ID,mPark_Name,mAddress,mType)values('%@','%@','%@','%@')",
                            [dic strForKey:@"id"],[dic strForKey:@"park_name"],[dic strForKey:@"adds"],[dic strForKey:@"type"]];
        result =  [_db executeUpdate:strSql];
        [_db close];
    }];
    
    return result;
}


-(BOOL)DelParkInfo:(NSDictionary *)dic{
    __block BOOL result = NO;
    [dbQueue inDatabase:^(FMDatabase *_db) {
        [_db open];
        NSString *strSql = [NSString stringWithFormat:@"delete from t_park where mPark_ID='%@'",[dic strForKey:@"id"]];
        result =  [_db executeUpdate:strSql];
        [_db close];
    }];
    
    return result;

}

-(BOOL)CheckParkInfo:(NSDictionary *)dic{
    __block BOOL result = NO;
    [dbQueue inDatabase:^(FMDatabase *_db) {
        [_db open];
        NSString *strSql = [NSString stringWithFormat:@"select * from t_park where mPark_ID='%@'",[dic strForKey:@"id"]];
        FMResultSet *rs = [_db executeQuery:strSql];
        result =  [rs next];
        [_db close];
    }];
    
    return result;

}

-(NSMutableArray *)GetParkInfos{
    NSMutableArray *arrs =  [NSMutableArray array];
    [dbQueue inDatabase:^(FMDatabase *_db) {
        [_db open];
        NSString *strSql = [NSString stringWithFormat:@"select * from t_park "];
        FMResultSet *rs = [_db executeQuery:strSql];
        while ([rs next]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [[rs resultDictionary] strForKey:@"mPark_ID"],@"id",
                                 [[rs resultDictionary] strForKey:@"mPark_Name" ],@"park_name",
                                 [[rs resultDictionary] strForKey:@"mAddress" ],@"adds",
                                 [[rs resultDictionary] strForKey:@"mType" ],@"type",
                                 nil];
            [arrs addObject:dic];
        }
        [_db close];
    }];
    
    return arrs;
}



-(void)dealloc{
    self.shengheArr = nil;
    self.rights = nil;
    self.rightsMode = nil;
    [dbQueue release];
    [super dealloc];
}

@end
