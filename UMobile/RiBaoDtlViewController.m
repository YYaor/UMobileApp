//
//  RiBaoDtlViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/21.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RiBaoDtlViewController.h"
#import "XXFliterViewController.h"

@interface RiBaoDtlViewController ()

@end

@implementation RiBaoDtlViewController

@synthesize result;
@synthesize callFunction;
@synthesize navTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)headerRereshing
{
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Do any additional setup after loading the view.




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    page = 1;
    self.result = [NSMutableArray array];
    self.fliterDic = [NSMutableDictionary dictionary];
    nColumn = 1;
    if (self.fixColumn > 0) {
        nColumn = self.fixColumn;
    }
    self.tableView.fixColumn = nColumn;
    [self loadCallFunction];
    [self loadData];
    
    
    // fixBug      ghd      20150123
//    self.tableView.bFooterRefreshing = YES;
    // Do any additional setup after loading the view.
    
    // add
    if (self.navTitle.length != 0) {
        self.navigationItem.title = self.navTitle;
    }else
    {
        if (self.callType == 2) {
            self.navigationItem.title = @"客户销售明细";
            
        }else if (self.callType == 3)
        {
            self.navigationItem.title = @"业务员销售明细";
        }else if (self.callType == 1 || self.callType == 0)
        {
            self.navigationItem.title = @"商品销售明细";
        }else if (self.callType == 5)
        {
            self.navigationItem.title = @"商品采购明细";
        }
    }
    [self setFilterButton];
    
}

//-(void)setFilterButton{
//    
//    //这个方法要加条件判断 ，因为多个界面共用 ， 若不判断 ，则会产生 没有筛选按钮的界面也会显示按钮
//    
//    if (self.callFunction == 20 || self.callFunction == 19 || self.callFunction == 16 || self.callFunction == 17
//        || self.callFunction == 30 || self.callFunction == 33) {// 右上添加两个按钮方法
//        
//        //今日付款 今日收款 银行存款 银行余额
//        //销售日报 采购日报
//        UIBarButtonItem *barButtonItem = [[[UIBarButtonItem alloc]initWithCustomView:[self rightView]] autorelease];
//        self.navigationItem.rightBarButtonItem  = barButtonItem;
//        
//    }else if (self.callFunction == 21 || self.callFunction == 22){// 右上添加一个按钮
//        
//        UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter2"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)] autorelease];
//        self.navigationItem.rightBarButtonItem = rightButton;
//    }else if (self.callFunction == 18){
//        // 库存金额汇总，只显示 帮助信息
//        UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"help"] style:UIBarButtonItemStylePlain target:self action:@selector(helpClick)] autorelease];
//        self.navigationItem.rightBarButtonItem = rightButton;
//    }
//    
//}

//筛选按钮
-(void)rightBarButtonClick:(id)sender{
    XXFliterViewController *vc = (XXFliterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"XXFliterViewController"];
    vc.fliterDic = self.fliterDic;
    vc.parentVC = self;
    vc.callFunction = self.callFunction;
    [self.navigationController pushViewController:vc animated:YES];
}













