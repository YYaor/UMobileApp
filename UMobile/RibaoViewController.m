//
//  RibaoViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/4.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RibaoViewController.h"

@interface RibaoViewController ()

@end

@implementation RibaoViewController

@synthesize leftTableArr,param,result;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
//        CATransform3D transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1.0);
//        self.view.layer.transform = transform;
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
//        [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)UIInterfaceOrientationLandscapeLeft];
    }
    return self;
}
-(void)setSortViewInTable{
    self.tableView.bFooterRefreshing = YES;
    
    
    self.tableView.rDelegate = self;
    
    
    if (self.callFunction ==  Function_LRBD) {
        
        self.tableView.titles = @[@"时间",@"金额"];
        self.tableView.titleWidths = @[@"120",@"120"];
        self.tableView.countColumns = @[@"",@"1"];
        self.tableView.keys = @[@"1",@"2"];
        
    }else if (self.callFunction == Function_KCJJ){
        self.tableView.titles = @[@"名称",@"库存(元)",@"百分比"];
        self.tableView.titleWidths = @[@"120",@"120",@"120"];
        self.tableView.countColumns = @[@"",@"1",@"1"];
        self.tableView.keys = @[@"1",@"2",@"3"];
        
    }else if (self.callFunction == Function_XSFX){
        self.tableView.titles = @[@"时间",@"金额"];
        self.tableView.titleWidths = @[@"120",@"120"];
        self.tableView.countColumns = @[@"",@"1"];
        self.tableView.keys = @[@"1",@"2"];
    }else if (self.callFunction == Function_YSZZ){
        self.tableView.titles = @[@"客户",@"期初应收(元)",@"本期应收(元)",@"期末应收(元)",@"本期回款(元)"];
        self.tableView.titleWidths = @[@"120",@"120",@"120",@"120",@"120"];
        self.tableView.countColumns = @[@"",@"1",@"1",@"1",@"1"];
        self.tableView.keys = @[@"2",@"3",@"4",@"5",@"6"];
        self.tableView.bCountTotal = YES;
        [self setFilterButton];
    }
    

    
}

-(void)setFilterButton{
    if (self.callFunction == Function_YSZZ) {
        UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter2"] style:UIBarButtonItemStylePlain target:self action:@selector(filterClick:)] autorelease];
        self.navigationItem.rightBarButtonItem = rightButton;
    }else if (self.callFunction == Function_KCJJ){
        NSString *picName = @"StockCapitalOccupy-list";
        if (bExcahnge) {
            picName = @"StockCapitalOccupy-chart";
        }
        
        UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:picName] style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonClick:)] autorelease];
        self.navigationItem.rightBarButtonItem = rightButton;
    }else{
        NSString *picName = @"StockCapitalOccupy-list";
        if (bExcahnge) {
            picName = @"StockCapitalOccupy-line";
        }
        UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:picName] style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonClick:)] autorelease];
        self.navigationItem.rightBarButtonItem = rightButton;
    }

}

-(void)rightBarButtonClick:(id)sender{

    [UIView beginAnimations:nil context:nil];
    
    //持续时间
    
    [UIView setAnimationDuration:1.0];
    
    //在出动画的时候减缓速度
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    //添加动画开始及结束的代理

    
    //动画效果
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];

    [self.view exchangeSubviewAtIndex:[self.view.subviews indexOfObject:self.tableView] withSubviewAtIndex:[self.view.subviews indexOfObject:[self.view viewWithTag:999]]];
    
    [UIView commitAnimations];
    
    bExcahnge = !bExcahnge;
    [self setFilterButton];
    
//    ChartViewController *vc =  (ChartViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChartViewController"];
//    vc.callFuntion = self.callFunction;
//    vc.info = self.result;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)loadChartView{
    [[self.view viewWithTag:999] removeFromSuperview];
    if (self.callFunction != Function_YSZZ) {
        ChartViewController *vc =  (ChartViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChartViewController"];
        vc.callFuntion = self.callFunction;
        vc.info = self.result;
        vc.view.frame = self.tableView.frame;
        vc.view.tag = 999;
        [self.view addSubview:vc.view];
    }

}

-(void)filterClick:(id)sender{
    RCAlertView *alertView =  [[[RCAlertView alloc]initwithOrientation:ViewOrientation_horizontal] autorelease];
    [alertView ShowViewInObject:self.view withMsg:[NSString stringWithFormat:@"请输入客户查询"] PhoneNum:self.searchText];
    
    while(alertView.isVisiable) {
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    }
    if (alertView.isOk){
        self.searchText =  alertView.num;
        [self loadData];
//        self.param = [NSString stringWithFormat:@"%d,20,'%@',1,'%@'",page,alertView.num,[self GetCurrentDate]];
//        
//        NSString *link = [self GetLinkWithFunction:self.callFunction andParam:self.param];// [NSString stringWithFormat:@"%@?UID=119&Call=%d&Param=%@",MainUrl,self.callFunction,self.param];
//        
//        __block RibaoViewController *tempSelf = self;
//        
//        [self StartQuery:link completeBlock:^(id obj) {
//            [tempSelf.result removeAllObjects];
//            NSArray * rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
//            [tempSelf.result addObjectsFromArray:rs];
//            tempSelf.tableView.result = tempSelf.result;
//            
//        } lock:YES];
    }
}

#pragma mark -
#pragma mark table view

