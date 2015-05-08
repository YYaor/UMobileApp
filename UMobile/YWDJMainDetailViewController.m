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
    self.danJuBianHaoLabel.text = [self.array objectAtIndex:5];
    self.DanJuRiQiLabel.text =[self.array objectAtIndex:4];
    self.changKuLabel.text =[self.array objectAtIndex:13];
    self.jinShouRenLabel.text = [self.array objectAtIndex:15];
    self.shuLianLabel.text = [self.array objectAtIndex:23];
    self.jingENeiRongLabel.text = [self.array objectAtIndex:16];
    self.shouKuanZhangHuLabel.text = [self.array objectAtIndex:21];
    self.shouKuanJingELabel.text = [self.array objectAtIndex:22];
    
    self.mingChengLabel.text = [self.array objectAtIndex:8];
    self.lianXiRenLabel.text = [self.array objectAtIndex:9];
    self.lianXiDianHua.text = [self.array objectAtIndex:10];
    self.shouJiHaoLabel.text = [self.array objectAtIndex:11];
    
    self.zhaiYaoLabel.text = [self.array objectAtIndex:18];
    self.fuJiaShuoMing.text = [self.array objectAtIndex:19];
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
