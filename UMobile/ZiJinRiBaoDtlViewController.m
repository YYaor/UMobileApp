//
//  ZiJinRiBaoDtlViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/21.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "ZiJinRiBaoDtlViewController.h"

@interface ZiJinRiBaoDtlViewController ()

@end

@implementation ZiJinRiBaoDtlViewController
@synthesize result;
@synthesize callFunction,callType,callID;
@synthesize navTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.navTitle;
    self.result = [NSMutableArray array];
    self.tableView.rDelegate = self;
    self.tableView.bFooterRefreshing = YES;
    
    page = 1;
    [self setFilterButton];
    
    if (self.callFunction == 16 | self.callFunction == 17){
        self.tableView.titles = @[@"账户编码",@"账户名称",@"期初",@"收入",@"支出",@"金额"];
        self.tableView.titleWidths = @[@"120",@"80",@"80",@"80",@"80",@"80"];
        self.tableView.keys = @[@"0",@"1",@"2",@"3",@"4",@"5"];
        self.tableView.countColumns = @[@"",@"",@"1",@"1",@"1",@"1"];
        self.tableView.bCountTotal = YES;
        self.fliterDic = [NSMutableDictionary dictionaryWithObject:@"" forKey:@"0"];//清空条件
    }else if (self.callFunction == 19){
        self.tableView.titles = @[@"客户名称",@"收款金额"];
        self.tableView.titleWidths = @[@"120",@"80"];
        self.tableView.keys = @[@"0",@"1"];
        // add count
        self.fliterDic = [NSMutableDictionary dictionaryWithObject:@"" forKey:@"0"];//清空条件
        self.tableView.countColumns = @[@"",@"1"];
        self.tableView.bCountTotal = YES;
    }else if (self.callFunction == 20){
        self.fliterDic = [NSMutableDictionary dictionaryWithObject:@"" forKey:@"0"];
        self.tableView.titles = @[@"供应商名称",@"付款金额"];
        self.tableView.titleWidths = @[@"120",@"80"];
        self.tableView.keys = @[@"0",@"1"];
        // add count
        self.tableView.countColumns = @[@"",@"1"];
        self.tableView.bCountTotal = YES;
    }else if (self.callFunction == 21){
        self.fliterDic = [NSMutableDictionary dictionaryWithObject:@"-1" forKey:@"4"];//清空条件
        
        self.tableView.bCountTotal = YES;
        self.tableView.titles = @[@"单据编号",@"单据日期",@"单据类型",@"客户名称",@"经手人",@"数量",@"含税金额"];
        self.tableView.titleWidths = @[@"100",@"100",@"80",@"100",@"100",@"50",@"80"];
        self.tableView.keys = @[@"0",@"1",@"2",@"4",@"3",@"5",@"6"];
        self.tableView.countColumns = @[@"",@"",@"",@"",@"",@"1",@"1"];
        self.tableView.fixColumn = 2;
    }else if (self.callFunction == 22){
        self.fliterDic = [NSMutableDictionary dictionaryWithObject:@"-1" forKey:@"4"]; //清空条件
        
        self.tableView.titles = @[@"单据编号",@"单据日期",@"单据类型",@"供应商名称",@"业务员",@"数量",@"金额"];
        self.tableView.titleWidths = @[@"80",@"120",@"60",@"60",@"120",@"120",@"120"];
        self.tableView.keys = @[@"1",@"0",@"2",@"4",@"3",@"5",@"6"];
        self.tableView.bCountTotal = YES;
        self.tableView.countColumns = @[@"",@"",@"",@"",@"",@"1",@"1"];
        self.tableView.fixColumn = 2;
    }else if (self.callFunction == 30){//销售日报
        self.tableView.bFooterRefreshing = NO;
        self.fliterDic = [NSMutableDictionary dictionaryWithObject:@"" forKey:@"0"];//清空条件
        
        if (self.callType == 0){
            self.tableView.titles = @[@"商品编号",@"商品名称",@"数量",@"金额"];
            self.tableView.titleWidths = @[@"100",@"150",@"100",@"100"];
            self.tableView.keys = @[@"1",@"0",@"5",@"2"];
            self.tableView.bCountTotal = YES;
            self.tableView.countColumns = @[@"",@"",@"1",@"1"];
        }else if (self.callType == 1){
            self.tableView.titles = @[@"商品编号",@"商品名称",@"数量",@"金额"];
            self.tableView.titleWidths = @[@"100",@"150",@"100",@"100"];
            self.tableView.keys = @[@"0",@"1",@"5",@"2"];
            self.tableView.bCountTotal = YES;
            self.tableView.countColumns = @[@"",@"",@"1",@"1"];
        }else if (self.callType == 2){
            self.tableView.titles = @[@"客户编号",@"客户名称",@"数量",@"金额"];
            self.tableView.titleWidths = @[@"100",@"150",@"100",@"100"];
            self.tableView.keys = @[@"0",@"1",@"5",@"2"];
            self.tableView.bCountTotal = YES;
            self.tableView.countColumns = @[@"",@"",@"1",@"1"];
        }else if (self.callType == 3){
            self.tableView.titles = @[@"业务员编号",@"业务员名称",@"数量",@"金额"];
            self.tableView.titleWidths = @[@"100",@"150",@"100",@"100"];
            self.tableView.keys = @[@"0",@"1",@"5",@"2"];
            self.tableView.bCountTotal = YES;
            self.tableView.countColumns = @[@"",@"",@"1",@"1"];
        }
        
    }else if (self.callFunction == 33){
        self.tableView.titles = @[@"供应商编号",@"供应商名称",@"数量",@"金额"];
        self.tableView.titleWidths = @[@"100",@"120",@"120",@"120"];
        self.tableView.keys = @[@"1",@"2",@"3",@"4"];
        self.tableView.bCountTotal = YES;
        self.tableView.countColumns = @[@"",@"",@"1",@"1"];
        self.fliterDic = [NSMutableDictionary dictionaryWithObject:@"" forKey:@"0"];//清空条件
        
    }else if (self.callFunction == 36 | self.callFunction == 39){
        self.tableView.titles = @[@"科目编码",@"科目名称",@"金额"];
        self.tableView.titleWidths = @[@"100",@"150",@"150"];
        self.tableView.countColumns = @[@"",@"",@"1"];
        self.tableView.keys = @[@"1",@"2",@"3"];
        self.tableView.countColumns = @[@"",@"",@"1"];
        self.tableView.bCountTotal = YES;
    }else if (self.callFunction == 37){
        self.tableView.titles = @[@"单据日期",@"单据编号",@"单据类型",@"科目编码",@"科目名称",@"金额"];
        self.tableView.titleWidths = @[@"100",@"120",@"80",@"10",@"120",@"80"];
        self.tableView.keys = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    }
    
    
    
    [self setSegmentController];
