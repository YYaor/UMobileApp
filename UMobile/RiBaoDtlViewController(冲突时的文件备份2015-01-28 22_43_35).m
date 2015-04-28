//
//  RiBaoDtlViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/21.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RiBaoDtlViewController.h"

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
    nColumn = 1;
    if (self.fixColumn > 0) {
        nColumn = self.fixColumn;
    }
    self.tableView.fixColumn = nColumn;
    [self loadCallFunction];
    [self loadData];
    
    self.fliterDic = [NSMutableDictionary dictionary];
    // fixBug      ghd      20150123
//    self.tableView.bFooterRefreshing = YES;

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView initContent];
}
-(void)loadCallFunction{
    self.navigationItem.title = self.navTitle;
    self.tableView.bFooterRefreshing = YES;
    self.tableView.bCountTotal = YES;
    if (self.callFunction == 55 ){
        self.tableView.titles = @[@"单据日期",@"单据类型",@"单据编号",@"客户名称",@"经手人",@"金额",@"资金增加",@"资金减少",@"余额"];
        self.tableView.titleWidths = @[@"80",@"80",@"120",@"100",@"80",@"80",@"50",@"50",@"50"];
        self.tableView.countColumns = @[@"",@"",@"",@"",@"",@"1",@"1",@"1",@"1"];
        self.tableView.keys = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        [self setFilterButton];
    }else if (self.callFunction == 28 | self.callFunction == 25){
        self.tableView.titles = @[@"单据日期",@"单据编号",@"业务员",@"客户名称",@"资金增加",@"资金减少",@"期末余额"];
        self.tableView.titleWidths = @[@"100",@"120",@"80",@"100",@"100",@"100",@"100"];
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
        self.tableView.titles = @[@"客户名称",@"当日应收",@"当日已收",@"应收余额"];
        self.tableView.titleWidths = @[@"120",@"100",@"100",@"100"];
        self.tableView.countColumns = @[@"",@"1",@"1",@"1"];
        self.tableView.keys = @[@"0",@"1",@"2",@"3"];
        self.tableView.bFooterRefreshing = NO;
    }else if (self.callFunction == 27 ){
        self.tableView.titles = @[@"供应商名称",@"应付金额",@"未付金额",@"已付金额"];
        self.tableView.titleWidths = @[@"120",@"80",@"80",@"80"];
        self.tableView.countColumns = @[@"",@"1",@"1",@"1"];
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
        
        self.tableView.titles=@[@"单据编号",@"单据类型",@"商品名称",@"规格",@"型号",@"单位",@"数量",@"单价",@"折后金额"];
        self.tableView.titleWidths = @[@"140",@"80",@"80",@"80",@"80",@"50",@"80",@"80",@"80"];
        self.tableView.keys = @[@"0",@"1",@"7",@"11",@"12",@"9",@"8",@"10",@"15"];
        self.tableView.countColumns = @[@"",@"",@"",@"0",@"",@"",@"1",@"0",@"1"];
        self.tableView.bFooterRefreshing = NO;
        
    }else if (self.callFunction == 45){
        self.tableView.titles=@[@"单据日期",@"单据编号",@"单据类型",@"客户名称",@"业务员",@"数量",@"折后金额"];
        self.tableView.titleWidths=@[@"100",@"140",@"80",@"100",@"80",@"50",@"100"];
        self.tableView.keys=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6"];
        self.tableView.countColumns = @[@"",@"",@"",@"",@"",@"1",@"1"];
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
    }else if (self.callFunction == 49){
        self.tableView.titles=@[@"单据编号",@"单据日期",@"业务员",@"数量",@"金额"];
        self.tableView.titleWidths=@[@"140",@"100",@"80",@"50",@"100"];
        self.tableView.keys=@[@"0",@"1",@"2",@"3",@"4"];
        self.tableView.countColumns = @[@"",@"",@"",@"1",@"1"];
        self.tableView.fixColumn = 2;
    }else if (self.callFunction == 50){
        self.tableView.titles=@[@"单据编号",@"单据类型",@"单据日期",@"业务员",@"金额"];
        self.tableView.titleWidths=@[@"100",@"100",@"100",@"100",@"100"];
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
    self.fliterDic = [NSMutableDictionary dictionary];
    if (self.callFunction == 25 || self.callFunction == 28 || self.callFunction == 79) {
        [self.fliterDic setObject:@"-1" forKey:@"2"];
    }else if (self.callFunction == 50 || self.callFunction == 45){
        [self.fliterDic setObject:@"-1" forKey:@"3"];
    }
    
    
    self.tableView.rDelegate = self;
    
    
}
-(void)loadData{
    NSString *link = nil ;
    
    if (self.callFunction == 55){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"%d,'',0,20,%d,1",[self.sId integerValue],page]];
    }else if (self.callFunction == 25){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,%d,'%@',%@,'%@'",page,[self.sId integerValue],[self.fliterDic strForKey:@"1"],[self.fliterDic strForKey:@"2"],[self GetCurrentDate]]];
    }else if (self.callFunction == 18){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,'',1",page]];
    }else if (self.callFunction == 28){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,%d,'%@',%@,'%@'",page,[self.sId integerValue],[self.fliterDic strForKey:@"1"],[self.fliterDic strForKey:@"2"],[self GetCurrentDate]]];
    }else if (self.callFunction == 27 ){//应付日报列表
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,1,'','%@'",[self GetCurrentDate]]];
    }else if (self.callFunction == 24){//应收日报统计
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,1,'','%@'",[self GetCurrentDate]]];
    }else if (self.callFunction == 31){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,0,'%@','%@',0,%d,-1,'',1",page,self.sId,[self GetCurrentDate],self.dateType]];//Param=20,1,0,'','',0,0,0,'XSD-2014-06-24-00001',1
    }else if (self.callFunction == 45 ){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,1,%d,'','',-1,'%@',%@,2",[self.sId integerValue],[self GetCurrentDate],[self GetUserID]]];
        
    }else if (self.callFunction == 46){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,1,%d,'%@',%@,%d",[self.sId integerValue],[self GetCurrentDate],[[self setting] objectForKey:@"UID"],self.dateType == 0 ? 0 : 2]];
    }else if (self.callFunction == 47){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,1,'%@',%@",[self GetCurrentDate],[self GetUserID]]];
    }else if (self.callFunction == 48 ){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,1,%d,'',-1,%d,'%@',%@",[self.sId integerValue],self.dateType == 0 ? 0 : 2,[self GetCurrentDate],[[self setting] objectForKey:@"UID"]]];
    }else if ( self.callFunction == 49 ){
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"60,1,%d,'',-1,%d,'%@',%@",[self.sId integerValue],self.dateType == 0 ? 0 : 2,[self GetCurrentDate],[[self setting] objectForKey:@"UID"]]];
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
            page -- ;

        tempSelf.tableView.result = self.result;
    } lock:YES];
}

