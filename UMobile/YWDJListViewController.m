//
//  YWDJListViewController.m
//  UMobile
//
//  Created by yunyao on 15/5/7.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "YWDJListViewController.h"
#import "YWDJDetailViewController.h"

@interface YWDJListViewController ()
{
    NSMutableArray *array;
}

@end

@implementation YWDJListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh:self.dataTableView];
    [self.dataTableView headerBeginRefreshing];
}

-(void)headerRereshing{
    __block YWDJListViewController *tempSelf = self;
    [self setFooterRefresh:self.dataTableView];
    [self StartQuery:self.link completeBlock:^(id obj) {
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [array addObjectsFromArray:rs];
        [tempSelf.dataTableView reloadData];
        [tempSelf.dataTableView headerEndRefreshing];
    } lock:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identify = @"YWDJCell";
    UITableViewCell *cell = [self.dataTableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    NSArray *rs = [array objectAtIndex:indexPath.row];
    [self setText:[rs objectAtIndex:1] forView:cell withTag:1];
    [self setText:[rs objectAtIndex:1] forView:cell withTag:2];
    [self setText:[rs objectAtIndex:1] forView:cell withTag:3];
    [self setText:[rs objectAtIndex:1] forView:cell withTag:4];
    [self setText:[rs objectAtIndex:1] forView:cell withTag:5];
    [self setText:[rs objectAtIndex:1] forView:cell withTag:6];
    [self setText:[rs objectAtIndex:1] forView:cell withTag:7];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SecondaryStoryboard" bundle:nil];
    YWDJDetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"YWDJDetailViewController"];
    NSMutableArray *rs = [array objectAtIndex:indexPath.row];
    vc.array =rs;
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)dealloc {
    [_dataTableView release];
    [_dataSearchBar release];
    [super dealloc];
}
@end
