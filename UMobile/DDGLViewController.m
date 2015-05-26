//
//  DDGLViewController.m
//  UMobile
//
//  订单管理
//
//  Created by 陈 景云 on 14-10-21.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "DDGLViewController.h"

@interface DDGLViewController ()

@end

@implementation DDGLViewController

@synthesize callFunction;
@synthesize param;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRefresh:self.tableView];
    [self.tableView headerBeginRefreshing];
    self.result=[NSMutableArray array];
    self.titleButton.titleLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    self.titleButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    self.titleButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:17.0];
    self.titleButton.titleLabel.textColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];


    // Do any additional setup after loading the view.
}

-(void)loadData{
    [self.tableView headerBeginRefreshing];
}

-(void)sortMenuClick:(KxMenuItem *)item{
    NSDictionary *dates = @{@"本日":@"Today",@"本周":@"thisWeek",@"本月":@"thisMonth"};
    NSDictionary *info = [[self GetOM] getFlowDate];
//    NSString *nparam =  [self.param stringByReplacingCharactersInRange:NSMakeRange(1, 10) withString:[info strForKey:[dates strForKey:item.title]]];
//    self.param = [nparam stringByReplacingCharactersInRange:NSMakeRange(14, 10) withString:[info strForKey:@"Today"]];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.param componentsSeparatedByString:@","]];
    
    [arr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"'%@'",[info strForKey:[dates strForKey:item.title]]]];
    [arr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"'%@'",[info strForKey:[dates strForKey:@"本日"]]]];
    
    self.param = [arr componentsJoinedByString:@","];
    
//    if ([[self.param substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"'"]) {
//        NSString *nparam =  [self.param stringByReplacingCharactersInRange:NSMakeRange(1, 0) withString:[info strForKey:[dates strForKey:item.title]]];
//        self.param = [nparam stringByReplacingCharactersInRange:NSMakeRange(14, 0) withString:[info strForKey:@"Today"]];
//    }else
//    {
//        NSString *nparam =  [self.param stringByReplacingCharactersInRange:NSMakeRange(1, 10) withString:[info strForKey:[dates strForKey:item.title]]];
//        self.param = [nparam stringByReplacingCharactersInRange:NSMakeRange(14, 10) withString:[info strForKey:@"Today"]];
//    }
    
    [self.tableView headerBeginRefreshing];
}


- (IBAction)sortClick:(id)sender {
    [self.view endEditing:YES];
    NSArray *menus = @[
                       [KxMenuItem menuItem:@"本日" image:[UIImage imageNamed:@"popup_icon_approve_date"] target:self action:@selector(sortMenuClick:)],
                       [KxMenuItem menuItem:@"本周" image:[UIImage imageNamed:@"popup_icon_approve_curweek"] target:self action:@selector(sortMenuClick:)],
                       [KxMenuItem menuItem:@"本月" image:[UIImage imageNamed:@"popup_icon_approve_curmonth"] target:self action:@selector(sortMenuClick:)],
                       ];
    [KxMenu showMenuInView:self.view fromRect:CGRectMake(160, 64, 10, 1) menuItems:menus];
}


- (IBAction)addClick:(id)sender {
    UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"XinZenDingDanViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)headerRereshing{
    page=1;
    __block DDGLViewController *tempSelf = self;
    NSString *nparam = [NSString stringWithFormat:@"%@,'%@',20,%d",self.param, self.searchBar.text,page];
    NSString *nlink = [self GetLinkWithFunction:72 andParam:nparam];
    NSString *newLink = [nlink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self StartQuery:newLink completeBlock:^(id obj) {
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [tempSelf.result removeAllObjects];
//        [tempSelf.result addObjectsFromArray:rs];
        tempSelf.result = [NSMutableArray arrayWithArray:rs];
        [tempSelf.tableView reloadData];
        [tempSelf.tableView headerEndRefreshing];
        [tempSelf.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    } lock:YES];
}
-(void)footerRereshing{
    page++;
    __block DDGLViewController *tempSelf = self;

    NSString *nparam = [NSString stringWithFormat:@"%@,'%@',20,%d",self.param, self.searchBar.text,page];

    NSString *nlink = [self GetLinkWithFunction:72 andParam:nparam];
    
    NSString *newLink = [nlink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self StartQuery:newLink completeBlock:^(id obj) {

        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        if ([rs count] > 0) {
            
            [tempSelf.result addObjectsFromArray:rs];
            [tempSelf.tableView reloadData];
            [tempSelf.tableView footerEndRefreshing];
        }else{
            [tempSelf.tableView footerEndRefreshing];
            [tempSelf.tableView  removeFooter];
        }
    } lock:YES];
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

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.tableView headerBeginRefreshing];
}

#pragma mark -
#pragma mark action




#pragma mark -
#pragma mark table view

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *info = [self.result objectAtIndex:indexPath.row];
    NSDictionary *dic = @{@"进货订单":@"5",@"销售订单":@"6"};
    OrderDetailController *vc = (OrderDetailController *)[self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailController"];
    vc.info = info;
    vc.keyIndex = @[[dic strForKey:[info objectAtIndex:0]],@"2",[info objectAtIndex:1]];//订单查询需要传的值(5或6,2,订单ID)
    
    vc.types = @[[info objectAtIndex:0],@"0",[dic strForKey:[info objectAtIndex:0]]];
    vc.noCheck = [[info objectAtIndex:17] isEqualToString:@"未审核"];
    vc.navigationItem.title =  @"订单详情";
    if (vc.noCheck) {
        vc.strID =  [info objectAtIndex:1];
    }
    vc.isHidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.result count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray *rs =  [self.result objectAtIndex:indexPath.row];
    [self setText:[rs objectAtIndex:4] forView:cell withTag:1];
    [self setText:[rs objectAtIndex:5] forView:cell withTag:2];
    [self setText:[rs objectAtIndex:2] forView:cell withTag:3];
    [self setText:[rs objectAtIndex:3] forView:cell withTag:4];
    [self setText:[rs objectAtIndex:20] forView:cell withTag:5];
    [self setText:[rs objectAtIndex:0] forView:cell withTag:6];
    
    [self setText:[rs objectAtIndex:17] forView:cell withTag:7];  //审核状态
//    [self setText:[rs objectAtIndex:17] forView:cell withTag:8]; //保质日期
//    [self setText:[rs objectAtIndex:17] forView:cell withTag:9]; //截止日期
    
    UITextField *textField = (UITextField *)[cell viewWithTag:7];
    textField.textColor = [[rs objectAtIndex:17] isEqualToString:@"未审核"]?[UIColor redColor]:[UIColor blackColor];
    
    return cell;
}



- (void)dealloc {
    self.result = nil;
    self.link = nil;
    self.param = nil;
    [_tableView release];
    [_searchBar release];
    [_titleButton release];
    [super dealloc];
}
@end