// fixBug       ghd     20150123
-(void)tableFooterRefreshing{
    page ++;
    [self loadData];
}
-(void)tableViewClickAtIndex:(NSUInteger)index withObject:(id)obj{
    if (self.callFunction == 24 || self.callFunction == 27 ){ //客户应收明细 客户应付明细
        
//        NSString *nlink=[self GetLinkWithFunction:79 andParam:
//                         [NSString stringWithFormat:@"%@,0,'',-1,%@,'%@'",
//                          [obj[0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
//                          [[self setting] objectForKey:@"UID"],[self GetCurrentDate]]];
        // add choose   20150126
        NSString *nlink = [NSString string];
        if (self.callFunction == 24) {
            nlink=[self GetLinkWithFunction:25 andParam:
                             [NSString stringWithFormat:@"20,1,'%@','','','%@'",
                              [[self setting] objectForKey:@"UID"], [self GetCurrentDate]]];
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
                    [[self setting] objectForKey:@"UID"], [self GetCurrentDate]]];
        }
        __block RiBaoDtlViewController *tempSelf = self;
        
        //将编号 传 给下一项
        [self StartQuery:nlink completeBlock:^(id obj) {
            NSArray * rs = [[[obj objectFromJSONString] objectForKey:@"D_Data"] objectAtIndex:0];
            RiBaoDtlViewController *vc = (RiBaoDtlViewController *) [tempSelf.storyboard instantiateViewControllerWithIdentifier:@"RiBaoDtlViewController"];
            NSDictionary *dic = @{@"24":@"25",@"27":@"28",@"46":@"79"};//对应调用 24 - 25   27 - 28 
            vc.callFunction = [dic intForKey:[NSString stringWithFormat:@"%d",self.callFunction]];
            vc.navTitle = self.callFunction == 24?@"客户应收明细":@"供应商应付明细";
            vc.sId = [rs objectAtIndex:4];
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


-(void)setFilterButton{
    UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(filterClick)] autorelease];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)filterClick{
    if (self.callFunction == 79 || self.callFunction == 25 || self.callFunction == 28) {
       //排行榜 客户应收 筛选
        KHFliterViewController *vc = (KHFliterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"KHFliterViewController"];
        vc.fliterDic = self.fliterDic;
        vc.parentVC = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.callFunction == 50 || self.callFunction == 45) {
        YYYFliterViewController *vc = (YYYFliterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"YYYFliterViewController"];
        vc.fliterDic = self.fliterDic;
        vc.parentVC = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        RCAlertView *alertView =  [[[RCAlertView alloc]initwithOrientation:ViewOrientation_horizontal] autorelease];
        [alertView ShowViewInObject:self.view withMsg:[NSString stringWithFormat:@"请输入业务单据编号查询"] PhoneNum:@""];
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
    NSString *link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"%d,'%@',0,20,%d,1",[self.sId integerValue],num,page]];
    NSLog(@"%@",link);
    __block RiBaoDtlViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        [tempSelf.result removeAllObjects];
        NSArray * rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [tempSelf.result addObjectsFromArray:rs];
        tempSelf.tableView.result = self.result;
    } lock:YES];

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
