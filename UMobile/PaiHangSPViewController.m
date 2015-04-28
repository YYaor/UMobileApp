//
//  PaiHangSPViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/16.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "PaiHangSPViewController.h"

@interface PaiHangSPViewController ()

@end

@implementation PaiHangSPViewController

@synthesize titleView1;
@synthesize titleView2;
@synthesize result;

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
    
    [self setTableTitieView];
    self.result =  [NSMutableArray array];
    self.result2 =  [NSMutableArray array];
    [self setHeaderRefresh:self.tableView];
    [self.tableView headerBeginRefreshing];
    // Do any additional setup after loading the view.
}



-(void)loadData{
    
}

-(void)headerRereshing{
    NSString *param=[NSString stringWithFormat:@"1,'%@',%@",[self GetCurrentDate],[self GetUserID]];
    NSString *link = [self GetLinkWithFunction:42 andParam:param];// [NSString stringWithFormat:@"%@?UID=119&Call=42&Param=1,'',1",MainUrl];
    
    __block PaiHangSPViewController *tempSelf = self;
    
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
- (IBAction)buttonClick:(id)sender {
    UITableViewCell *cell = [self GetSuperCell:sender];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    UINavigationController *navc = [self.storyboard instantiateViewControllerWithIdentifier:@"BBZXViewController"];
    
    PaiHangListViewController *vc = (PaiHangListViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PaiHangListViewController"];
    [navc initWithRootViewController:vc];
    
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
            vc.strTitle = [NSString stringWithFormat:@"%@销量排行", dateTypeName];
            vc.type = Type_Product_XL;
            break;
        case 1:
            vc.strTitle = [NSString stringWithFormat:@"%@销额排行", dateTypeName];
            vc.type = Type_Product_XE;
            break;
        case 2:
            vc.strTitle = [NSString stringWithFormat:@"%@毛利排行", dateTypeName];
            vc.type = Type_Product_ML;
            break;
        default:
            break;
    }
    */
    UILabel *typeLabel =  (UILabel *)[cell viewWithTag:1];
    NSString *typeName = typeLabel.text;
    if([@"销量最大" isEqualToString:typeName]){
        vc.strTitle = [NSString stringWithFormat:@"%@销量排行", dateTypeName];
        vc.type = Type_Product_XL;
    }else if([@"销额最大" isEqualToString:typeName]){
        vc.strTitle = [NSString stringWithFormat:@"%@销额排行", dateTypeName];
        vc.type = Type_Product_XE;
    }else if([@"毛利最多" isEqualToString:typeName]){
        vc.strTitle = [NSString stringWithFormat:@"%@毛利排行", dateTypeName];
        vc.type = Type_Product_ML;
    }
    
    [self.parentVC presentViewController:navc animated:YES completion:NULL];
}

#pragma mark -
#pragma mark table view

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UINavigationController *navc = [self.storyboard instantiateViewControllerWithIdentifier:@"BBZXViewController"];
//    
//    PaiHangListViewController *vc = (PaiHangListViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PaiHangListViewController"];
//    [navc initWithRootViewController:vc];
//    NSArray *rs = nil;
//    if (indexPath.section == 0){
//        rs = [self.result objectAtIndex:indexPath.row];
//    }else{
//        rs = [self.result2 objectAtIndex:indexPath.row];
//    }
//    vc.result = [NSMutableArray arrayWithObjects:rs,nil];
//    vc.callFunction = 1;
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:
//                vc.strTitle = @"今日销售排行";
//                break;
//            case 1:
//                vc.strTitle = @"今日销额排行";
//                break;
//            default:
//                break;
//        }
//    }else{
//        switch (indexPath.row) {
//            case 0:
//                vc.strTitle = @"本月销量排行";
//                break;
//            case 1:
//                vc.strTitle = @"本来销额排行";
//                break;
//            case 2:
//                vc.strTitle = @"本月毛利排行";
//                break;
//            default:
//                break;
//        }
//    }
//    [self.parentVC presentViewController:navc animated:YES completion:NULL];
////    [self.parentVC.navigationController pushViewController:vc animated:YES];
//}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
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
    [self setText:[rs objectAtIndex:3] forView:cell withTag:2];
    [self setText:[rs objectAtIndex:4] forView:cell withTag:3];
    [self setText:[rs objectAtIndex:5] forView:cell withTag:4];
    
    if ([[rs objectAtIndex:1] isEqualToString:@"毛利最多"]){
        [self setText:@"毛利" forView:cell withTag:6];
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
    [_tableView release];
    [super dealloc];
}
@end
