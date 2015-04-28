//
//  PaiHangListViewController.m
//  UMobile
//
//  Created by 陈 景云 on 14-11-9.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "PaiHangListViewController.h"

@interface PaiHangListViewController ()

@end

@implementation PaiHangListViewController

@synthesize sortView;
@synthesize callFunction;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.strTitle;
    
    self.tableView.bCountTotal = YES;
    if(self.type == Type_Product_XE || self.type == Type_Product_XL){
        self.tableView.titles = @[@"排行",@"商品编码",@"商品名称",@"数量",@"金额"];
        self.tableView.titleWidths = @[@"80",@"100",@"120",@"80",@"100"];
        self.tableView.countColumns = @[@"0",@"0",@"0",@"1",@"1"];
        self.tableView.keys = @[@"1",@"2",@"3",@"4",@"5"];
        self.tableView.rDelegate=self;
        self.tableView.leftIsOrder = YES;

        //self.link = [self GetLinkWithFunction:42 andParam:[NSString stringWithFormat:@"5,'%@',1",[self GetCurrentDate]]];
        self.link = [self GetLinkWithFunction:42 andParam:[NSString stringWithFormat:@"5,'%@',%@",[self GetCurrentDate],[[self setting] objectForKey:@"UID"]]];
    }else if (self.type == Type_Product_ML){
        self.tableView.titles = @[@"排行",@"商品编码",@"商品名称",@"数量",@"毛利"];
        self.tableView.titleWidths = @[@"80",@"100",@"120",@"80",@"100"];
        self.tableView.countColumns = @[@"0",@"0",@"0",@"1",@"1"];
        self.tableView.keys = @[@"1",@"2",@"3",@"4",@"5"];
        self.tableView.rDelegate=self;
        self.tableView.leftIsOrder = YES;
        
        //self.link = [self GetLinkWithFunction:42 andParam:[NSString stringWithFormat:@"5,'%@',1",[self GetCurrentDate]]];
        self.link = [self GetLinkWithFunction:42 andParam:[NSString stringWithFormat:@"5,'%@',%@",[self GetCurrentDate],[[self setting] objectForKey:@"UID"]]];
    }else if (self.type == Type_Customer_GX ){//贡献排行
        self.tableView.titles = @[@"排行",@"客户名称",@"数量",@"金额"];
        self.tableView.titleWidths = @[@"80",@"120",@"100",@"100"];
        self.tableView.countColumns = @[@"0",@"0",@"1",@"1"];
        self.tableView.keys = @[@"1",@"2",@"4",@"3"];
        self.tableView.rDelegate = self;
        self.tableView.leftIsOrder = YES;

        //self.link = [self GetLinkWithFunction:43 andParam:[NSString stringWithFormat:@"5,'%@',1",[self GetCurrentDate]]];
        self.link = [self GetLinkWithFunction:43 andParam:[NSString stringWithFormat:@"5,'%@',%@",[self GetCurrentDate],[[self setting] objectForKey:@"UID"]]];
    }else if (self.type == Type_Customer_QK){//欠款排行
        self.tableView.titles = @[@"排行",@"客户名称",@"金额"];
        self.tableView.titleWidths = @[@"80",@"120",@"100"];
        self.tableView.countColumns = @[@"0",@"0",@"1"];
        self.tableView.keys = @[@"1",@"2",@"3"];
        self.tableView.rDelegate = self;
        self.tableView.leftIsOrder = YES;
        
        //self.link = [self GetLinkWithFunction:43 andParam:[NSString stringWithFormat:@"5,'%@',1",[self GetCurrentDate]]];
        self.link = [self GetLinkWithFunction:43 andParam:[NSString stringWithFormat:@"5,'%@',%@",[self GetCurrentDate],[[self setting] objectForKey:@"UID"]]];
    }else if (self.type == Type_Sales_CD || self.type == Type_Sales_QD){
        self.tableView.titles = @[@"排行",@"职员名称",@"数量",@"金额"];
        self.tableView.titleWidths = @[@"100",@"100",@"100",@"100"];
        self.tableView.countColumns = @[@"0",@"0",@"1",@"1"];
        self.tableView.keys = @[@"0",@"0",@"2",@"3"];
        self.tableView.rDelegate=self;
        self.tableView.leftIsOrder = YES;

        //self.link = [self GetLinkWithFunction:44 andParam:[NSString stringWithFormat:@"5,'%@',1",[self GetCurrentDate]]];
        self.link = [self GetLinkWithFunction:44 andParam:[NSString stringWithFormat:@"5,'%@',%@",[self GetCurrentDate],[[self setting] objectForKey:@"UID"]]];
    }else if(self.type == Type_Sales_HK){ //本月回款排行
        self.tableView.titles = @[@"排行",@"职员名称",@"金额"];
        self.tableView.titleWidths = @[@"100",@"100",@"100"];
        self.tableView.countColumns = @[@"0",@"0",@"1"];
        self.tableView.keys = @[@"0",@"0",@"3"];
        self.tableView.rDelegate=self;
        self.tableView.leftIsOrder = YES;
        
        //self.link = [self GetLinkWithFunction:44 andParam:[NSString stringWithFormat:@"5,'%@',1",[self GetCurrentDate]]];
        self.link = [self GetLinkWithFunction:44 andParam:[NSString stringWithFormat:@"5,'%@',%@",[self GetCurrentDate],[[self setting] objectForKey:@"UID"]]];
    }else if(self.type == Type_Customer_XZ){ //新增会员
        self.tableView.titles = @[@"会员卡号",@"会员名称",@"会员类型",@"生效日期",@"失效日期"];
        self.tableView.titleWidths = @[@"100",@"100",@"100",@"100",@"100"];
//        self.tableView.countColumns = @[@"",@"",@"",@"",@""];
        self.tableView.keys = @[@"0",@"1",@"2",@"3",@"4"];
        self.tableView.rDelegate = self;
        self.tableView.bCountTotal = NO;
        
        //self.link = [self GetLinkWithFunction:43 andParam:[NSString stringWithFormat:@"5,'%@',%@",[self GetCurrentDate],[[self setting] objectForKey:@"UID"]]];
        self.link = [self GetLinkWithFunction:47 andParam:[NSString stringWithFormat:@"20,1,'%@',%@,%d",[self GetCurrentDate],[self GetUserID],self.dateType]];
    }
    
    __block PaiHangListViewController *tempSelf = self;
    [self StartQuery:self.link completeBlock:^(id obj) {
        NSMutableArray *todayInfos=[NSMutableArray array];
        NSMutableArray *infos = [NSMutableArray array];
        NSArray *rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        for (NSArray * rsd in rs){
            if([[rsd objectAtIndex:0] isEqualToString:@"今日"] || [[rsd objectAtIndex:4] isEqualToString:@"今日"]){
                switch (tempSelf.type) {
                    case Type_Product_XL:
                        if ([[rsd objectAtIndex:1] isEqualToString:@"销量最大"]) [todayInfos addObject:rsd];
                        break;
                    case Type_Product_XE:
                        if ([[rsd objectAtIndex:1] isEqualToString:@"销额最大"]) [todayInfos addObject:rsd];
                        break;
                    case Type_Product_ML:
                        if ([[rsd objectAtIndex:1] isEqualToString:@"毛利最多"]) [todayInfos addObject:rsd];
                        break;
                    case Type_Customer_GX:
                        if ([[rsd objectAtIndex:1] isEqualToString:@"贡献最大"]) [todayInfos addObject:rsd];
                        break;
                    case Type_Customer_QK:
                        if ([[rsd objectAtIndex:1] isEqualToString:@"欠款最多"]) [todayInfos addObject:rsd];
                        break;
                    case Type_Customer_XZ:
//                        if ([[rsd objectAtIndex:1] isEqualToString:@"新增会员"])
                            [todayInfos addObject:rsd];
                        break;
                    case Type_Sales_CD:
                        if ([[rsd objectAtIndex:5] isEqualToString:@"成单最多"]) [todayInfos addObject:rsd];
                        break;
                    case Type_Sales_QD:
                        if ([[rsd objectAtIndex:5] isEqualToString:@"签单最多"]) [todayInfos addObject:rsd];
                        break;
                    case Type_Sales_HK:
                        if ([[rsd objectAtIndex:5] isEqualToString:@"回款最多"]) [todayInfos addObject:rsd];
                        break;
                    default:
                        break;
                }
            }else{
                switch (tempSelf.type) {
                    case Type_Product_XL:
                        if ([[rsd objectAtIndex:1] isEqualToString:@"销量最大"]) [infos addObject:rsd];
                        break;
                    case Type_Product_XE:
                        if ([[rsd objectAtIndex:1] isEqualToString:@"销额最大"]) [infos addObject:rsd];
                        break;
                    case Type_Product_ML:
                        if ([[rsd objectAtIndex:1] isEqualToString:@"毛利最多"]) [infos addObject:rsd];
                        break;
                    case Type_Customer_GX:
                        if ([[rsd objectAtIndex:1] isEqualToString:@"贡献最大"]) [infos addObject:rsd];
                        break;
                    case Type_Customer_QK:
                        if ([[rsd objectAtIndex:1] isEqualToString:@"欠款最多"]) [infos addObject:rsd];
                        break;
                    case Type_Customer_XZ:
//                        if ([[rsd objectAtIndex:1] isEqualToString:@"新增会员"])
                            [infos addObject:rsd];
                        break;
                    case Type_Sales_CD:
                        if ([[rsd objectAtIndex:5] isEqualToString:@"成单最多"]) [infos addObject:rsd];
                        break;
                    case Type_Sales_QD:
                        if ([[rsd objectAtIndex:5] isEqualToString:@"签单最多"]) [infos addObject:rsd];
                        break;
                    case Type_Sales_HK:
                        if ([[rsd objectAtIndex:5] isEqualToString:@"回款最多"]) [infos addObject:rsd];
                        break;
                    default:
                        break;
                }
            }
        }
        if (self.dateType == DateTypeToday && self.type != Type_Customer_XZ)
            tempSelf.tableView.result = todayInfos;
        else
            tempSelf.tableView.result = infos;
    } lock:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView initContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSortViewInTable{
    CGFloat width = self.tableView.frame.size.width;
    self.sortView = [[[RCTableHeadSortView alloc]initWithFrame:CGRectMake(0, 0, width, 44)]autorelease];
    if (self.callFunction ==  1) {
        [self.sortView setTitles:[NSArray arrayWithObjects:@"排行",@"商品编码",@"商品名称",@"数量",@"金额", nil]];
        [self.sortView setWidths:[NSArray arrayWithObjects:@"1",@"2",@"3",@"2",@"3", nil]];
        [self.sortView setSortKeys:@[@"1",@"2",@"3",@"4",@"5"]];
    }
    
    [self.sortView setBackgroundImage:@"inventory_title"];
    //    [self.sortView setWidths:[NSArray arrayWithObjects:@"1",@"1",@"1",@"1",@"0.5",@"0.5",@"5.5", nil]];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate{
    return YES;
}

#pragma mark -
#pragma mark table view

-(void)tableViewClickAtIndex:(NSUInteger)index withObject:(id)obj{
    if(self.type == Type_Product_ML || self.type == Type_Product_XE || self.type == Type_Product_XL){
        
//        NSString *nlink=[self GetLinkWithFunction:60 andParam:[NSString stringWithFormat:@"'%@',0,0,0,0,0,0,1,%@",[[self.tableView.result[index] objectAtIndex:2] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
//                                                               ,[self GetUserID]]];
        NSString *nlink=[self GetLinkWithFunction:12 andParam:[NSString stringWithFormat:@"20,1,0,'%@',%@",[[self.tableView.result[index] objectAtIndex:2] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                               ,[self GetUserID]]];
        
        [self StartQuery:nlink completeBlock:^(id obj) {
            NSArray * rs = [[[obj objectFromJSONString] objectForKey:@"D_Data"] firstObject];
//            [self pushWithCallFunction:45 navTitle:@"经营历程" sId:[rs objectAtIndex:0]];
//            [self pushWithCallFunction:31 navTitle:@"商品销售明细" sId:[self.tableView.result[index] objectAtIndex:2]];
            [self pushWithCallFunction:31 navTitle:@"商品销售明细" sId:[rs firstObject] ];
            //                          15.1.20
            //            [self pushWithCallFunction:45 navTitle:@"贡献统计" sId:[rs objectAtIndex:0]];
            
            
        } lock:YES];
//        [self pushWithCallFunction:31 navTitle:@"商品销售明细" sId:[self.tableView.result[index] objectAtIndex:2]];

    }else if (self.type == Type_Customer_GX){
        
        NSString *nlink=[self GetLinkWithFunction:10 andParam:[NSString stringWithFormat:@"20,0,0,'%@',%@",[[self.tableView.result[index] objectAtIndex:2] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                               ,[self GetUserID]]];
        [self StartQuery:nlink completeBlock:^(id obj) {
            NSArray * rs = [[[obj objectFromJSONString] objectForKey:@"D_Data"] firstObject];
            [self pushWithCallFunction:45 navTitle:@"经营历程" sId:[rs objectAtIndex:0]];
            
            //                          15.1.20
//            [self pushWithCallFunction:45 navTitle:@"贡献统计" sId:[rs objectAtIndex:0]];

            
        } lock:YES];
    }else if (self.type == Type_Customer_QK){

        NSString *nlink=[self GetLinkWithFunction:10 andParam:[NSString stringWithFormat:@"20,0,0,'%@',1",[[self.tableView.result[index] objectAtIndex:2] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [self StartQuery:nlink completeBlock:^(id obj) {
            NSArray * rs = [[[obj objectFromJSONString] objectForKey:@"D_Data"] objectAtIndex:0];
//            [self pushWithCallFunction:46 navTitle:@"应收账款统计" sId:[rs objectAtIndex:0]];
            // 标题不一致                    15.1.20
            [self pushWithCallFunction:46 navTitle:@"往来单位应收应付统计" sId:[rs objectAtIndex:0]];

        } lock:YES];
    }else if (self.type == Type_Customer_XZ){
        
        //[self pushWithCallFunction:47 navTitle:@"新增会员" sId:@""];
        
    }else if (self.type == Type_Sales_CD) {
        
        [self pushWithCallFunction:48 navTitle:@"销售单统计" sId:[self.tableView.result[index] objectAtIndex:1]];

    }else if (self.type == Type_Sales_QD){
        
        [self pushWithCallFunction:49 navTitle:@"销售订单统计" sId:[self.tableView.result[index] objectAtIndex:1]];

    }else if (self.type == Type_Sales_HK){
        
        [self pushWithCallFunction:50 navTitle:@"业务员回款统计" sId:[self.tableView.result[index] objectAtIndex:1]];
    }
}
-(void)leftTableClickAtIndex:(NSUInteger)index withObject:(id)obj{
    
}
-(void)pushWithCallFunction:(NSUInteger)callFunction navTitle:(NSString *)title sId:(NSString *)sId{
    RiBaoDtlViewController *vc = (RiBaoDtlViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"RiBaoDtlViewController"];
    vc.dateType = self.dateType;
    vc.callFunction = callFunction;
    vc.sId = sId;
    vc.navTitle = title;
    vc.fixColumn = 1;
    [self.navigationController pushViewController:vc animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)backClick:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)dealloc {
    self.sortView = nil;
    [_tableView release];
    [super dealloc];
}
@end
