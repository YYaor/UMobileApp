 //
//  LRFXViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/15.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "LRFXViewController.h"

@interface LRFXViewController ()

@end

@implementation LRFXViewController

@synthesize sortView;
@synthesize result;
@synthesize callFunction;
@synthesize param;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)setSortViewInTable{
    self.tableView.bFooterRefreshing = YES;
    self.tableView.bCountTotal = YES;
    
    self.tableView.rDelegate = self;
    
    
    if (self.callFunction ==  Function_LRBD) {
        
        self.tableView.titles = @[@"时间",@"金额"];
        self.tableView.titleWidths = @[@"120",@"120"];
        self.tableView.countColumns = @[@"",@"1"];
        self.tableView.keys = @[@"1",@"2"];
        
    }else if (self.callFunction == Function_KCJJ){
        self.tableView.titles = @[@"名称",@"库存",@"百分比"];
        self.tableView.titleWidths = @[@"120",@"120",@"120"];
        self.tableView.countColumns = @[@"",@"1",@""];
        self.tableView.keys = @[@"1",@"2",@"3"];

    }else if (self.callFunction == Function_XSFX){
        self.tableView.titles = @[@"时间",@"金额"];
        self.tableView.titleWidths = @[@"120",@"120"];
        self.tableView.countColumns = @[@"",@"1"];
        self.tableView.keys = @[@"1",@"2"];
    }else if (self.callFunction == Function_YSZZ){
        self.tableView.titles = @[@"客户",@"期初应收",@"本期已收",@"期末应收",@"本期回款"];
        self.tableView.titleWidths = @[@"120",@"120",@"120",@"120",@"120"];
        self.tableView.countColumns = @[@"",@"1",@"1",@"1",@"1"];
        self.tableView.keys = @[@"2",@"3",@"4",@"5",@"6"];
        [self setFilterButton];
    }

    

}

-(void)setFilterButton{
    UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(filterClick:)] autorelease];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.tableView initContent];
}

-(void)filterClick:(id)sender{
    RCAlertView *alertView =  [[[RCAlertView alloc]initwithOrientation:ViewOrientation_horizontal] autorelease];
    [alertView ShowViewInObject:self.view withMsg:[NSString stringWithFormat:@"请输入客户查询"] PhoneNum:@""];

    while(alertView.isVisiable) {
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    }
    if (alertView.isOk){
        self.param = [NSString stringWithFormat:@"%d,20,'%@',1,'%@'",page,alertView.num,[self GetCurrentDate]];
        
        NSString *link = [self GetLinkWithFunction:self.callFunction andParam:self.param];// [NSString stringWithFormat:@"%@?UID=119&Call=%d&Param=%@",MainUrl,self.callFunction,self.param];
        
        __block LRFXViewController *tempSelf = self;
        
        [self StartQuery:link completeBlock:^(id obj) {
            [tempSelf.result removeAllObjects];
            NSArray * rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
            [tempSelf.result addObjectsFromArray:rs];
            tempSelf.tableView.result = tempSelf.result;

        } lock:YES];
    }
}




-(void)tableFooterRefreshing{
    page ++;
    self.param = [NSString stringWithFormat:@"%d,20,'',1,'%@'",page,[self GetCurrentDate]];
    NSString *link = [self GetLinkWithFunction:self.callFunction andParam:self.param];// [NSString stringWithFormat:@"%@?UID=119&Call=%d&Param=%@",MainUrl,self.callFunction,self.param];
    __block LRFXViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        [tempSelf.tableView footerEndRefreshing];
        
        NSArray * rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [tempSelf.result addObjectsFromArray:rs];
        tempSelf.tableView.result = tempSelf.result;
    } lock:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    

    // Do any additional setup after loading the view.
}

-(void)loadData{
    [self.tableView initContent];
    [self setSortViewInTable];
    
    
    self.param = @"1";
    if (self.callFunction == Function_XSFX) {
        self.param = @"'',1";
    }else if(self.callFunction == Function_YSZZ){
        page = 0;
        self.param = [NSString stringWithFormat:@"%d,20,'',1,'%@'",page,[self GetCurrentDate]];
        self.tableView.bFooterRefreshing = YES;
    }
    
    self.rightBarButton = nil;
    
    if (self.callFunction == Function_LRBD | self.callFunction == Function_XSFX) {
        self.rightBarButton =  [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"StockCapitalOccupy-line"] style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonClick:)] autorelease];
        self.rightBarButton.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = self.rightBarButton;
    }else if(self.callFunction == Function_KCJJ){
        self.rightBarButton =  [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"StockCapitalOccupy-chart"] style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonClick:)] autorelease];
        self.rightBarButton.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = self.rightBarButton;
    }else{
        [self.rightBarButton setImage:nil];
    }
    
    self.result =  [NSMutableArray array];
    
    NSString *link = [self GetLinkWithFunction:self.callFunction andParam:self.param];// [NSString stringWithFormat:@"%@?UID=119&Call=%d&Param=%@",MainUrl,self.callFunction,self.param];
    
    __block LRFXViewController *tempSelf = self;
    
    [self StartQuery:link completeBlock:^(id obj) {
        NSArray * rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [tempSelf.result addObjectsFromArray:rs];
        tempSelf.tableView.result = result;
    } lock:YES];
}

-(void)rightBarButtonClick:(id)sender{
    ChartViewController *vc =  (ChartViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChartViewController"];
    vc.callFuntion = self.callFunction;
    vc.info = self.result;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark table view

-(void)tableViewClickAtIndex:(NSUInteger)index withObject:(id)obj{
    if (self.callFunction == Function_YSZZ){
        RiBaoDtlViewController *vc = (RiBaoDtlViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"RiBaoDtlViewController"];
        vc.callFunction = 55;
        vc.navTitle = @"应收总帐明细";
        NSArray *rs =  obj;// [self.result objectAtIndex:indexPath.row];
        vc.sId=[rs objectAtIndex:0];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)dealloc{
    self.param = nil;
    self.result = nil;
    self.sortView = nil;
    [_tableView release];
    [_navItem release];
    [_rightBarButton release];
    [_tableView release];
    [super dealloc];
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

@end
