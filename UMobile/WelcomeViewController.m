//
//  WelcomeViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/10/16.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationHide];


}

-(void)viewWillDisappear:(BOOL)animated{
    [self setNavigationShow];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setNavigationHide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginClick:(id)sender {
    [self.setting setObject:@"0" forKey:@"Demo"];
    UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)demoClick:(id)sender {
    if ([[self.setting strForKey:@"Show"] isEqual:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置未启用演示功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else {
        
        [self.setting setObject:@"1" forKey:@"Demo"];
        UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    [_imageView release];
    [super dealloc];
}
@end
