//
//  PaiHangKHViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/16.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "PaiHangKHViewController.h"

@interface PaiHangKHViewController ()

@end

@implementation PaiHangKHViewController

@synthesize titleView1;
@synthesize titleView2;
@synthesize result,result2;

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
    self.result =  [NSMutableArray array];
    self.result2 = [NSMutableArray array];
    [self setTableTitieView];
    [self setHeaderRefresh:self.tableView];
    bload = NO;
    // Do any additional setup after loading the view.
}

-(void)loadData{
    if (!bload) {
        bload = YES;
        [self.tableView headerBeginRefreshing];
    }
}

-(void)viewDidAppear:(BOOL)animated{
//    [self.tableView headerBeginRefreshing];
}
- (IBAction)buttonClick:(id)sender {
    UITableViewCell *cell = [self GetSuperCell:sender];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    UINavigationController *navc = [self.storyboard instantiateViewControllerWithIdentifier:@"BBZXViewController"];
    
    PaiHangListViewController *vc = (PaiHangListViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PaiHangListViewController"];
    [navc initWithRootViewController:vc];
    
    //    vc.result = [NSMutableArray arrayWithObjects:rs,nil];

    NSString *dateTypeName=@"今日";
    if (indexPath.section == 0) {
        vc.dateType=DateTypeToday;

    }else{
        vc.dateType=DateTypeThisMonth;
        
        dateTypeName=@"本月";
    }
    /*
        switch (indexPath.row) {
            case 0:
                vc.strTitle = [NSString stringWithFormat:@"%@贡献排行", dateTypeName];
                vc.type = Type_Customer_GX;
                break;
            case 1:
                vc.strTitle = [NSString stringWithFormat:@"%@欠款排行", dateTypeName];
                vc.type = Type_Customer_QK;
                break;
            case 2:
                vc.strTitle = @"新增会员列表";
                vc.type = Type_Customer_XZ;
                break;
            default:
                break;
        }
    */
    UILabel *typeLabel =  (UILabel *)[cell viewWithTag:1];
    NSString *typeName = typeLabel.text;
    if([@"贡献最大" isEqualToString:typeName]){
        vc.strTitle = [NSString stringWithFormat:@"%@贡献排行", dateTypeName];
        vc.type = Type_Customer_GX;
    }else if([@"欠款最多" isEqualToString:typeName]){
        vc.strTitle = [NSString stringWithFormat:@"%@欠款排行", dateTypeName];
        vc.type = Type_Customer_QK;
    }else if([@"新增会员" isEqualToString:typeName]){
        vc.strTitle = @"新增会员列表";
        vc.type = Type_Customer_XZ;
    }
    
    [self.parentVC presentViewController:navc animated:YES completion:NULL];
}

-(void)headerRereshing{
    NSString *link = [self GetLinkWithFunction:43 andParam:[NSString stringWithFormat:@"1,'%@',%@",[self GetCurrentDate],[self GetUserID]]];// [NSString stringWithFormat:@"%@?UID=119&Call=43&Param=1,'',1",MainUrl];
    
    __block PaiHangKHViewController *tempSelf =  self;
    [self StartQuery:link completeBlock:^(id obj) {
        [tempSelf.tableView headerEndRefreshing];
        [tempSelf.result removeAllObjects];
        [tempSelf.result2 removeAllObjects];
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        for (NSArray *rsd in rs){
            if ([[rsd objectAtIndex:0] isEqualToString:@"今日"]){
                [tempSelf.result addObject:rsd];
            }else{
                [tempSelf.result2 addObject:rsd];
            }
        }
        [tempSelf.tableView reloadData];
    } lock:NO];
}

-(void)setTableTitieView{
    self.titleView1 = [[[RCTableTitleView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)] autorelease];
    [self.titleView1 setBackgroundImage:@"inventory_title"];
    [self.titleView1 setIcon:@"jinri" withText:@"今日"];
    
    self.titleView2 = [[[RCTableTitleView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)] autorelease];
    [self.titleView2 setBackgroundImage:@"inventory_title"];
    [self.titleView2 setIcon:@"benyue" withText:@"本月"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark table view

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UINavigationController *navc = [self.storyboard instantiateViewControllerWithIdentifier:@"BBZXViewController"];
//    
//    PaiHangListViewController *vc = (PaiHangListViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PaiHangListViewController"];
//    [navc initWithRootViewController:vc];
//  
////    vc.result = [NSMutableArray arrayWithObjects:rs,nil];
//    NSString *param = nil;
//    
//        switch (indexPath.row) {
//            case 0:
//                vc.strTitle = @"本月贡献排行";
//                vc.callFunction = 2;
//                vc.link = [self GetLinkWithFunction:45 andParam:@"20,1,0,'','',0,'',1"];
//                break;
//            case 1:
//                param = [NSString stringWithFormat:@"20,1,'%@',1",[self GetCurrentDate]];
//                vc.strTitle = @"新增会员列表";
//                vc.callFunction = 3;
//                vc.link = [self GetLinkWithFunction:47 andParam:param];
//                break;
//            case 2:
//                vc.strTitle = @"本月欠款排行";
//                break;
//            default:
//                break;
//        }
//
//    [self.parentVC presentViewController:navc animated:YES completion:NULL];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return section == 0? self.titleView1:self.titleView2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?[self.result count]:[self.result2 count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}





-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSArray *rs = nil;
    if(indexPath.section == 0){
        rs =  [self.result objectAtIndex:indexPath.row];
    }else{
        rs = [self.result2 objectAtIndex:indexPath.row];
    }
    [self setText:[rs objectAtIndex:1] forView:cell withTag:1];
    [self setText:[rs objectAtIndex:2] forView:cell withTag:2];
    [self setText:[rs objectAtIndex:4] forView:cell withTag:3];
    [self setText:[rs objectAtIndex:3] forView:cell withTag:4];
    
    if ([[rs objectAtIndex:1] isEqualToString:@"欠款最多"]){
        [self setText:@"金额" forView:cell withTag:5];
        [self setText:[rs objectAtIndex:3] forView:cell withTag:3];
        
        [cell viewWithTag:4].hidden = YES;
        [cell viewWithTag:6].hidden = YES;
    }
    
    if ([[rs objectAtIndex:1] isEqualToString:@"新增会员"]){
        [cell viewWithTag:4].hidden = YES;
        [cell viewWithTag:6].hidden = YES;
    }
    
    return cell;
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
    self.titleView1 = nil;
    self.titleView2 = nil;
    self.result = nil;
    self.result2 = nil;
    [_tableView release];
    [super dealloc];
}

@end
