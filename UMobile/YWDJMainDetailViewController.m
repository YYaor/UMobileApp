//
//  YWDJMainDetailViewController.m
//  UMobile
//
//  Created by yunyao on 15/5/7.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "YWDJMainDetailViewController.h"

@interface YWDJMainDetailViewController ()

@end

@implementation YWDJMainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [_danJuBianHaoLabel release];
    [_DanJuRiQiLabel release];
    [_changKuLabel release];
    [_jinShouRenLabel release];
    [_shuLianLabel release];
    [_jingENeiRongLabel release];
    [_shouKuanZhangHuLabel release];
    [_shouKuanJingELabel release];
    [_mingChengLabel release];
    [_lianXiRenLabel release];
    [_lianXiDianHua release];
    [_shouJiHaoLabel release];
    [_zhaiYaoLabel release];
    [_fuJiaShuoMing release];
    [super dealloc];
}
@end
