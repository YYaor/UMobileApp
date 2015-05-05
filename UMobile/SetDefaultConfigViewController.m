//
//  SetDefaultConfigViewController.m
//  UMobile
//
//  Created by live on 15-5-4.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "SetDefaultConfigViewController.h"
#import "SaleViewController.h"

@interface SetDefaultConfigViewController ()<saleViewControllerDelegate>

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
    if ([[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"salesInfo"]){
        NSDictionary *dic = [[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"salesInfo"];
        self.JSRField.text = [dic objectForKey:@"salesName"];
    }else{
        self.JSRField.text = @"";
    }
    //-----depart info
    if ([[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"departInfo"]){
        NSDictionary *dic = [[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"departInfo"];
        self.BMField.text = [dic objectForKey:@"departName"];
    }else{
        self.BMField.text = @"";
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
#pragma mark UITextField Delegate
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (textField == self.JSRField){
        SaleViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SaleViewController"];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (textField == self.BMField){
        
    }
    return NO;
}
#pragma mark SaleViewControllerDelegate
-(void) salesmanSelectedWithSalesId:(NSInteger)salesId salesName:(NSString *)salesName departId:(NSInteger)departId departName:(NSString *)departName{
    NSMutableDictionary *dic = nil;
    if ([self.setting objectForKey:@"SetDefaultParam"]){
        dic = [NSMutableDictionary dictionaryWithDictionary:[self.setting objectForKey:@"SetDefaultParam"]];
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    [dic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:salesId],@"salesId",salesName,@"salesName", nil] forKey:@"salesInfo"];
    [dic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:departId],@"departId",departName,@"departName", nil] forKey:@"departInfo"];
    [self.setting setObject:dic forKey:@"SetDefaultParam"];
    [self setDefaultValueForTextField];
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
