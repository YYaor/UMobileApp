//
//  FlowViewController.m
//  UMobile
//
//  Created by 陈 景云 on 14-11-12.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "FlowViewController.h"

@interface FlowViewController ()

@end

@implementation FlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.titles = @[@"时间",@"移动",@"WIFI",@"合计"];
    self.tableView.titleWidths = @[@"80",@"80",@"80",@"80"];
    self.tableView.keys = @[@"0",@"1",@"2",@"3"];
    self.tableView.result =  [[self GetOM] getFlow];
    self.tableView.alignment = NSTextAlignmentCenter;
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView initContent];
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
- (IBAction)clearClick:(id)sender {
    [[self GetOM] clearFlow];
    self.tableView.result =  [[self GetOM] getFlow];
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