-(void)viewDidAppear:(BOOL)animated{
    [self.tableView initContent];
}
-(void)loadCallFunction{
    self.navigationItem.title = self.navTitle;
    self.tableView.bFooterRefreshing = YES;
    self.tableView.bCountTotal = YES;
//    self.tableView.rowHeight = 45;
    if (self.callFunction == 55 ){
        self.tableView.bCountTotal = NO;
        self.fliterDic = [NSMutableDictionary dictionary];
        self.tableView.titles = @[@"单据日期",@"单据类型",@"单据编号",@"客户名称",@"业务员",@"增加",@"减少",@"期末余额"];
        self.tableView.titleWidths = @[@"80",@"80",@"120",@"100",@"80",@"50",@"50",@"80"];
        self.tableView.countColumns = @[@"",@"",@"",@"",@"",@"1",@"1",@"1"];
        self.tableView.keys = @[@"1",@"2",@"3",@"4",@"5",@"7",@"8",@"9"];
        [self setFilterButton];
    }else if (self.callFunction == 28 | self.callFunction == 25){
        self.fliterDic = [NSMutableDictionary dictionary];
        self.tableView.fixColumn = 2;
        self.tableView.titles = @[@"单据日期",@"单据编号",@"业务员",@"客户名称",@"资金增加",@"资金减少",@"期末余额"];
        self.tableView.titleWidths = @[@"100",@"80",@"80",@"100",@"100",@"100",@"100"];
        self.tableView.countColumns = @[@"",@"",@"",@"",@"1",@"1",@"1"];
        self.tableView.keys = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6"];
        self.tableView.bCountTotal = NO;
        [self setFilterButton];
    }else if (self.callFunction == 18){
        self.tableView.titles = @[@"库房名称",@"金额"];
        self.tableView.titleWidths = @[@"120",@"80"];
        self.tableView.countColumns = @[@"",@"1"];
        self.tableView.keys = @[@"0",@"1"];
    }else if (self.callFunction == 24){
        self.fliterDic = [NSMutableDictionary dictionary];
        self.tableView.titles = @[@"客户名称",@"当日应收",@"当日已收",@"应收余额"];
        self.tableView.titleWidths = @[@"120",@"100",@"100",@"100"];
        self.tableView.countColumns = @[@"",@"1",@"1",@""];
        self.tableView.keys = @[@"0",@"1",@"2",@"3"];
        self.tableView.bFooterRefreshing = NO;
    }else if (self.callFunction == 27 ){
        self.fliterDic = [NSMutableDictionary dictionary];
        self.tableView.titles = @[@"供应商名称",@"当日应付",@"当日已付",@"应付余额"];
        self.tableView.titleWidths = @[@"120",@"80",@"80",@"80"];
        self.tableView.countColumns = @[@"",@"1",@"1",@""];
        self.tableView.keys = @[@"0",@"1",@"2",@"3"];
        self.tableView.bFooterRefreshing = NO;
    }else if (self.callFunction == 31){
        /*
        self.tableView.titles=@[@"单据编号",@"单据类型",@"单位名称",@"商品编码",@"商品名称",@"数量",@"单位",@"单价",@"规格",@"型号",@"税率",@"含税金额"];
        self.tableView.titleWidths = @[@"140",@"80",@"80",@"80",@"80",@"80",@"50",@"80",@"80",@"80",@"40",@"80"];
        self.tableView.keys = @[@"0",@"1",@"3",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14"];
        self.tableView.countColumns = @[@"",@"",@"",@"",@"",@"1",@"1",@"1",@"0",@"",@"",@"1"];
        self.tableView.bFooterRefreshing = NO;
        */
        [self.fliterDic setObject:@"-1" forKey:@"2"];
        self.tableView.titles=@[@"单据编号",@"单据类型",@"商品名称",@"规格",@"型号",@"单位",@"数量",@"单价",@"折后金额"];
        self.tableView.titleWidths = @[@"80",@"80",@"80",@"120",@"120",@"50",@"80",@"80",@"80"];
//        self.tableView.keys = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"10"];
        self.tableView.keys = @[@"0",@"1",@"7",@"11",@"12",@"9",@"8",@"10",@"15"];
        self.tableView.countColumns = @[@"",@"",@"",@"0",@"",@"",@"1",@"0",@"1"];
        self.tableView.fixColumn = 2;
        self.tableView.bFooterRefreshing = YES;
        [self setFilterButton];
        
    }else if (self.callFunction == 34){ // 商品采购明细
        [self.fliterDic setObject:@"-1" forKey:@"3"];
//        self.fliterDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"-1",@"3", nil];
        self.tableView.titles=@[@"单据编号",@"单据类型",@"商品名称",@"规格",@"型号",@"单位",@"数量",@"折后单价",@"折后金额"];
        self.tableView.titleWidths = @[@"80",@"80",@"80",@"120",@"120",@"50",@"80",@"80",@"80"];
        self.tableView.keys = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"11",@"12"];
        self.tableView.countColumns = @[@"",@"",@"",@"0",@"",@"",@"1",@"0",@"1"];
        self.tableView.fixColumn = 2;
        self.tableView.bFooterRefreshing = YES;
        [self setFilterButton];
    }else if (self.callFunction == 45){
        self.tableView.titles=@[@"单据日期",@"单据编号",@"单据类型",@"客户名称",@"业务员",@"数量",@"折后金额"];
        self.tableView.titleWidths=@[@"100",@"140",@"80",@"100",@"80",@"50",@"100"];
        self.tableView.keys=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6"];
        self.tableView.countColumns = @[@"",@"",@"",@"",@"",@"1",@"1"];
        self.tableView.fixColumn = 2;
        [self setFilterButton];
    }else if (self.callFunction == 46){
        self.tableView.titles = @[@"客户名称",@"应收金额",@"应付金额"];
        self.tableView.titleWidths = @[@"150",@"120",@"120"];
        self.tableView.countColumns = @[@"",@"1",@"1"];
        self.tableView.keys = @[@"0",@"1",@"2"];
        self.tableView.fixColumn = 1;
        self.tableView.bFooterRefreshing = NO;
    }else if (self.callFunction == 47){
        self.tableView.titles=@[@"会员卡号",@"会员名称",@"会员类型",@"生效日期",@"失效日期"];
        self.tableView.titleWidths=@[@"100",@"100",@"80",@"100",@"100"];
        self.tableView.keys=@[@"0",@"1",@"2",@"3",@"4"];
        self.tableView.bCountTotal = NO;
    }else if (self.callFunction == 48){
        self.tableView.titles=@[@"单据日期",@"单据编号",@"单据类型",@"业务员",@"数量",@"折后金额"];
        self.tableView.titleWidths=@[@"100",@"140",@"80",@"100",@"80",@"100"];
        self.tableView.keys=@[@"0",@"1",@"2",@"3",@"4",@"5"];
        self.tableView.countColumns = @[@"",@"",@"",@"",@"1",@"1"];
        self.tableView.fixColumn = 2;
        [self setFilterButton];
    }else if (self.callFunction == 49){
        self.tableView.titles=@[@"单据编号",@"单据日期",@"业务员",@"数量",@"金额"];
        self.tableView.titleWidths=@[@"140",@"100",@"80",@"50",@"100"];
        self.tableView.keys=@[@"0",@"1",@"2",@"3",@"4"];
        self.tableView.countColumns = @[@"",@"",@"",@"1",@"1"];
        self.tableView.fixColumn = 1;
        [self setFilterButton];
    }else if (self.callFunction == 50){
        self.tableView.titles=@[@"单据编号",@"单据类型",@"单据日期",@"业务员",@"金额"];
        self.tableView.titleWidths=@[@"120",@"100",@"100",@"100",@"100"];
        self.tableView.keys=@[@"3",@"1",@"0",@"4",@"2"];
        self.tableView.countColumns = @[@"",@"",@"",@"",@"1"];
        [self setFilterButton];
    }else if (self.callFunction == 79){
        //1.25 客户应收明细
        self.tableView.bCountTotal = NO;
        self.tableView.titles=@[@"单据日期",@"单据编号",@"业务员",@"客户名称",@"增加",@"减少",@"期末余额"];
        self.tableView.titleWidths=@[@"100",@"100",@"100",@"100",@"100",@"100",@"100"];
        self.tableView.keys=@[@"0",@"1",@"3",@"2",@"4",@"5",@"6"];
//        self.tableView.countColumns = @[@"",@"",@"",@"",@"1",@"1",@"1"];
        self.tableView.fixColumn = 2;
        [self setFilterButton];
 
    }

    //筛选条件 25 28 79 三个函数要用到