//    [self loadResult];
    [self loadData];

    // Do any additional setup after loading the view.
}

-(void)setSegmentController{
    __block ZiJinRiBaoDtlViewController *tempSelf = self;
    [self.segment setItem:@[@{@"text":@"今天"},@{@"text":@"本周"},@{@"text":@"本月"},@{@"text":@"本季"}] andSelectionBlock:^(NSUInteger segmentIndex) {
        page = 1;
        self.fliterDic = [NSMutableDictionary dictionaryWithObject:@"-1" forKey:@"4"]; //清空条件
        [tempSelf.result removeAllObjects];
        [tempSelf loadData];
//        [tempSelf tableFooterRefreshing];
    }];
    
    self.segment.color= [UIColor colorWithRed:0.0f/255.0 green:141.0f/255.0 blue:147.0f/255.0 alpha:1];;// [UIColor colorWithRed:88.0f/255.0 green:88.0f/255.0 blue:88.0f/255.0 alpha:1];
    self.segment.borderWidth=0.5;
    self.segment.borderColor=[UIColor darkGrayColor];
    self.segment.selectedColor= [UIColor orangeColor] ;//[UIColor colorWithRed:0.0f/255.0 green:141.0f/255.0 blue:147.0f/255.0 alpha:1];
    self.segment.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                              NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.segment.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                      NSForegroundColorAttributeName:[UIColor whiteColor]};
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView initContent];
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

