//
//  OrderDetailNoCheckViewController.m
//  UMobile
//
//  Created by Rid on 14/12/14.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "OrderDetailNoCheckViewController.h"

@interface OrderDetailNoCheckViewController ()

@end

@implementation OrderDetailNoCheckViewController

@synthesize info;
@synthesize keyIndex;
@synthesize callFunction;
@synthesize types;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewControllers];
    
    // Do any additional setup after loading the view.
}

-(void)setViewControllers{
    OrderProductsViewController *vc1 = (OrderProductsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"OrderProductsViewController"];
    OrderHeaderViewController *vc2 = (OrderHeaderViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHeaderViewController"];
    //    UIViewController *vc3 = [self.storyboard instant ghghiateViewControllerWithIdentifier:@"OrderCheckViewController"];
    
    vc1.info = self.info;
    vc1.keyIndex = self.keyIndex;
    vc1.types = self.types;
    vc2.info = self.info;
    vc2.keyIndex = self.keyIndex;
    vc2.types = self.types;
    
    vc1.yjType = self.yjType;
    vc2.yjType = self.yjType;
    self.mutileView.viewControllers = @[vc1,vc2];
    NSString *name = @"商品明细";
    if (self.callFunction == 7 || self.callFunction == 8) {
        name = @"调拨明细";
    }
    self.mutileView.titles = @[name,@"主单据"];
    self.mutileView.selectIndex = 1;
}

-(void)viewDidAppear:(BOOL)animated{
    
    if(b) return;
    b = YES;
    [self.mutileView layoutSubviews];
    //    [self performSelectorOnMainThread:@selector(setViewControllers) withObject:nil waitUntilDone:YES];
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
    self.types = nil;
    self.keyIndex = nil;
    self.info = nil;
    [_mutileView release];
    [super dealloc];
}

@end
