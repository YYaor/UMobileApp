//
//  YeWuDanJuViewController.m
//  UMobile
//
//  Created by mocha on 15/4/30.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "YeWuDanJuViewController.h"
#import "ShenHeDtlViewController.h"

@interface YeWuDanJuViewController ()<UIPrintInteractionControllerDelegate,PrintDelegate>

@end

@implementation YeWuDanJuViewController

@synthesize headInfo;
@synthesize products;

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0; i < 20; i ++) {
        NSString * str = [self GetCurrentDateTime];
        NSLog(@"%@", str);
    }
    
    XinZenHeaderViewController *vc1 = (XinZenHeaderViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"YeWuDanJuXinZenViewController"];
    XinZenDetailViewController *vc2 = (XinZenDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"XinZenDetailViewController"];
    vc1.parentVC = self;
    vc1.delegate = self;
    vc1.allInfo = self.headInfo;
    
    
    vc1.bEdit = self.bEdit;
    vc1.bClean = self.bClean;
    if (self.bEdit) self.navigationItem.title = @"业务单据录入";
    vc2.parentVC = self;
    vc2.products = self.products;
    vc2.bClean = self.bClean;
    self.mutileView.viewControllers = @[vc1,vc2];
    self.mutileView.titles = @[@"基本信息",@"商品明细"];
    // Do any additional setup after loading the view.
}

-(NSNumber *)numValue:(NSString *)str{
    return [NSNumber numberWithInteger:[str integerValue]];
}

-(NSString *)floatValue:(NSString *)str{
    //    NSNumber *number = [NSNumber numberWithFloat:[str floatValue]];
    //    NSLog(@"%@=%f",number,[number floatValue]);
    //    return number;// [NSNumber numberWithFloat:[str floatValue]];
    return [NSString stringWithFormat:@"%0.2f",[str floatValue]];
}

-(NSString *)dateValue:(NSString *)str{
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc]init] autorelease];
    NSDate *date = [dateFormat dateFromString:str];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    return [dateFormat stringFromDate:date];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    XinZenHeaderViewController *vc1 = (XinZenHeaderViewController *) [self.mutileView.viewControllers objectAtIndex:0];
    
    BOOL bSave = NO;
    for(int i = 3 ; i < 11 ; i ++){
        NSArray *arr = [vc1.allInfo objectForKey:[NSString stringWithFormat:@"%d",i]];
        if ([arr count] > 0) {
            bSave = YES;
            break;
        }
    }
    if (bSave) {
        NSDictionary *dic = @{@"mCode":[self.setting strForKey:@"Identy"],
                              @"mContent":vc1.allInfo};
        [[self GetOM] saveOrder:dic];
    }
}