-(void)helpClick{
    NSDictionary *msgs = @{@"20":@"取自系统往来单位付款统计",
                           @"19":@"取自系统收款统计",
                           @"18":@"取自系统库存分布表",
                           @"17":@"取自系统现金帐户明细帐、银行存款明细帐。默认进去是本天的数据",
                           @"16":@"取自系统现金帐户明细帐、银行存款明细帐。默认进去是本天的数据",
                           @"30":@{@"0":@"取自系统商品销售统计当天数据",@"1":@"取自系统商品销售统计当天数据",
                                   @"2":@"取自系统往来单位销售统计当天数据",@"3":@"取自系统职员销售统计当天数据"},
                           @"33":@"取自系统进销存明细帐当天数据。查询条件为上级操作选择的单据"
                           };
    NSString *strmsg = nil;
    if (self.callFunction == 30) {
        strmsg = [[msgs objectForKey:@"30"] strForKey:[NSString stringWithFormat:@"%d",self.callType]];
    }else {
        strmsg = [msgs strForKey:[NSString stringWithFormat:@"%d",self.callFunction]];
    }
    UIAlertView *alertView = [[[UIAlertView alloc]initWithTitle:@"取数规则"
                                                        message:strmsg
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
    [alertView show];
}

-(void)filterClick{
    NSDictionary *msgs = @{@"20":@"请输入供应商名称或编号查询", // 今日付款
                           @"19":@"请输入客户名称或编号查询",// 今日收款
                           @"17":@"请输入账户名或编码查询", // 银行存款
                           @"16":@"请输入账户名或编码查询", //银行余额
                           @"30":@{@"0":@"请输入商品名称或编码查询",@"1":@"请输入商品名称或编码查询",
                                   @"2":@"请输入客户名称或编码查询",@"3":@"请输入业务员名称或编码查询"}, //销售日报统计
                           @"33":@"请输入供应商名称或编号查询"
                           };
   NSString *strmsg = nil;
   if (self.callFunction == 30) {
       strmsg = [[msgs objectForKey:@"30"] strForKey:[NSString stringWithFormat:@"%d",self.callType]];
   }else {
       strmsg = [msgs strForKey:[NSString stringWithFormat:@"%d",self.callFunction]];
   }
    RCAlertView *alertView =  [[[RCAlertView alloc]initwithOrientation:ViewOrientation_horizontal] autorelease];
    [alertView ShowViewInObject:self.view
                        withMsg:strmsg
                       PhoneNum:[self.fliterDic strForKey:@"0"]];
    
    while(alertView.isVisiable) {
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    }
    if (alertView.isOk){
        [self.fliterDic setObject:alertView.num forKey:@"0"];
        [self loadResult];
//        [self loadDataWithNum:alertView.num];
    }
}

//筛选按钮
-(void)rightBarButtonClick:(id)sender{
    XXFliterViewController *vc = (XXFliterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"XXFliterViewController"];
    vc.fliterDic = self.fliterDic;
    vc.parentVC = self;
    vc.names = @[@"",@"",@"单据编号",@""];
    vc.callFunction = self.callFunction;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setFilterButton{
    
    //这个方法要加条件判断 ，因为多个界面共用 ， 若不判断 ，则会产生 没有筛选按钮的界面也会显示按钮
    
    if (self.callFunction == 20 || self.callFunction == 19 || self.callFunction == 16 || self.callFunction == 17
        || self.callFunction == 30 || self.callFunction == 33) {// 右上添加两个按钮方法
        
        //今日付款 今日收款 银行存款 银行余额
        //销售日报 采购日报 
        UIBarButtonItem *barButtonItem = [[[UIBarButtonItem alloc]initWithCustomView:[self rightView]] autorelease];
        self.navigationItem.rightBarButtonItem  = barButtonItem;
        
    }else if (self.callFunction == 21 || self.callFunction == 22){// 右上添加一个按钮
        
        UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter2"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)] autorelease];
        self.navigationItem.rightBarButtonItem = rightButton;
    }else if (self.callFunction == 18){
        // 库存金额汇总，只显示 帮助信息
        UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"help"] style:UIBarButtonItemStylePlain target:self action:@selector(helpClick)] autorelease];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    
}



-(void)loadResult{
    NSString *link = nil ;
    NSString *param = nil;
    if (self.callFunction == 16 | self.callFunction == 17){
        param = [NSString stringWithFormat:@"20,%d,'%@','%@',%d,%@",
                 page,
                 [[self.fliterDic strForKey:@"0"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                 [self GetCurrentDate],
                 self.segment.selectIndex,
                 [self GetUserID]];
    }else if (self.callFunction == 19 | self.callFunction == 20 ){
        // change     20150126
        param = [NSString stringWithFormat:@"20,%d,'%@','','','%@',%d,%@",
                 page,
                 [[self.fliterDic strForKey:@"0"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],//客户/供应商 编号或名称
                 [self GetCurrentDate],
                 self.segment.selectIndex,
                 [self GetUserID]];
        // fixBug       ghd         20150122
    }else if (self.callFunction == 30){
        //param = [NSString stringWithFormat:@"20,%d,'',%d,%d,1",page,self.segment.selectIndex,self.callType];
        param = [NSString stringWithFormat:@"20,'%@','%@',%d,%d,%@",
                 [[self.fliterDic strForKey:@"0"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                 [self GetCurrentDate],
                 self.segment.selectIndex,
                 self.callType,
                 [self GetUserID]];
        
    }else if (self.callFunction == 33){
        param = [NSString stringWithFormat:@"20,'%@','%@',%d,%@",
                 [[self.fliterDic strForKey:@"0"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                 [self GetCurrentDate],self.segment.selectIndex,[self GetUserID]];
    }else if (self.callFunction == 36){
        param = [NSString stringWithFormat:@"20,%d,0,'%@',%d,%@",page,[self GetCurrentDate],self.segment.selectIndex,[[self setting] objectForKey:@"UID"]];
    }else if (self.callFunction == 37){
        param = [NSString stringWithFormat:@"20,%d,0,0,'%@',%d,%@",page,[self GetCurrentDate],self.segment.selectIndex,[[self setting] objectForKey:@"UID"]];
    }else if (self.callFunction == 39){
        param = [NSString stringWithFormat:@"20,%d,0,'%@',%d,%@",page,[self GetCurrentDate], self.segment.selectIndex,[[self setting] objectForKey:@"UID"]];
        
    }else if (self.callFunction == 21 | self.callFunction == 22){
        //今日销售列表 ，今日采购列表   加上了  筛选条件
        
        // change  last parameter 1 -> -1  20150126
        NSUInteger invId = [[self.fliterDic strForKey:@"4"] integerValue] == 0 ? -1: [[self.fliterDic strForKey:@"4"] integerValue];
        param = [NSString stringWithFormat:
                 @"20,%d,'%@','%@','%@','%@',%d,%@,%d",
                 page,
                 [[self.fliterDic strForKey:@"2"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                 [self.fliterDic strForKey:@"3"],
                 [[self.fliterDic strForKey:@"1"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                 [self GetCurrentDate],self.segment.selectIndex,[self GetUserID],
                 invId
                 ];
//        param = [NSString stringWithFormat:@"20, %d, '', '', '', '%@', %d, 1, -1", page, [self GetCurrentDate], self.segment.selectIndex];
    }
    
    link = [self GetLinkWithFunction:self.callFunction andParam:param];
    if (page == 1) {
        //重新加载时，清除所有数据，以免重复添加
        [self.result removeAllObjects];
    }
    __block ZiJinRiBaoDtlViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        if (obj != nil) {
            NSMutableString *str = [NSMutableString stringWithString:[NSMutableString deleteSpecialChar:obj]];
            
            NSArray *rs =  [[str objectFromJSONString] objectForKey:@"D_Data"];
            [tempSelf.tableView footerEndRefreshing];
            if ([rs count] > 0){
                [tempSelf.result addObjectsFromArray:rs];
                
            }else {
                if (page > 1)
                    page -- ;
            }
            tempSelf.tableView.result = self.result;
        }
        
        
    } lock:YES];
}

-(void)loadData{
    NSString *link = nil ;
    NSString *param = nil;
    page = 1;
    [self.result removeAllObjects];
    if (self.callFunction == 16 | self.callFunction == 17){
        param = [NSString stringWithFormat:@"20,%d,'%@','%@',%d,%@",
                 page,
                 [[self.fliterDic strForKey:@"0"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],//客户编号或名称
                 [self GetCurrentDate],
                 self.segment.selectIndex,
                 [self GetUserID]];
    }else if (self.callFunction == 19 | self.callFunction == 20 ){//今日收款 今日付款
        param = [NSString stringWithFormat:@"20,%d,'%@','','','%@',%d,%@",
                 page,
                 [[self.fliterDic strForKey:@"0"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],//客户/供应商 编号或名称
                 [self GetCurrentDate],
                 self.segment.selectIndex,
                 [self GetUserID]];
        // fixBug       ghd         20150122
    }else if (self.callFunction == 30){
        
        param = [NSString stringWithFormat:@"20,'','%@',%d,%d,%d",[self GetCurrentDate],self.segment.selectIndex,self.callType, [[self GetUserID] intValue]];

    }else if (self.callFunction == 33){
        param = [NSString stringWithFormat:@"20,'%@','%@',%d,%@",
                 [[self.fliterDic strForKey:@"0"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                 [self GetCurrentDate],self.segment.selectIndex,[self GetUserID]];
    }else if (self.callFunction == 36){//费用日报统计

        param = [NSString stringWithFormat:@"20,%d,0,'%@',%d,%@",page,[self GetCurrentDate],self.segment.selectIndex,[self GetUserID]];
    }else if (self.callFunction == 37){
        param = [NSString stringWithFormat:@"20,%d,0,0,'%@',%d,''",page,[self GetCurrentDate],self.segment.selectIndex];
    }else if (self.callFunction == 39){
        param = [NSString stringWithFormat:@"20,%d,0,'%@',%d,1",page,[self GetCurrentDate],self.segment.selectIndex];

    }else if (self.callFunction == 21 | self.callFunction == 22){
        //今日销售列表 ，今日采购列表   加上了  筛选条件
        NSUInteger invId = [[self.fliterDic strForKey:@"4"] integerValue] == 0 ? -1: [[self.fliterDic strForKey:@"4"] integerValue];
        param = [NSString stringWithFormat:
                 @"20,%d,'%@','%@','%@','%@',%d,%@,%d",
                 page,
                 [[self.fliterDic strForKey:@"2"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                 [self.fliterDic strForKey:@"3"],
                 [[self.fliterDic strForKey:@"1"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                 [self GetCurrentDate],self.segment.selectIndex,[self GetUserID],
                 invId
                 ];
    }
    
    link = [self GetLinkWithFunction:self.callFunction andParam:param];
    self.tableView.result = nil;
    __block ZiJinRiBaoDtlViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        
        
        if (obj != nil) {
            NSMutableString *str = [NSMutableString stringWithString:[NSMutableString deleteSpecialChar:obj]];
            
            NSArray *rs =  [[str objectFromJSONString] objectForKey:@"D_Data"];
        
            if ([rs count] > 0){
                tempSelf.result = [NSMutableArray arrayWithArray:rs];
                tempSelf.tableView.result = self.result;
            }else {
                if (page > 1)
                    page -- ;
            }
        }
        
    } lock:YES];
}



-(void)tableFooterRefreshing{
    if (self.callFunction == 30 || self.callFunction == 33) {
        self.tableView.result = nil;
        [self loadResult];
    }
    else
    {
        page ++;
        self.tableView.result = nil;
        [self loadResult];
    }
}

-(void)tableViewClickAtIndex:(NSUInteger)index withObject:(id)obj{
    if (self.callFunction == 30) {
        RiBaoDtlViewController *vc = (RiBaoDtlViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"RiBaoDtlViewController"];
        vc.callFunction = 31;
        vc.dateType = self.segment.selectIndex;
        vc.callType = self.callType;
        vc.sId = [[self.result objectAtIndex:index] objectAtIndex:6];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.callFunction == 33){
        RiBaoDtlViewController *vc = (RiBaoDtlViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"RiBaoDtlViewController"];
        vc.callFunction = 34;
        vc.dateType = self.segment.selectIndex;
        vc.sId = [[self.result objectAtIndex:index] objectAtIndex:0];
        vc.callType = 5;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.fliterDic = nil;
    self.navTitle = nil;
    self.result = nil;
    [_tableView release];
    [_segment release];
    [super dealloc];
}

@end
