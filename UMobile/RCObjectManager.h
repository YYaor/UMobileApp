//
//  RCObjectManager.h
//  CarMap
//
//  Created by  APPLE on 2014/7/26.
//  Copyright (c) 2014年 温鹏辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import "NSDictionary_IngoreNull.h"

@interface RCObjectManager : NSObject{
    FMDatabaseQueue *dbQueue;
}

+(RCObjectManager *)shared;

@property(nonatomic,retain) NSMutableArray *rights;
@property(nonatomic,retain) NSMutableArray *rightsMode;
@property(nonatomic,retain) NSMutableArray *shengheArr;

-(BOOL)SaveParkInfo:(NSDictionary *)dic;
-(BOOL)DelParkInfo:(NSDictionary *)dic;
-(BOOL)CheckParkInfo:(NSDictionary *)dic;
-(NSMutableArray *)GetParkInfos;

-(void)saveFlow:(NSString *)strDate byte:(NSUInteger)ibyte type:(NSUInteger)itype;

-(NSMutableArray *)getFlow;
-(NSMutableDictionary *)getFlowDate;
-(void)clearFlow;

-(void)saveTel:(NSString *)tel;
-(NSString *)getTel;

-(void)saveOrder:(NSDictionary *)dic;
-(NSDictionary *)getOrder:(NSString *)code;

@property(nonatomic) NSUInteger netType;



@end
