//
//  SetDefaultConfigViewController.m
//  UMobile
//
//  Created by live on 15-5-4.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "SetDefaultConfigViewController.h"

@interface SetDefaultConfigViewController ()

@end

@implementation SetDefaultConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self adjustInterface];
    [self setDefaultValueForTextField];
}
-(void) adjustInterface{
    self.backView.layer.cornerRadius = 4;
    self.CZButton.layer.cornerRadius = 1.5;
}
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)CZButtonClicked:(UIButton *)sender {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) setDefaultValueForTextField{

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark UITextField Delegate
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    
    return NO;
}

- (void)dealloc {
    [_JSRField release];
    [_BMField release];
    [_KHField release];
    [_GYSField release];
    [_FHCKField release];
    [_DHCKField release];
    [_FKZHField release];
    [_SKZHField release];
    [_CZButton release];
    [_backView release];
    [super dealloc];
}
@end
