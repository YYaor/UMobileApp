//
//  PaiHangYWYViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/16.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "PaiHangYWYViewController.h"

@interface PaiHangYWYViewController ()

@end

@implementation PaiHangYWYViewController

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

-(void)headerRereshing{
    NSString *link = [self GetLinkWithFunction:44 andParam:[NSString stringWithFormat:@"1,'%@',%@",[self GetCurrentDate],[self GetUserID]]];// [NSString stringWithFormat:@"%@?UID=119&Call=44&Param=1,'',1",MainUrl];
    
    __block PaiHangYWYViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        [tempSelf.tableView headerEndRefreshing];
        [tempSelf.result removeAllObjects];
        [tempSelf.result2 removeAllObjects];
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        for (NSArray *rsd in rs){
            if ([[rsd objectAtIndex:4] isEqualToString:@"今日"]){
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
                vc.strTitle = [NSString stringWithFormat:@"%@成单排行", dateTypeName];
                vc.type = Type_Sales_CD;
                break;
            case 1:
                vc.strTitle = [NSString stringWithFormat:@"%@签单排行", dateTypeName];
                vc.type = Type_Sales_QD;
                break;
            case 2:
                vc.strTitle = [NSString stringWithFormat:@"%@回款排行", dateTypeName];
                vc.type = Type_Sales_HK;
                break;
            default:
                break;
        }
    */
    UILabel *typeLabel =  (UILabel *)[cell viewWithTag:1];
    NSString *typeName = typeLabel.text;
    if([@"成单最多" isEqualToString:typeName]){
        vc.strTitle = [NSString stringWithFormat:@"%@成单排行", dateTypeName];
        vc.type = Type_Sales_CD;
    }else if([@"签单最多" isEqualToString:typeName]){
        vc.strTitle = [NSString stringWithFormat:@"%@签单排行", dateTypeName];
        vc.type = Type_Sales_QD;
    }else if([@"回款最多" isEqualToString:typeName]){
        vc.strTitle = [NSString stringWithFormat:@"%@回款排行", dateTypeName];
        vc.type = Type_Sales_HK;
    }


    [self.parentVC presentViewController:navc animated:YES completion:NULL];
}

#pragma mark -
#pragma mark table view

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return self.titleView1;
    else
        return self.titleView2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return [self.result count];
    else
        return [self.result2 count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *rs = nil;
    if(indexPath.section == 0){
        rs =  [self.result objectAtIndex:indexPath.row];
    }else{
        rs = [self.result2 objectAtIndex:indexPath.row];
    }
    NSString *cellIdentify = [[rs ingoreObjectAtIndex:5] isEqualToString:@"回款最多"]?@"Cell1":@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    [self setText:[rs objectAtIndex:5] forView:cell withTag:1];
    [self setText:[rs objectAtIndex:0] forView:cell withTag:2];
    [self setText:[rs objectAtIndex:2] forView:cell withTag:3];
    [self setText:[rs objectAtIndex:3] forView:cell withTag:4];
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
