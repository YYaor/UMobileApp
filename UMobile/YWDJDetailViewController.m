//
//  YWDJDetailViewController.m
//  UMobile
//
//  Created by yunyao on 15/5/7.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "YWDJDetailViewController.h"
#import "YWDJMainDetailViewController.h"
#import "YWDJProcutDetailViewController.h"

@interface YWDJDetailViewController ()

@end

@implementation YWDJDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SecondaryStoryboard" bundle:nil];
    
    YWDJProcutDetailViewController *productDetail = [storyBoard instantiateViewControllerWithIdentifier:@"YWDJProcutDetailViewController"];
    productDetail.parentVC = self;
    productDetail.array = self.array;
    
    YWDJMainDetailViewController *mainDetail = [storyBoard instantiateViewControllerWithIdentifier:@"YWDJMainDetailViewController"];
    mainDetail.parentVC = self;
    mainDetail.array = self.array;
    self.mutliView.titles = @[@"商品明细",@"主单据"];
    self.mutliView.viewControllers = @[productDetail,mainDetail];
    self.mutliView.selectIndex = 1;
    

}
- (IBAction)copyButtonClicked:(UIButton *)sender {
}
- (IBAction)printButtonClicked:(UIButton *)sender {
}
- (IBAction)deleteButtonClicked:(UIButton *)sender {
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
    [_mutliView release];
    [_printButton release];
    [_dataCopyButton release];
    [_deleteButton release];
    [super dealloc];
}
@end