- (IBAction)submitClick:(id)sender {
    
    XinZenHeaderViewController *vc1 = (XinZenHeaderViewController *) [self.mutileView.viewControllers objectAtIndex:0];
    XinZenDetailViewController *vc2 = (XinZenDetailViewController *)[self.mutileView.viewControllers objectAtIndex:1];
    NSDictionary *hInfo = vc1.allInfo;
    NSArray *dInfo = vc2.products;
    
    // fixBug   必选提示信息
    if ([self.setting intForKey:@"ISBS"] == 1) {
        if ([[(NSArray *)[hInfo objectForKey:@"3"] ingoreObjectAtIndex:1] length] == 0 ) {
            [self ShowMessage:@"请选择往来单位"];
            return;
        }
        if ([[(NSArray *)[hInfo objectForKey:@"4"] ingoreObjectAtIndex:1] length] == 0) {
            [self ShowMessage:@"请选择经手人"];
            return;
        }
        if ([[(NSArray *)[hInfo objectForKey:@"5"] ingoreObjectAtIndex:0] integerValue] <= 0) {//有可能取到其他部门，ID为-1，也要重新选择
            [self ShowMessage:@"请选择部门"];
            return;
        }
    }else{
        if ([[(NSArray *)[hInfo objectForKey:@"5"] ingoreObjectAtIndex:1] length] == 0 ) {
            [self ShowMessage:@"请选择往来单位"];
            return;
        }
        if ([[(NSArray *)[hInfo objectForKey:@"3"] ingoreObjectAtIndex:1] length] == 0) {
            [self ShowMessage:@"请选择经手人"];
            return;
        }
    }
    if ([dInfo count] == 0) {
        [self ShowMessage:@"请选择商品"];
        return;
    }else{
        for (NSDictionary *dic in dInfo) {
            if ([dic intForKey:@"赠品"] == 0 && [dic floatForKey:@"折后金额"] == 0) {
                [self ShowMessage:@"商品价格不能小于等于0"];
                return;
            }
        }
    }
    
    /*临时注释  ghd
     // 区分BS参数
     if ([[self setting] intForKey:@"ISBS"] == 1) {
     NSArray *M_Data = @[[NSNumber numberWithInt:0],
     [[hInfo objectForKey:@"2"] ingoreObjectAtIndex:1],
     [NSNumber numberWithInt:0],
     [self numValue:[[hInfo objectForKey:@"0"] ingoreObjectAtIndex:0]],
     [[hInfo objectForKey:@"1"] ingoreObjectAtIndex:1],
     [self GetCurrentTime],
     // 到货日期
     [self numValue:[[hInfo objectForKey:@"7"] ingoreObjectAtIndex:0]],
     // 往来单位
     [self numValue:[[hInfo objectForKey:@"5"] ingoreObjectAtIndex:0]],
     [self numValue:[[hInfo objectForKey:@"3"] ingoreObjectAtIndex:0]],
     // 部门ID
     
     
     [self GetCurrentDateTime],
     [self GetCurrentDate],
     [NSNumber numberWithInt:-1],
     [NSNumber numberWithInt:100],
     [NSNumber numberWithInt:0],
     [self numValue:[[hInfo objectForKey:@"5"] ingoreObjectAtIndex:0]],
     [self numValue:[[hInfo objectForKey:@"7"] ingoreObjectAtIndex:0]],
     [self numValue:[[hInfo objectForKey:@"3"] ingoreObjectAtIndex:0]],
     [[hInfo objectForKey:@"6"] ingoreObjectAtIndex:1],
     [[hInfo objectForKey:@"8"] ingoreObjectAtIndex:1],
     [[hInfo objectForKey:@"8"] ingoreObjectAtIndex:1],
     [self floatValue:vc2.total],
     [self floatValue:vc2.total],
     [self floatValue:vc2.total],
     [self floatValue:vc2.total],
     [self floatValue:vc2.count],
     [self numValue:[[hInfo objectForKey:@"9"] ingoreObjectAtIndex:0]],
     [self floatValue:[[hInfo objectForKey:@"10"] ingoreObjectAtIndex:1]],
     [self numValue:[self GetUserID]]
     ];
     }
     */
    NSDictionary *dic = nil;
    if ([self.setting intForKey:@"ISBS"] == 1) {
        dic = [self GetBS];
    }else{
        dic = [self GetCS];
    }
    
    NSLog(@"dic2 %@",[dic JSONString]);
    
    NSString *link = [self GetLinkWithFunction:69 andParam:nil];
    
    __block XinZenDingDanViewController *tempSelf = self;
    [self StartQuery:link withStrInfo:dic completeBlock:^(id obj) {
        NSDictionary *info = [obj objectFromJSONString];
        
        
        if ([info intForKey:@"BillID"] > 0 && [info intForKey:@"BillID"] != NSNotFound) {
            if ([[info strForKey:@"Result"] length] > 0) {
                [tempSelf ShowMessage:[info strForKey:@"Result"]];
            }else if([[info strForKey:@"错误"] length] > 0){
                [tempSelf ShowMessage:[info strForKey:@"错误"]];
            }else{
                [tempSelf ShowMessage:@"新增成功"];
            }
            
            XinZenHeaderViewController *vc1 = (XinZenHeaderViewController *) [self.mutileView.viewControllers objectAtIndex:0];
            [vc1 reset];
            XinZenDetailViewController *vc2 = (XinZenDetailViewController *)[self.mutileView.viewControllers objectAtIndex:1];
            [vc2.products removeAllObjects];
            [vc2 loadData];
            
            // fix: push 订单查询 以订单时间作为查询的截止时间   '%@','%@',%d,'%@',%d,%d,%d,%d,1
            DDGLViewController *viewController = nil;
            for (UIViewController *vc in self.navigationController.viewControllers){
                if ([vc isKindOfClass:[DDGLViewController class]]) {
                    viewController = (DDGLViewController *)vc;
                }
            }
            
            NSString *param = [NSString stringWithFormat:@"'','%@',%d,'',0,0,0,0,%@",
                               [[dic objectForKey:@"M_Data"] objectAtIndex:4],
                               [[[dic objectForKey:@"M_Data"] objectAtIndex:3] integerValue],
                               [self GetUserID]];
            if(viewController){
                viewController.param = param;
                [viewController loadData];
                [self.navigationController popToViewController:viewController animated:YES];
            }else{
                viewController = (DDGLViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DDGLViewController"];
                viewController.param = param;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            
            
            
            
            //            [tempSelf.navigationController popViewControllerAnimated:YES];
        }else{
            if ([[info strForKey:@"Result"] length] > 0) {
                [tempSelf ShowMessage:[info strForKey:@"Result"]];
            }else if([[info strForKey:@"错误"] length] > 0){
                [tempSelf ShowMessage:[info strForKey:@"错误"]];
            }else{
                [tempSelf ShowMessage:@"订单提交失败，请重试"];
            }
        }
    }];
}

-(NSDictionary *)GetCS{
    
    XinZenHeaderViewController *vc1 = (XinZenHeaderViewController *) [self.mutileView.viewControllers objectAtIndex:0];
    XinZenDetailViewController *vc2 = (XinZenDetailViewController *)[self.mutileView.viewControllers objectAtIndex:1];
    NSDictionary *hInfo = vc1.allInfo;
    NSMutableArray *dInfo = [NSMutableArray array];
    [dInfo addObjectsFromArray:vc2.products];
    [dInfo addObjectsFromArray:vc2.delProducts];
    
    
    NSString *stockID = @"-1";
    NSString *strDate = @"";
    NSString *strRemark = @"";
    NSString *strAcc = @"0";
    NSString *strAccAmt = @"0";
    
    if ([(NSArray *)[hInfo objectForKey:@"7"] count] > 0) {
        stockID = [[hInfo objectForKey:@"7"] objectAtIndex:0];
    }
    
    if ([(NSArray *)[hInfo objectForKey:@"6"] count] > 0) {
        strDate = [[hInfo objectForKey:@"6"] objectAtIndex:1];
    }
    
    if ([(NSArray *)[hInfo objectForKey:@"8"] count] > 0) {
        strRemark = [[hInfo objectForKey:@"8"] objectAtIndex:1];
    }
    
    if ([(NSArray *)[hInfo objectForKey:@"9"] count] > 0) {
        strAcc = [[hInfo objectForKey:@"9"] objectAtIndex:0];
    }
    
    if ([(NSArray *)[hInfo objectForKey:@"10"] count] > 0) {
        strAccAmt = [[hInfo objectForKey:@"10"] objectAtIndex:1];
    }
    
    
    NSArray *M_Data = @[[NSNumber numberWithInt:[self.InvId integerValue]],         //0 单据ID
                        [[hInfo objectForKey:@"2"] ingoreObjectAtIndex:1],          //1 单据编号
                        [NSNumber numberWithInt:0],                                 //2 单据标识: 0
                        [self numValue:[[hInfo objectForKey:@"0"] ingoreObjectAtIndex:0]],//3 单据类型
                        [[hInfo objectForKey:@"1"] ingoreObjectAtIndex:1],      //4 单据日期
                        [self GetCurrentTime],              //5 单据时间
                        [self GetCurrentDateTime],          //6 单据日期时间
                        [self GetCurrentDate],              //7 操作日期
                        [NSNumber numberWithInt:-1],        //8 单据状态
                        [NSNumber numberWithInt:100],       //9 折扣
                        [NSNumber numberWithInt:0],         //10 优惠金额
                        [self numValue:[[hInfo objectForKey:@"5"] ingoreObjectAtIndex:0]],  //11 往来单位ID,
                        stockID,//[self numValue:[[hInfo objectForKey:@"7"] ingoreObjectAtIndex:0]],  //12 仓库ID
                        [self numValue:[[hInfo objectForKey:@"3"] ingoreObjectAtIndex:0]],  //13 经手人ID,
                        strDate,//[[hInfo objectForKey:@"6"] ingoreObjectAtIndex:1] ,              //14 到货日期  ?????????????????
                        strRemark,// [[hInfo objectForKey:@"8"] ingoreObjectAtIndex:1],//备注          //15 备注
                        strRemark,// [[hInfo objectForKey:@"8"] ingoreObjectAtIndex:1],//摘要          //16 摘要
                        [self floatValue:vc2.total],    //17 金额
                        [self floatValue:vc2.disTotal],    //18 折后金额,
                        [self floatValue:vc2.disTotal],    //19 含税金额
                        [self floatValue:vc2.disTotal],    //20 成交金额
                        [self floatValue:vc2.count],    //21 总数量
                        strAcc, //[self numValue:[[hInfo objectForKey:@"9"] ingoreObjectAtIndex:0]],//22 收/付款账户ID
                        strAccAmt,// [self floatValue:[[hInfo objectForKey:@"10"] ingoreObjectAtIndex:1]],//23 收/付款金额
                        [self numValue:[self GetUserID]]    //24 操作员职员ID
                        ];
    NSMutableArray *D_Data = [NSMutableArray array];
    for (NSDictionary *rs in dInfo){
        NSMutableArray *rsd = [NSMutableArray array];
        //0 明细ID
        if (self.InvId == 0) {
            [rsd addObject:[self numValue:@"0"]];//新增
        }else{
            [rsd addObject:[self numValue:[rs strForKey:@"ListID"]]];//修改
        }
        
        [rsd addObject:[self numValue:self.InvId]];                       //1 单据ID
        
        //        [rsd addObject:[self numValue:self.InvId]];                     //0 明细ID,	 编辑时传ListID,删除时传-ListID
        //        [rsd addObject:[self numValue:@"0"]];                          //1 单据ID
        [rsd addObject:[self numValue:stockID]];      //2 仓库ID
        [rsd addObject:[self numValue:[rs strForKey:@"商品ID"]]];         //3 商品ID
        [rsd addObject:[self numValue:[rs strForKey:@"单位ID"]]];       //4 商品单位ID 单位ID
        [rsd addObject:@""];    //5 批号
        [rsd addObject:@""];    //6 出厂日期
        [rsd addObject:[self numValue:[rs strForKey:@"数量"]]];       //7 数量
        [rsd addObject:[self floatValue:[rs strForKey:@"单价"]]];     //8 单价
        [rsd addObject:[self floatValue:[rs strForKey:@"金额"]]];     //9 金额
        
        [rsd addObject:[self numValue:[rs strForKey:@"单位换算率"]]];       //10 单位换算率
        [rsd addObject:[self numValue:[rs strForKey:@"基本单位数量"]]];      //11 基本单位数量
        [rsd addObject:[self numValue:[rs strForKey:@"折扣"]]];            //12 折扣
        [rsd addObject:[self floatValue:[rs strForKey:@"折后单价"]]];       //13 折后单价
        [rsd addObject:[self floatValue:[rs strForKey:@"折后金额"]]];       //14 折后金额
        [rsd addObject:[self floatValue:[rs strForKey:@"折扣金额"]]];       //15 折扣金额
        
        [rsd addObject:[self floatValue:@"0"]];//16 税率
        [rsd addObject:[self floatValue:[rs strForKey:@"含税单价"]]];   //17 含税单价
        [rsd addObject:[self floatValue:[rs strForKey:@"含税金额"]]];   //18 含税金额
        [rsd addObject:[self floatValue:@"0"]];                     //19 税额
        [rsd addObject:[self numValue:[rs strForKey:@"赠品"]]];   //20 是否赠送商品
        [rsd addObject:[rs strForKey:@"备注"]];                   //21 商品备注
        
        [D_Data addObject:rsd];
    }
    NSMutableArray *D_Data2 = [NSMutableArray array];
    [D_Data2 addObject:@[[self numValue:self.AccID],
                         [self numValue:self.InvId],
                         [self numValue:[[hInfo objectForKey:@"9"] ingoreObjectAtIndex:0]],
                         [self floatValue:[[hInfo objectForKey:@"10"] ingoreObjectAtIndex:1]]]
     ];
    
    NSLog(@"%@", [M_Data objectAtIndex:13]);
    NSLog(@"%@", D_Data);
    NSLog(@"%@", D_Data2);
    
    
    
    
    
    NSDictionary *dic = @{@"D_Data":D_Data,@"VER":[self.setting strForKey:@"Identy"],@"M_Data":M_Data,@"D_Data2":D_Data2};
    return dic;
}

-(NSDictionary *)GetBS{
    XinZenHeaderViewController *vc1 = (XinZenHeaderViewController *) [self.mutileView.viewControllers objectAtIndex:0];
    XinZenDetailViewController *vc2 = (XinZenDetailViewController *)[self.mutileView.viewControllers objectAtIndex:1];
    
    NSDictionary *hInfo = vc1.allInfo;
    NSMutableArray *dInfo = [NSMutableArray array];
    [dInfo addObjectsFromArray:vc2.products];
    [dInfo addObjectsFromArray:vc2.delProducts];
    
    
    NSString *stockID = @"-1";
    NSString *dpID = @"0";
    NSString *strDate1 = @"";
    NSString *strDate2 = @"";//部门ID
    
    if ([(NSArray *)[hInfo objectForKey:@"6"] count] > 0) {
        stockID = [[hInfo objectForKey:@"6"] objectAtIndex:0];
    }
    
    if ([(NSArray *)[hInfo objectForKey:@"5"] count] > 0) {
        dpID = [[hInfo objectForKey:@"5"] objectAtIndex:0];
    }
    
    if ([(NSArray *)[hInfo objectForKey:@"1"] count] > 0) {
        strDate1 = [[hInfo objectForKey:@"1"] objectAtIndex:1];
    }
    
    if ([(NSArray *)[hInfo objectForKey:@"7"] count] > 0) {
        strDate2 = [[hInfo objectForKey:@"7"] objectAtIndex:1];
    }
    
    
    
    NSArray *M_Data = @[[NSNumber numberWithInt:[self.InvId integerValue]],     //0 单据ID
                        [[hInfo objectForKey:@"2"] ingoreObjectAtIndex:1],      //1 单据编号
                        [NSNumber numberWithInt:0],                             //2 单据标识
                        [self numValue:[[hInfo objectForKey:@"0"] ingoreObjectAtIndex:0]],  //3 单据类型
                        strDate1,// [[hInfo objectForKey:@"1"] ingoreObjectAtIndex:1],      //4 单据日期
                        [self GetCurrentTime],                  //5 单据时间
                        strDate2,// [[hInfo objectForKey:@"7"] ingoreObjectAtIndex:1],//6 到货日期
                        [self numValue:[[hInfo objectForKey:@"3"] ingoreObjectAtIndex:0]],  //7 往来单位ID
                        stockID,// [self numValue:[[hInfo objectForKey:@"6"] ingoreObjectAtIndex:0]],  //8 入库仓库ID  ?????????
                        [self numValue:[[hInfo objectForKey:@"4"] ingoreObjectAtIndex:0]],  //9 经手人ID
                        dpID,//[[hInfo objectForKey:@"5"] ingoreObjectAtIndex:0],                  //10 部门ID   ??????
                        [[hInfo objectForKey:@"8"] ingoreObjectAtIndex:1],  //11 摘要
                        [self floatValue:vc2.count],//12 数量 单据商品合计数量
                        [self floatValue:vc2.total],//13 金额
                        [self floatValue:vc2.disTotal],//14 折后金额
                        [self floatValue:vc2.disTotal],//15 含税金额
                        [self floatValue:@"0"],//16 赠品总金额
                        [self numValue:[self GetUserID]]]; //17 用户id
    NSMutableArray *D_Data = [NSMutableArray array];
    for (NSDictionary *rs in dInfo){
        NSMutableArray *rsd = [NSMutableArray array];
        //0 明细ID
        if (self.InvId == 0) {
            [rsd addObject:[self numValue:@"0"]];//新增
        }else{
            [rsd addObject:[self numValue:[rs strForKey:@"ListID"]]];//修改
        }
        [rsd addObject:[self numValue:self.InvId]];                       //1 单据ID
        [rsd addObject:[self numValue:stockID]];  //2 仓库ID ?????????????
        [rsd addObject:[self numValue:[rs strForKey:@"商品ID"]]];     //3 商品ID
        [rsd addObject:[self numValue:[rs strForKey:@"数量"]]];       //4 数量
        [rsd addObject:[self numValue:[rs strForKey:@"单位ID"]]];     //5 单位ID
        [rsd addObject:[self floatValue:[rs strForKey:@"单价"]]];     //6 单价
        [rsd addObject:[self floatValue:[rs strForKey:@"金额"]]];     //7 金额
        [rsd addObject:[self floatValue:[rs strForKey:@"折后单价"]]];   //8 折后单价
        [rsd addObject:[self numValue:[rs strForKey:@"折扣"]]];           //9 折扣
        [rsd addObject:[self floatValue:[rs strForKey:@"折后金额"]]];       //10 折后金额
        [rsd addObject:[self floatValue:[rs strForKey:@"含税单价"]]];       //11 含税单价
        [rsd addObject:[self floatValue:@"0"]];//12 税率
        [rsd addObject:[self floatValue:[rs strForKey:@"含税金额"]]];       //13 含税金额
        [rsd addObject:[self numValue:[rs strForKey:@"赠品"]]];           //14 是否赠送商品
        [rsd addObject:[rs strForKey:@"备注"]];                           //15 备注
        
        [D_Data addObject:rsd];
    }
    NSMutableArray *D_Data2 = [NSMutableArray array];
    [D_Data2 addObject:@[[self numValue:self.AccID],
                         [self numValue:self.InvId],
                         [self numValue:[[hInfo objectForKey:@"9"] ingoreObjectAtIndex:0]],
                         [self floatValue:[[hInfo objectForKey:@"10"] ingoreObjectAtIndex:1]]]
     ];
    
    NSLog(@"%@", [M_Data objectAtIndex:13]);
    NSLog(@"%@", D_Data);
    NSLog(@"%@", D_Data2);
    
    
    
    
    
    NSDictionary *dic = @{@"D_Data":D_Data,@"VER":[self.setting strForKey:@"Identy"],@"M_Data":M_Data,@"D_Data2":D_Data2};
    return dic;
}

-(void)print{
    XinZenHeaderViewController *vc1 = (XinZenHeaderViewController *) [self.mutileView.viewControllers objectAtIndex:0];
    XinZenDetailViewController *vc2 = (XinZenDetailViewController *)[self.mutileView.viewControllers objectAtIndex:1];
    NSDictionary *hInfo = vc1.allInfo;
    NSArray *dInfo = vc2.products;
    NSMutableArray *dataSource=[NSMutableArray array];
    
    [dataSource addObject:[NSString stringWithFormat:@"%@",[[hInfo objectForKey:@"5"] ingoreObjectAtIndex:1]]];//往来单位
    [dataSource addObject:[NSString stringWithFormat:@"单据编号:%@",[[hInfo objectForKey:@"2"] ingoreObjectAtIndex:1]]];
    [dataSource addObject:[NSString stringWithFormat:@"单据时间:%@",[[hInfo objectForKey:@"1"] ingoreObjectAtIndex:1]]];
    [dataSource addObject:[NSString stringWithFormat:@"经手人:%@",[[hInfo objectForKey:@"3"] ingoreObjectAtIndex:1]]];
    [dataSource addObject:@"========================="];
    [dataSource addObject:@"商品    数量   单价    金额"];
    [dataSource addObject:@"-------------------------"];
    
    //    float total=0;
    //    int cnt = 0;
    for (NSDictionary *rs in dInfo) {
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@ %@",[rs strForKey:@"名称"],[rs strForKey:@"数量"],[rs strForKey:@"单价"],[rs strForKey:@"折后金额"]];
        //        total+=[[rs strForKey:@"折后金额"] floatValue];
        //        cnt += [[rs strForKey:@"数量"] integerValue];
        [dataSource addObject:str];
    }
    
    [dataSource addObject:@"-------------------------"];
    [dataSource addObject:[NSString stringWithFormat:@"总数量:%d",[vc2.count intValue]]];
    [dataSource addObject:[NSString stringWithFormat:@"总金额:%.2f",[vc2.disTotal doubleValue]]];
    [dataSource addObject:[NSString stringWithFormat:@"打印日期:%@",[self GetCurrentDateTime]]];
    [dataSource addObject:[NSString stringWithFormat:@"客户签名:"]];
    [self printText:dataSource];
    //    UIImage *printImage = [tableView screenshot];
    //    UIImage * scaleImage = [self scaleToSize:printImage size:CGSizeMake(595, 1660)];
    //
    //    UIImage *jietuImage = [self imageFromImage:scaleImage inRect:CGRectMake(0, 0, 595, 880)];
    
    
    /*
     UIPrintInteractionController *printC = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
     printC.delegate = self;
     
     if (!printC) {
     NSLog(@"打印机初始化失败");
     }
     printC.showsNumberOfCopies = YES;
     printC.showsPageRange = YES;
     //    NSData *imgDate = UIImagePNGRepresentation(jietuImage);
     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataSource];
     BOOL canPrint = [UIPrintInteractionController canPrintData:data];
     if (printC && [UIPrintInteractionController canPrintData:data]) {
     UIPrintInfo *printInfo = [UIPrintInfo printInfo];//准备打印信息以预设值初始化的对象。
     printInfo.outputType = UIPrintInfoOutputGrayscale;//设置输出类型。B&W content only
     
     //        printC.showsPageRange = YES;//显示的页面范围
     
     printInfo.jobName = @"新增订单";
     printC.printInfo = printInfo;
     printC.printingItem = data;//single NSData, NSURL, UIImage, ALAsset
     
     // 等待完成
     void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
     ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
     if (!completed && error) {
     NSLog(@"可能无法完成，因为印刷错误: %@", error);
     }
     };
     
     [printC presentAnimated:YES completionHandler:completionHandler];//在iPhone上弹出打印那个页面
     }else{
     [self ShowMessage:@"没有数据打印"];
     }
     */
    
}

//绘制原图 这个就是将原图改变为A4 纸宽度的图片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(20,20,size.width,size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


//截取原图  截取部分 打印的图片就是从这里来
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
    
}

-(void)printText:(NSArray *)array{
    NSMutableString *stringToPrint = [[NSMutableString alloc] initWithString:@""];
    for(int i = 0;i<[array count];i++)
    {
        [stringToPrint appendFormat:@"%@",[array objectAtIndex:i]];
        
        [stringToPrint appendFormat:@"\n"];
        
    }
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"新增订单";
    pic.printInfo = printInfo;
    
    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc]
                                                 initWithText:stringToPrint];
    textFormatter.startPage = 0;
    textFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
    textFormatter.maximumContentWidth = 6 * 72.0;
    pic.printFormatter = textFormatter;
    pic.showsPageRange = YES;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error)
    {
        if (!completed && error)
        {
            NSLog(@"Printing could not complete because of error: %@", error);
        }
    };
    
    [pic presentAnimated:YES completionHandler:completionHandler];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
