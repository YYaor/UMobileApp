//
//  YWDJViewController.m
//  UMobile
//
//  Created by mocha on 15/5/4.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "YWDJViewController.h"
#import "CangKuViewController.h"
#import "SaleViewController.h"
#import "StockViewController.h"
#import "CustomerListViewController.h"
#import "RCDateView.h"

@interface YWDJViewController ()

@end

@implementation YWDJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetData];
    [self loadData];
}

-(void)resetData{
    [self setText:[self GetCurrentDate] forView:self.view withTag:1];
    [self setText:[self GetCurrentDate] forView:self.view withTag:2];
    self.orderType = [NSMutableArray arrayWithObjects:@"6",@"销售订单", nil];
    self.salesType = [NSMutableArray array];
    self.customerType = [NSMutableArray array];
    self.stockType = [NSMutableArray array];
    self.checkType = [NSMutableArray arrayWithObjects:@"2",@"未审", nil];
}

-(void)loadData{
    
    [self setText:[self.orderType ingoreObjectAtIndex:1] forView:self.view withTag:3];
    [self setText:@"" forView:self.view withTag:4];
    [self setText:[self.salesType ingoreObjectAtIndex:1] forView:self.view withTag:5];
    [self setText:[self.customerType ingoreObjectAtIndex:1] forView:self.view withTag:6];
    [self setText:[self.stockType ingoreObjectAtIndex:1] forView:self.view withTag:7];
    [self setText:[self.checkType ingoreObjectAtIndex:1] forView:self.view withTag:8];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag != 1 && textField.tag != 2 && textField.tag != 4 ){
        //        CangKuViewController *vc = (CangKuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CangKuViewController"];
        if (textField.tag != 5 && textField.tag != 6 && textField.tag != 7) {
            CangKuViewController *vc = (CangKuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CangKuViewController"];
            switch (textField.tag) {
                case 3:
                    vc.info = self.orderType;
                    vc.title = @"单据类型";
                    vc.result = @[@[@"5",@"进货订单"],@[@"6",@"销售订单"]];
                    break;
                case 8:
                    vc.info = self.checkType;
                    vc.title = @"审核状态";
                    if ([self.setting intForKey:@"ISBS"] == 1) {
                        vc.result = @[@[@"0",@"所有"],@[@"1",@"已审"],@[@"2",@"未审"],@[@"3",@"审核中"]];
                    }else{
                        vc.result = @[@[@"0",@"所有"],@[@"1",@"已审"],@[@"2",@"未审"]];
                    }
                    
                default:
                    break;
            }
            
            vc.parentVC = self;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (textField.tag == 5){
            SaleViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SaleViewController"];
            if ([[self.orderType objectAtIndex:0] integerValue] == 5)//销售订单
                vc.CustomerType = 4;
            else//进货订单
                vc.CustomerType = 3;
            vc.info = self.salesType;
            vc.parentVC = self;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (textField.tag == 6){
            CustomerListViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"CustomerListViewController"];
            if ([[self.orderType objectAtIndex:0] integerValue] == 5)//销售订单
                vc.CustomerType = 4;
            else//进货订单
                vc.CustomerType = 3;
            vc.customerInfo = self.customerType;
            vc.bSelect = YES;
            vc.parentVC = self;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(textField.tag == 7){
            StockViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StockViewController"];
            vc.info = self.stockType;
            vc.parentVC = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return NO;
    }else if (textField.tag == 1 || textField.tag == 2){
        RCDateView *dateView =  [[[RCDateView alloc]init] autorelease];
        [dateView ShowViewInObject:self.view withMsg:nil];
        while(dateView.isVisiable) {
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        }
        if (dateView.isOk){
            textField.text = dateView.strDate;
        }
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)resetClick:(id)sender {
    [self resetData];
    [self loadData];
}

- (IBAction)searchClick:(id)sender {
    NSString *param =  [NSString stringWithFormat:@"'%@','%@',%d,'%@',%d,%d,%d,%d,%@",
                        [self getTextFromView:self.view withTag:1],
                        [self getTextFromView:self.view withTag:2],
                        [[self.orderType ingoreObjectAtIndex:0] intValue],
                        [self getTextFromView:self.view withTag:4],
                        [[self.salesType ingoreObjectAtIndex:0] intValue],
                        [[self.customerType ingoreObjectAtIndex:0] intValue],
                        [[self.stockType ingoreObjectAtIndex:0] intValue],
                        [[self.checkType ingoreObjectAtIndex:0] intValue],
                        [self GetUserID]
                        ];
    NSString *link = [self GetLinkWithFunction:72 andParam:param];
    
    DDGLViewController *vc = (DDGLViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DDGLViewController"];
    vc.link = link;
    vc.param = param;
    vc.callFunction = [[self.orderType ingoreObjectAtIndex:0] intValue];// 值为 5 或 6 判断是进货订单或销售订单
    [self.navigationController pushViewController:vc animated:YES];
    //    NSString *link =  []
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

@end
