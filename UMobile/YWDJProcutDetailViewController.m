//
//  YWDJProcutDetailViewController.m
//  UMobile
//
//  Created by yunyao on 15/5/7.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "YWDJProcutDetailViewController.h"

@interface YWDJProcutDetailViewController ()

@end

@implementation YWDJProcutDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [_MingChengLabel release];
    [_bianMaLabel release];
    [_guiGeLabel release];
    [_xingHaoLabel release];
    [_danWeiLabel release];
    [_shuLiangLabel release];
    [_danJiaLabel release];
    [_zheHouDanJiaLabel release];
    [_zhenPingLabel release];
    [_zheHouJingELabel release];
    [_piHaoXingXiLabel release];
    [super dealloc];
}
@end
