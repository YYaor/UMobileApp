//
//  PaiHangViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/16.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "PaiHangViewController.h"

@interface PaiHangViewController ()

@end

@implementation PaiHangViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationShow];
    RCViewController *vc1 = (RCViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"PaiHangSPViewController"];
    RCViewController *vc2 =  (RCViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PaiHangKHViewController"];
    RCViewController *vc3 =  (RCViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PaiHangYWYViewController"];
    vc1.parentVC = self;
    vc2.parentVC = self;
    vc3.parentVC = self;
    
    
//    if([@"1" isEqual:[[self setting] objectForKey:@"ISBS"]]){   //区分BS帐套
//        self.mutileView.titles = @[@"商品",@"客户",@"业务员"];
//    }else{
        self.mutileView.titles = @[@"商品",@"客户",@"业务员"];
//    }
    
    self.mutileView.viewControllers = @[vc1,vc2,vc3];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_mutileView release];
    [super dealloc];
}

@end