-(void)tableViewClickAtIndex:(NSUInteger)index withObject:(id)obj{
    if (self.callFunction == Function_YSZZ){
        RiBaoDtlTagViewController *vc = (RiBaoDtlTagViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"RiBaoDtlTagViewController"];
        vc.callFunction = 79;
        vc.navTitle = @"应收总帐明细";
        NSArray *rs =  obj;// [self.result objectAtIndex:indexPath.row];
        vc.sId=[rs objectAtIndex:0];
        [self.navigationController pushViewController:vc animated:YES];
    }
}




-(void)tableFooterRefreshing{
    page ++;
    self.param = [NSString stringWithFormat:@"'%@',50,%d,%@,'%@'",
                  [self.searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                  page,[self GetUserID],[self GetCurrentDate]];
    NSString *link = [self GetLinkWithFunction:self.callFunction andParam:self.param];// [NSString stringWithFormat:@"%@?UID=119&Call=%d&Param=%@",MainUrl,self.callFunction,self.param];
    __block RibaoViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        [tempSelf.tableView footerEndRefreshing];

        NSArray * rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        if ([rs count] > 0) {
            tempSelf.result = nil;
            [tempSelf.result addObjectsFromArray:rs];
            tempSelf.tableView.result = tempSelf.result;
        }else{
            if (page > 1) {
                page --;
            }
        }
 
    } lock:NO];
}

-(void)loadData{
    [self setSortViewInTable];
    self.tableView.bInit = NO;
    self.tableView.result = nil;
    
    [self.tableView initContent];
    self.tableView.rDelegate = self;
    
    self.param = [self GetUserID];
    if (self.callFunction == Function_XSFX) {
        self.param = [NSString stringWithFormat:@"'',%@",[self GetUserID]];
    }else if(self.callFunction == Function_YSZZ){
        page = 1;
        self.param = [NSString stringWithFormat:@"'%@',50,%d,%@,'%@'",[self.searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],page,[self GetUserID],[self GetCurrentDate]];
        self.tableView.bFooterRefreshing = YES;
    }
    
//    self.rightBarButton = nil;
//    
//    if (self.callFunction == Function_LRBD | self.callFunction == Function_XSFX) {
//        self.rightBarButton =  [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"StockCapitalOccupy-line"] style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonClick:)] autorelease];
//        self.rightBarButton.tintColor = [UIColor whiteColor];
//        self.navigationItem.rightBarButtonItem = self.rightBarButton;
//    }else if(self.callFunction == Function_KCJJ){
//        self.rightBarButton =  [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"StockCapitalOccupy-chart"] style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonClick:)] autorelease];
//        self.rightBarButton.tintColor = [UIColor whiteColor];
//        self.navigationItem.rightBarButtonItem = self.rightBarButton;
//    }else{
//        [self.rightBarButton setImage:nil];
//    }
    
    self.result =  [NSMutableArray array];
    
    NSString *link = [self GetLinkWithFunction:self.callFunction andParam:self.param];// [NSString stringWithFormat:@"%@?UID=119&Call=%d&Param=%@",MainUrl,self.callFunction,self.param];
    
    __block RibaoViewController *tempSelf = self;
    
    [self StartQuery:link completeBlock:^(id obj) {
        NSArray * rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [tempSelf.result addObjectsFromArray:rs];
        tempSelf.tableView.result = tempSelf.result;
        [tempSelf loadChartView];
    } lock:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rDelegate = self;
    
    self.leftTableArr = @[@{@"Name": @"利润变动分析",@"Image":@"指标看板a_06",@"Action":@"rabioClick:",@"Function":@"51"},
                     @{@"Name": @"库存资金占用",@"Image":@"指标看板a_09",@"Action":@"yjClick:",@"Function":@"52"},
                     @{@"Name": @"销售趋势分析",@"Image":@"指标看板a_12",@"Action":@"shClick:",@"Function":@"53"},
                     @{@"Name": @"应收总帐分析",@"Image":@"指标看板a_14",@"Action":@"phbClick:",@"Function":@"54"}
                     ];
    
    self.searchText = @"";
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!bload){
        bload = YES;
        [self tableView:self.leftTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    bdata = NO;
    NSDictionary *dic =  [self.leftTableArr objectAtIndex:indexPath.row];
    self.callFunction = (Function_Type)[[dic strForKey:@"Function"] integerValue];
    self.navigationItem.title =  [dic strForKey:@"Name"];
    bExcahnge = NO;
    [self setFilterButton];
    [self loadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.leftTableArr count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.leftTable dequeueReusableCellWithIdentifier:@"Cell"];
    
    // fixBug       ghd         20150122
    if (indexPath.row == 0) {
        [self.leftTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    UIImageView *imageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 44)] autorelease];
    imageView.image =  [UIImage imageNamed:@"Cell_bg"];
    [cell setSelectedBackgroundView:imageView];
    
    [self setBackgroundView:@"navigationbar_background" forCell:cell];
    
    NSDictionary *dic =  [self.leftTableArr objectAtIndex:indexPath.row];
    [self setImage:[UIImage imageNamed:[dic strForKey:@"Image"]] forView:cell withTag:1];
    [self setText:[dic strForKey:@"Name"] forView:cell withTag:2];
    return cell;;
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
    self.searchText = nil;
    self.viewControllers = nil;
    self.leftTableArr = nil;
    [_leftTable release];
    [_subVcView release];
    [_tableView release];
    [super dealloc];
}
@end
