//
//  XSMXDetailViewController.m
//  UMobile
//
//  Created by live on 15-5-5.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "XSMXDetailViewController.h"
#import "XSMXDetailTableViewCell.h"
#import "XSMXDetailHeaderView.h"
#import "XSMXDetailCellModel.h"

@interface XSMXDetailViewController ()<XSMXDetailTableViewCellDelegate,XSMXDetailHearViewDelegate>
{
    CGFloat scrollOffsetX;
}
@end

@implementation XSMXDetailViewController

@synthesize dataArray;
static const CGFloat cellHeight = 60;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] init];
    for (int i = 0;i<4;i++){
        XSMXDetailCellModel *model = [XSMXDetailCellModel parseDataFromArray:nil];
        [dataArray addObject:model];
    }
    [self.dataTableView reloadData];
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
#pragma mark TableViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIden = @"cell";
    XSMXDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell){
        cell = [[XSMXDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    cell.delegate =self;
    [cell updateCellWithData:[dataArray objectAtIndex:indexPath.row] contentOffset:scrollOffsetX];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *headerIden = @"header";
    XSMXDetailHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIden];
    if (!header){
        header = [[XSMXDetailHeaderView alloc] initWithReuseIdentifier:headerIden];
    }
    header.delegate = self;
    [header updateHeaderWidthScrollOffsetX:scrollOffsetX];
    return header;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return cellHeight;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (void)dealloc {
    [_dataTableView release];
    [super dealloc];
}
#pragma mark-
-(void) contentOffsetXChange:(CGFloat)offsetX{
    scrollOffsetX = offsetX;
    XSMXDetailHeaderView *header = (XSMXDetailHeaderView*)[self.dataTableView headerViewForSection:0];
    [header updateHeaderWidthScrollOffsetX:offsetX];
    NSArray *array = [self.dataTableView visibleCells];
    for (XSMXDetailTableViewCell *cell in array){
        [cell updateScrollOffsetX:offsetX];
    }
}
@end
