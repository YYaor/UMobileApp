//
//  YWDJListViewController.m
//  UMobile
//
//  Created by yunyao on 15/5/7.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "YWDJListViewController.h"

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
    
    return cell;
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