//    self.fliterDic = [NSMutableDictionary dictionary];
    if (self.callFunction == 25 || self.callFunction == 28 || self.callFunction == 79 || self.callFunction == 48 || self.callFunction == 55) {
        [self.fliterDic setObject:@"-1" forKey:@"2"];
    }else if (self.callFunction == 50 || self.callFunction == 45){
        [self.fliterDic setObject:@"-1" forKey:@"3"];
    }
    
    
    self.tableView.rDelegate = self;
    
    
}
-(void)loadData{
    NSString *link = nil ;
    
    if (self.callFunction == 55){
        NSInteger invId = [self.fliterDic intForKey:@"2"];
        if (invId == -1) invId = 0;
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"%d,'%@',%d,20,%d,%@",[self.sId integerValue],[self.fliterDic strForKey:@"1"],invId,page,[self GetUserID]]];
    }else if (self.callFunction == 25){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,%d,'%@',%@,'%@',%d，%d",page,[self.sId integerValue],[self.fliterDic strForKey:@"1"],[self.fliterDic strForKey:@"2"],[self GetCurrentDate],self.dateType,[self GetUserID]]];
    }else if (self.callFunction == 18){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,'',%d",page, [[self GetUserID] intValue]]];
    }else if (self.callFunction == 28){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,%d,'%@',%@,'%@',%d",page,[self.sId integerValue],[self.fliterDic strForKey:@"1"],[self.fliterDic strForKey:@"2"],[self GetCurrentDate],[self GetUserID]]];
    }else if (self.callFunction == 27 ){//应付日报列表
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,1,'%@','%@',%d",
                                                                     [[self.fliterDic strForKey:@"1"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                                     [self GetCurrentDate],
                                                                     [self GetUserID]]];
    }else if (self.callFunction == 24){//应收日报统计
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,1,'%@','%@',%d",
                                                                     [[self.fliterDic strForKey:@"1"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                                     [self GetCurrentDate],
                                                                     [self GetUserID]]];
    }else if (self.callFunction == 31){
        link = [self GetLinkWithFunction:self.callFunction andParam:
                [NSString stringWithFormat:@"20,%d,%d,'%@','%@',%d,%d,%d,'%@',%d",
                page,
                [self.sId intValue],
                @"",//[[self.fliterDic strForKey:@"1"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                [self GetCurrentDate],
                self.callType,
                self.dateType,
                [[self.fliterDic strForKey:@"2"] intValue],
                [self.fliterDic strForKey:@"1"],
                [[self GetUserID] intValue]]
                ];//
        
    }else if (self.callFunction == 34){
        link = [self GetLinkWithFunction:self.callFunction andParam:
                [NSString stringWithFormat:@"20,%d,%d,'%@','%@',%@,'%@',%d,%d",
                 page,
                 [self.sId intValue],
                 [[self.fliterDic strForKey:@"1"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                 [self.fliterDic strForKey:@"2"],
                 [self.fliterDic strForKey:@"3"],
                 [self GetCurrentDate],
                 self.dateType,
                 [[self GetUserID] intValue]
                 ]];
        
    }else if (self.callFunction == 45 ){
        link = [self GetLinkWithFunction:self.callFunction andParam:
                [NSString stringWithFormat:@"20,%d,%d,'%@','%@',%@,'%@',%@,%d",
                 page,
                 [self.sId integerValue],
                 [[self.fliterDic strForKey:@"2"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                 [[self.fliterDic strForKey:@"1"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                 [self.fliterDic strForKey:@"3"],
                 [self GetCurrentDate],
                 [self GetUserID],self.dateType]
                ];
    }else if (self.callFunction == 46){
        link = [self GetLinkWithFunction:self.callFunction andParam:
                [NSString stringWithFormat:@"20,1,%d,'%@',%@,%d",[self.sId integerValue],[self GetCurrentDate],[self GetUserID],self.dateType == 0 ? 0 : 2]];
    }else if (self.callFunction == 47){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,1,'%@',%@",[self GetCurrentDate],[self GetUserID]]];
    }else if (self.callFunction == 48 ){
        if (self.fliterDic.count == 0) {
            [self.fliterDic setObject:@"-1" forKey:@"2"];
        }
        link = [self GetLinkWithFunction:self.callFunction andParam:
                [NSString stringWithFormat:@"30,%d,%d,'%@',%d,%d,'%@',%@",
                 page,
                 [self.sId integerValue],
                 [self.fliterDic strForKey:@"1"],
                 [[self.fliterDic strForKey:@"2"] intValue],
                 self.dateType == 0 ? 0 : 2,
                 [self GetCurrentDate],
                 [self GetUserID]]];
        
    }else if ( self.callFunction == 49 ){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,%d,'',-1,%d,'%@',%@",page,[self.sId integerValue],self.dateType == 0 ? 0 : 2,[self GetCurrentDate],[self GetUserID]]];
    }else if (self.callFunction == 50){
        link = [self GetLinkWithFunction:self.callFunction andParam:
                [NSString stringWithFormat:@"60,1,%d,'%@',%@,%d,'%@',%@",
                 [self.sId integerValue],
                 [self.fliterDic strForKey:@"1"],[self.fliterDic strForKey:@"3"],
                 self.dateType == 0 ? 0 : 2,[self GetCurrentDate],[[self setting] objectForKey:@"UID"]]];
        
    }else if (self.callFunction == 79){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"%@,0,'%@',%@,%@,'%@'",self.sId,[self.fliterDic strForKey:@"1"],[self.fliterDic strForKey:@"2"],[[self setting] objectForKey:@"UID"],[self GetCurrentDate]]];
    }
    if (page == 1) {
        //重新加载时，清除所有数据，以免重复添加
        [self.result removeAllObjects];
    }
    __block RiBaoDtlViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        
        [tempSelf.tableView footerEndRefreshing];
        if ([rs count] > 0)
            [tempSelf.result addObjectsFromArray:rs];
        else
            if (page > 1) page -- ;

        tempSelf.tableView.result = self.result;

    } lock:YES];
}

// fixBug       ghd     20150123
-(void)tableFooterRefreshing{
    page ++;
    self.tableView.result = nil;
    [self loadData];
    
}
-(void)tableViewClickAtIndex:(NSUInteger)index withObject:(id)obj{
    if (self.callFunction == 24 || self.callFunction == 27 ){ //客户应收明细 客户应付明细
        
        /*
        // add choose   20150126
        NSString *nlink = [NSString string];
        if (self.callFunction == 24) {
            nlink=[self GetLinkWithFunction:25 andParam:
                             [NSString stringWithFormat:@"20,1,'%@','','','%@'",
                              [self GetUserID], [self GetCurrentDate]]];
            
            
        }else
        {
//        //根据 名称 获取 编号
//            nlink=[self GetLinkWithFunction:61 andParam:
//                             [NSString stringWithFormat:@"'%@',0,0,0,0,%@,20,0",
//                              [obj[0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
//                              [[self setting] objectForKey:@"UID"]]];
            // change
            nlink=[self GetLinkWithFunction:28 andParam:
                   [NSString stringWithFormat:@"20,1,'%@','','','%@'",
                    [self GetUserID], [self GetCurrentDate]]];
        }
        */
        
        //通过客户名称查id
        //根据 名称 获取 编号
        NSString *nlink = [NSString string];
        nlink=[self GetLinkWithFunction:10 andParam:
                                     [NSString stringWithFormat:@"20,1,0,'%@',%@",[obj[0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self GetUserID]]];
        
        
        __block RiBaoDtlViewController *tempSelf = self;
        
        //将编号 传 给下一项
        [self StartQuery:nlink completeBlock:^(id obj) {
            NSArray * rs = [[[obj objectFromJSONString] objectForKey:@"D_Data"] objectAtIndex:0];
            RiBaoDtlViewController *vc = (RiBaoDtlViewController *) [tempSelf.storyboard instantiateViewControllerWithIdentifier:@"RiBaoDtlViewController"];
            NSDictionary *dic = @{@"24":@"25",@"27":@"28",@"46":@"79"};//对应调用 24 - 25   27 - 28 
            vc.callFunction = [dic intForKey:[NSString stringWithFormat:@"%d",self.callFunction]];
            vc.navTitle = self.callFunction == 24?@"客户应收明细":@"供应商应付明细";
            vc.dateType = self.dateType;
            vc.sId = [rs objectAtIndex:0];
            [tempSelf.navigationController pushViewController:vc animated:YES];
        } lock:YES];
        

    }else if ( self.callFunction == 46){//日报？
        
        NSString *nlink=[self GetLinkWithFunction:10 andParam:
                         [NSString stringWithFormat:@"20,1,0,'%@',%@",
                          [obj[0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                          [[self setting] objectForKey:@"UID"]]];
        __block RiBaoDtlViewController *tempSelf = self;
        
        [self StartQuery:nlink completeBlock:^(id obj) {
            NSArray *info = [[obj objectFromJSONString] objectForKey:@"D_Data"];
            if ([info count] > 0) {
                NSArray * rs = [info objectAtIndex:0];
                RiBaoDtlViewController *vc = (RiBaoDtlViewController *) [tempSelf.storyboard instantiateViewControllerWithIdentifier:@"RiBaoDtlViewController"];
                //NSDictionary *dic = @{@"23":@"25",@"26":@"28",@"46":@"79"};
                vc.callFunction = 25;// [dic intForKey:[NSString stringWithFormat:@"%d",self.callFunction]];
                vc.navTitle = @"客户应收明细";
                vc.sId = [rs objectAtIndex:0];
                vc.dateType = self.dateType;
                [tempSelf.navigationController pushViewController:vc animated:YES];
            }

        } lock:YES];
        

    }else if (self.callFunction == 260000){//不使用
        RiBaoDtlViewController *vc = (RiBaoDtlViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"RiBaoDtlViewController"];
        vc.callFunction = 28;
        vc.navTitle = @"应付明细";
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    //排行榜单据明细
    if (self.callFunction == 48 || self.callFunction == 49) {
        XXDMXViewController *vc = (XXDMXViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"XXDMXViewController"];
        vc.invNo = self.callFunction == 48?[obj objectAtIndex:1]:[obj objectAtIndex:0];
        vc.strDate = self.callFunction == 48?[obj objectAtIndex:0]:[obj objectAtIndex:1];
        vc.strID = [self GetOrderType:[obj objectAtIndex:2]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    

}

-(UIView *)rightView{
    UIView *v = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 75, 25)] autorelease];
    v.backgroundColor = [UIColor clearColor];
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b1 setBackgroundImage:[UIImage imageNamed:@"filter2"] forState:UIControlStateNormal];
    b1.frame = CGRectMake(0, 0, 25, 25);
    [b1 addTarget:self action:@selector(filterClick) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:b1];
    
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b2 setBackgroundImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
    b2.frame = CGRectMake(50, 0, 25, 25);
    [b2 addTarget:self action:@selector(helpClick) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:b2];
    
    return v;
}

-(void)setFilterButton{
    if (self.callFunction == 48 || self.callFunction == 45 || self.callFunction == 49 || self.callFunction == 50 || self.callFunction == 31 || self.callFunction == 25 || self.callFunction == 34 || self.callFunction == 24 || self.callFunction == 27 || self.callFunction == 55) {
        UIBarButtonItem *barButtonItem = [[[UIBarButtonItem alloc]initWithCustomView:[self rightView]] autorelease];
        self.navigationItem.rightBarButtonItem  = barButtonItem;
    }else if(self.callFunction != 18 && self.callFunction != 46){
        UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter2"] style:UIBarButtonItemStylePlain target:self action:@selector(filterClick)] autorelease];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
}

-(void)helpClick{
    NSDictionary *msgs = @{@"48":@"取自系统经营历程，触及行还可以联查到对应的销售单明细",
                           @"45":@"取自系统经营历程",
                           @"49":@"取自系统订单查询报表，触及行可以联查到其他对应的销售订单明细",
                           @"50":@"取自系统经手人回款，默认取当月回款最多的业务员单据",
                           @"31":@"取自系统进销存明细帐当天数据。查询条件为上级操作选择的单据",
                           @"25":@"联查明细列表-客户应收明细",
                           @"34":@"取自系统进销存明细帐当天数据。查询条件为上级操作选择的单据",
                           @"55":@"联查明细列表-客户应收明细"
                               };
    UIAlertView *alertView = [[[UIAlertView alloc]initWithTitle:@"取数规则"
                                                        message:[msgs strForKey:[NSString stringWithFormat:@"%d",self.callFunction]]
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
    [alertView show];
}

-(void)filterClick{
    if (self.callFunction == 79 || self.callFunction == 25 || self.callFunction == 28 || self.callFunction == 48 || self.callFunction == 31 || self.callFunction == 55) {
       //排行榜 客户应收 商品销售明细 商品采购 筛选
        KHFliterViewController *vc = (KHFliterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"KHFliterViewController"];
        vc.fliterDic = self.fliterDic;
        vc.parentVC = self;
        vc.callFunction = self.callFunction;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.callFunction == 50 || self.callFunction == 45  || self.callFunction == 34) {
        YYYFliterViewController *vc = (YYYFliterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"YYYFliterViewController"];
        vc.fliterDic = self.fliterDic;
        if (self.callFunction == 45)
            vc.names = @[@"业务员"];
        else if (self.callFunction == 50)
            vc.names = @[@"单据日期"];
        else if (self.callFunction == 31 || self.callFunction == 34)
            vc.names = @[@"商品名称"];
        vc.parentVC = self;
        vc.callFunction = self.callFunction;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.callFunction == 24 || self.callFunction == 27){
        NSDictionary *msgs = @{@"24":@"请输入客户名称或编码查询",
                              @"27":@"请输入供应商名称或编码查询"};
        NSString *msgStr = nil;
        if (self.callFunction == 24) {
            msgStr = [msgs strForKey:[NSString stringWithFormat:@"%d",self.callFunction]];

        }else
        {
            msgStr = [msgs strForKey:[NSString stringWithFormat:@"%d",self.callFunction]];
        }
        RCAlertView *alertView =  [[[RCAlertView alloc]initwithOrientation:ViewOrientation_horizontal] autorelease];
        [alertView ShowViewInObject:self.view
                            withMsg:msgStr
                           PhoneNum:@""];
        
        while(alertView.isVisiable) {
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        }
        if (alertView.isOk){
            [self.fliterDic setObject:alertView.num forKey:@"0"];
//            [self loadData];
            [self loadDataWithNum:alertView.num];

        }

    }
    else{
        RCAlertView *alertView =  [[[RCAlertView alloc]initwithOrientation:ViewOrientation_horizontal] autorelease];
        [alertView ShowViewInObject:self.view withMsg:[NSString stringWithFormat:@"请输入单据编号查询"] PhoneNum:@""];
        while(alertView.isVisiable) {
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        }
        if (alertView.isOk){
            NSLog(@"%@",alertView.num);
            [self loadDataWithNum:alertView.num];
        }
    }
}


-(void)loadDataWithNum:(NSString *)num{
    page = 1;
    [self.result removeAllObjects];
    if (self.callFunction == 49) {
        NSString *link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,%d,'',-1,%d,'%@',%@",page,[self.sId integerValue],self.dateType == 0 ? 0 : 2,[self GetCurrentDate],[self GetUserID]]];
        __block RiBaoDtlViewController *tempSelf = self;
        [self StartQuery:link completeBlock:^(id obj) {
            NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
            
            [tempSelf.tableView footerEndRefreshing];
            if ([rs count] > 0)
                [tempSelf.result addObjectsFromArray:rs];
            else
                if (page > 1) page -- ;
            
            tempSelf.tableView.result = tempSelf.result;
        } lock:YES];
    }else{
//        //暂没有用
//        NSString *link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"%d,'%@',0,20,%d,1",[self.sId integerValue],num,page]];
//        __block RiBaoDtlViewController *tempSelf = self;
//        [self StartQuery:link completeBlock:^(id obj) {
//            [tempSelf.result removeAllObjects];
//            NSArray * rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
//            [tempSelf.result addObjectsFromArray:rs];
//            tempSelf.tableView.result = tempSelf.result;
//        } lock:YES];
        
        [self.fliterDic setObject:num forKey:@"1"];
        [self loadData];

    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
