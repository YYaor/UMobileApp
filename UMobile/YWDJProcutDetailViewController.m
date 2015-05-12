//
//  YWDJProcutDetailViewController.m
//  UMobile
//
//  Created by yunyao on 15/5/7.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "YWDJProcutDetailViewController.h"
#import "YWDJProductDetailCell.h"

@interface YWDJProcutDetailViewController ()

@end

@implementation YWDJProcutDetailViewController
@synthesize array;

- (void)viewDidLoad {
    [super viewDidLoad];

}
-(void) loadData{
    
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
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIden = @"cell";
    YWDJProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell){
        cell = [[YWDJProductDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    NSArray *rs = [array objectAtIndex:indexPath.row];
    UIView *contentView = [cell.contentView viewWithTag:100];
    if (rs.count > 10){
        [self setText:[rs objectAtIndex:0] forView:contentView withTag:1];
        [self setText:[rs objectAtIndex:1] forView:contentView withTag:2];
        [self setText:[rs objectAtIndex:2] forView:contentView withTag:3];
        [self setText:[rs objectAtIndex:3] forView:contentView withTag:4];
        [self setText:[rs objectAtIndex:4] forView:contentView withTag:5];
        [self setText:[rs objectAtIndex:5] forView:contentView withTag:6];
        [self setText:[rs objectAtIndex:6] forView:contentView withTag:7];
        [self setText:[rs objectAtIndex:7] forView:contentView withTag:8];
        [self setText:[rs objectAtIndex:8] forView:contentView withTag:9];
        [self setText:[rs objectAtIndex:9] forView:contentView withTag:10];
        [self setText:[rs objectAtIndex:10] forView:contentView withTag:10];
    }
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 188;
}

- (void)dealloc {

    [super dealloc];
}
@end
