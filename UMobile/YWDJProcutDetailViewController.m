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
    array = [[NSMutableArray alloc] init];
    [array addObject:@"1"];
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
    [cell updateData];
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 188;
}

- (void)dealloc {

    [super dealloc];
}
@end
