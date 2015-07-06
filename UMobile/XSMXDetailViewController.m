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
#import "KxMenu.h"

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
    [self setupRefresh:self.dataTableView];
    [self.dataTableView headerBeginRefreshing];
    
}

-(void)headerRereshing{
     __block XSMXDetailViewController *tempSelf = self;
    NSString *paramString = [self getParamStringWithParamArray:self.paramArray];
    NSString *linkString = [self GetLinkWithFunction:93 andParam:paramString];
    linkString = [linkString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self StartQuery:linkString completeBlock:^(id obj) {
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [tempSelf.dataArray removeAllObjects];
        for (NSArray *array in rs) {
            XSMXDetailCellModel *model = [XSMXDetailCellModel parseDataFromArray:array];
            [tempSelf.dataArray addObject:model];
        }
        [tempSelf.dataTableView headerEndRefreshing];
        [tempSelf.dataTableView reloadData];
    } lock:YES];
}
-(void)footerRereshing{
    __block XSMXDetailViewController *tempSelf = self;
    //----page++
    if (self.paramArray.count > 9){
        NSNumber *pageNumber = [self.paramArray objectAtIndex:1];
        NSNumber *newPage = [NSNumber numberWithInt:[pageNumber intValue]+1];
        [self.paramArray replaceObjectAtIndex:9 withObject:newPage];
    }
    NSString *paramString = [self getParamStringWithParamArray:self.paramArray];
    NSString *linkString = [self GetLinkWithFunction:93 andParam:paramString];
    linkString = [linkString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self StartQuery:linkString completeBlock:^(id obj) {
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        for (NSArray *array in rs) {
            XSMXDetailCellModel *model = [XSMXDetailCellModel parseDataFromArray:array];
            [tempSelf.dataArray addObject:model];
        }
        [tempSelf.dataTableView footerEndRefreshing];
        [tempSelf.dataTableView reloadData];
        if (rs.count <= 0 && tempSelf.paramArray.count > 9){
            NSNumber *pageNumber = [tempSelf.paramArray objectAtIndex:1];
            NSNumber *newPage = [NSNumber numberWithInt:MAX([pageNumber intValue]-1,1)];
            [tempSelf.paramArray replaceObjectAtIndex:9 withObject:newPage];
        }
    } lock:YES];

}
-(void)sortMenuClick:(KxMenuItem *)item{
    NSDictionary *dates = @{@"本日":@"Today",@"本周":@"thisWeek",@"本月":@"thisMonth"};
    NSDictionary *info = [[self GetOM] getFlowDate];
    //[self setText:[info strForKey:[dates strForKey:item.title]] forView:self.view withTag:1];
    [self.paramArray replaceObjectAtIndex:5 withObject:[info strForKey:[dates strForKey:item.title]]];
    [self.paramArray replaceObjectAtIndex:6 withObject:[info strForKey:@"Today"]];
    [self headerRereshing];
}


- (IBAction)sortClick:(id)sender {
    if ([KxMenu sharedMenu].isVisiable) {
        [KxMenu dismissMenu];
        return;
    }
    NSArray *menus = @[
                       [KxMenuItem menuItem:@"本日" image:[UIImage imageNamed:@"popup_icon_approve_date"] target:self action:@selector(sortMenuClick:)],
                       [KxMenuItem menuItem:@"本周" image:[UIImage imageNamed:@"popup_icon_approve_curweek"] target:self action:@selector(sortMenuClick:)],
                       [KxMenuItem menuItem:@"本月" image:[UIImage imageNamed:@"popup_icon_approve_curmonth"] target:self action:@selector(sortMenuClick:)],
                       ];
    [KxMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width/2, 0, 10, 1) menuItems:menus];
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
    self.link = nil;
    self.parma = nil;
    [super dealloc];
}
- (IBAction)disMiss:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate{
    return YES;
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
