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
    array = [[NSMutableArray alloc] init];
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self updateTotoalMoneyLabelString];
    [self setupRefresh:self.dataTableView];
    [self setFooterRefresh:self.dataTableView];
    [self.dataTableView headerBeginRefreshing];

}
-(void) updateTotoalMoneyLabelString{
    double total = 0;
    for (NSArray *arr in array){
        if (arr.count > 16){
            total += [[arr objectAtIndex:16] doubleValue];
        }
    }
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"  总金额:%.2f",total];
}

-(void)headerRereshing{
    __block YWDJListViewController *tempSelf = self;
    NSString *paramString = [self getParamStringWithParamArray:self.paramArray];
    NSString *thelink = [self GetLinkWithFunction:89 andParam:paramString];
    thelink = [thelink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self StartQuery:thelink completeBlock:^(id obj) {
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [array removeAllObjects];
        [array addObjectsFromArray:rs];
        [tempSelf.dataTableView reloadData];
        [tempSelf updateTotoalMoneyLabelString];
        [tempSelf.dataTableView headerEndRefreshing];
    } lock:NO];
}
-(void) footerRereshing{
    __unsafe_unretained typeof(self) blockSelf = self;
    //----page++
    if (self.paramArray.count > 1){
        NSNumber *pageNumber = [self.paramArray objectAtIndex:1];
        NSNumber *newPage = [NSNumber numberWithInt:[pageNumber intValue]+1];
        [self.paramArray replaceObjectAtIndex:1 withObject:newPage];
    }
    NSString *paramString = [self getParamStringWithParamArray:self.paramArray];
    NSString *thelink = [self GetLinkWithFunction:89 andParam:paramString];
    thelink = [thelink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self StartQuery:thelink completeBlock:^(id obj) {
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [array addObjectsFromArray:rs];
        [blockSelf.dataTableView reloadData];
        [blockSelf updateTotoalMoneyLabelString];
        [blockSelf.dataTableView footerEndRefreshing];
        if (rs.count <= 0 && blockSelf.paramArray.count > 1){
            NSNumber *pageNumber = [blockSelf.paramArray objectAtIndex:1];
            NSNumber *newPage = [NSNumber numberWithInt:MAX([pageNumber intValue]-1,1)];
            [blockSelf.paramArray replaceObjectAtIndex:1 withObject:newPage];
        }
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIView *contentView = [cell.contentView viewWithTag:10];
    contentView.layer.cornerRadius = 4;
//    contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    contentView.layer.borderWidth = 0.5;
    NSArray *rs = [array objectAtIndex:indexPath.row];
    [self setText:[rs objectAtIndex:9] forView:contentView withTag:1];
    [self setText:[rs objectAtIndex:4] forView:contentView withTag:2];
    [self setText:[rs objectAtIndex:15] forView:contentView withTag:3];
    [self setText:[rs objectAtIndex:5] forView:contentView withTag:4];
    [self setText:[NSString stringWithFormat:@"金额:%@",[rs objectAtIndex:16]] forView:contentView withTag:5];
    [self setText:[rs objectAtIndex:2] forView:contentView withTag:6];
    [self setText:[rs objectAtIndex:1] forView:contentView withTag:7];
    
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
#pragma mark searchBarDelegate
-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
}
-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
}
-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (self.paramArray.count > 13){
        [self.paramArray replaceObjectAtIndex:13 withObject:[NSString stringWithFormat:@"%@",searchBar.text]];
    }
    [self headerRereshing];
    [searchBar resignFirstResponder];
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
    [_totalMoneyLabel release];
    if (array){
        [array release],array = nil;
    }
    [super dealloc];
}
@end
