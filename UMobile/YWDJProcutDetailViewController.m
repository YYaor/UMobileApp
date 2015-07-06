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
@synthesize dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataTableView.backgroundColor = [UIColor colorWithWhite:0xf3/255.0 alpha:1];
    [self setupRefresh:self.dataTableView];
    [self setFooterRefresh:self.dataTableView];
    [self.dataTableView headerBeginRefreshing];

}
-(void)headerRereshing{
    [dataArray removeAllObjects];
    NSInteger danjuzhuangtai;
    NSInteger danjuleixing;
    if ([[self.array objectAtIndex:0] isEqualToString:@"草稿"]) {
        danjuzhuangtai = 0;
    }else if([[self.array objectAtIndex:0] isEqualToString:@"过账单据"]){
        danjuzhuangtai = 1;
    }else{
        danjuzhuangtai = 2;
    }
    if ([[self.array objectAtIndex:2] isEqualToString:@"销售单"]) {
        danjuleixing = 1;
    }else{
        danjuleixing = 0;
    }
    NSString *param = [NSString stringWithFormat:@"%d,%d,%d,%d",
                       danjuleixing,
                       danjuzhuangtai,
                       [[self.array objectAtIndex:3] integerValue],
                       [[self GetUserID] integerValue]
                       ];
     NSString *link = [self GetLinkWithFunction:58 andParam:param];
    __block YWDJProcutDetailViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [dataArray addObjectsFromArray:rs];
        [tempSelf.dataTableView reloadData];
        [tempSelf.dataTableView headerEndRefreshing];
    } lock:NO];
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
    return dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIden = @"shangpinCell";
    YWDJProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell){
        cell = [[YWDJProductDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    cell.backgroundColor = [UIColor colorWithWhite:0xf3/255.0 alpha:1];
    NSArray *rs = [dataArray objectAtIndex:indexPath.row];
    UIView *contentView = [cell.contentView viewWithTag:100];
    if (rs.count > 10){
        [self setText:[rs objectAtIndex:3] forView:cell withTag:1];
        [self setText:[NSString stringWithFormat:@"编码:%@",[rs objectAtIndex:2]] forView:contentView withTag:2];
        [self setText:[NSString stringWithFormat:@"规格:%@",[rs objectAtIndex:7]] forView:contentView withTag:3];
        [self setText:[NSString stringWithFormat:@"型号:%@",[rs objectAtIndex:8]] forView:contentView withTag:4];
        [self setText:[NSString stringWithFormat:@"单位:%@",[rs objectAtIndex:5]] forView:contentView withTag:5];
        [self setText:[NSString stringWithFormat:@"数量:%@",[rs objectAtIndex:9]] forView:contentView withTag:6];
        [self setText:[NSString stringWithFormat:@"单价:%@",[rs objectAtIndex:10]] forView:contentView withTag:7];
        [self setText:[NSString stringWithFormat:@"折后单价:%@",[rs objectAtIndex:12]] forView:contentView withTag:8];
        [self setText:[NSString stringWithFormat:@"赠品:%@",[rs objectAtIndex:14]] forView:contentView withTag:9];
        [self setText:[NSString stringWithFormat:@"折后金额:%@",[rs objectAtIndex:13]] forView:contentView withTag:10];
        [self setText:[NSString stringWithFormat:@"批号信息:批号/出厂日期/保质期截止日期/保质期\n%@/%@/%@/%@",[rs objectAtIndex:30],[rs objectAtIndex:31],[rs objectAtIndex:28],[rs objectAtIndex:29]] forView:contentView withTag:10];
    }
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 188;
}

- (void)dealloc {
    [dataArray release],dataArray = nil;
    [self.array release], self.array = nil;
    [super dealloc];
}
@end
