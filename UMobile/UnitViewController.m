//
//  UnitViewController.m
//  UMobile
//
//  Created by Rid on 14/12/11.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "UnitViewController.h"
#import "XinZenShangPingViewController.h"

@interface UnitViewController ()

@end

@implementation UnitViewController

@synthesize keys,result,productInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHeaderRefresh:self.tableView];
    
    [self.tableView headerBeginRefreshing];
    // Do any additional setup after loading the view.
}

-(void)headerRereshing{
    NSString *param = [NSString stringWithFormat:@"%@,0,0,1,0,%@",[self.productInfo strForKey:@"商品ID"],[self GetUserID]];
    NSString *link =  [self GetLinkWithFunction:65 andParam:param];
    __block UnitViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        [tempSelf.tableView headerEndRefreshing];
        tempSelf.result = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [tempSelf.tableView reloadData];
    } lock:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray *rs = [self.result objectAtIndex:indexPath.row];
    [self setText:[rs objectAtIndex:2] forView:cell withTag:1];
    [self setText:[rs objectAtIndex:3] forView:cell withTag:2];
    [self setText:[rs objectAtIndex:4] forView:cell withTag:3];
    [self setText:[rs objectAtIndex:5] forView:cell withTag:4];
    [self setText:[rs objectAtIndex:6] forView:cell withTag:5];
    [self setText:[rs objectAtIndex:7] forView:cell withTag:6];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.result count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *rs = [self.result objectAtIndex:indexPath.row];
    
    //    [self.productInfo replaceObjectAtIndex:8 withObject:[rs objectAtIndex:1]];
    //    [self.productInfo replaceObjectAtIndex:9 withObject:[rs objectAtIndex:4]];
    //    [self.productInfo replaceObjectAtIndex:11 withObject:[rs objectAtIndex:8]];
    [self.productInfo setObject:[rs objectAtIndex:1] forKey:@"单位ID"];
    [self.productInfo setObject:[rs objectAtIndex:4] forKey:@"单位名称"];
    [self.productInfo setObject:[rs objectAtIndex:8] forKey:@"条码"];
    [self.productInfo setObject:[rs objectAtIndex:5] forKey:@"单位换算率"];
    [self.parentVC performSelector:@selector(updateMsg) withObject:nil];
    [self dismiss];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

// fixBug   0123
- (void)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    self.keys = nil;
    self.result = nil;
    [_tableView release];
    [super dealloc];
}
@end
