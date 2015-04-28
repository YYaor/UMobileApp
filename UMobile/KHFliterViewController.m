//
//  KHFliterViewController.m
//  UMobile
//
//  Created by Rid on 15/1/25.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "KHFliterViewController.h"

@implementation KHFliterViewController

@synthesize callFunction,select_item;

-(void)dealloc{
    self.orderType = nil;
    [super dealloc];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.orderType = [NSMutableArray arrayWithObjects:@"-1",@"全部", nil];
    [self loadData];
    
    NSArray *rs = [NSArray array];
    if (self.callFunction == 79) {
        [self setText:@"单据编号" forView:self.view withTag:99];
        rs = @[@"全部",@"销售单",@"销售换货单",@"销售退货单",@"零售退货单",@"零售单",@"收款单",@"应收款增加",@"应收款减少",@"其他收入单",@"固定资产变卖单"];
    }else if (self.callFunction == 25 || self.callFunction == 28 || self.callFunction == 48 || self.callFunction == 31) {
        
        if (self.callFunction == 25){
//            if ([self.setting intForKey:@"ISBS"] == 1) {// CS BS 区分
                rs = @[@"全部",@"销售单",@"销售退货单",@"销售换货单",@"零售单",@"收款单",@"其他收入单",@"应收款增加",@"应收款减少",@"固定资产变卖单",@"会计凭证"];
//            }else{
//                rs = @[@"全部",@"销售单",@"销售退货单",@"销售换货单",@"零售单",@"零售退货单",@"委托结算单",@"收款单",@"其他收入单",@"应收款增加",@"应收款减少",@"固定资产变卖单",@"会计凭证"];
//            }
        }else if (self.callFunction == 28){
            if ([self.setting intForKey:@"ISBS"] == 1) {// CS BS 区分
                rs = @[@"全部",@"进货单",@"进货退货单",@"进货换货单",@"付款单",@"一般费用单",@"应付款增加",@"应付款减少",@"固定资产购买单",@"会计凭证"];
            }else{
                rs = @[@"全部",@"进货单",@"进货退货单",@"进货换货单",@"受托结算单",@"付款单",@"一般费用单",@"应付款增加",@"应付款减少",@"固定资产购买单",@"会计凭证"];
//                rs = @[@"全部",@"销售单",@"销售退货单",@"销售换货单",@"零售单",@"零售退货单",@"委托结算单"];
            }
        }else{
            if ([self.setting intForKey:@"ISBS"] == 1) {// CS BS 区分
                rs = @[@"全部",@"销售单",@"销售退货单",@"销售换货单",@"零售单"];
            }else{
                rs = @[@"全部",@"销售单",@"销售退货单",@"销售换货单",@"零售单",@"零售退货单",@"委托结算单"];
            }
        }
        
    }else if (self.callFunction == 55){
        rs = @[@"全部",@"销售单",@"销售退货单",@"销售换货单",@"零售单",@"收款单",@"其他收入单",@"应收款增加",@"应收款减少",@"固定资产变卖单",@"会计凭证"];
    }else{
        rs = @[@"全部",@"销售单",@"销售退货单",@"销售换货单",@"零售单",@"零售退货单",@"委托结算单"];
    }
    
    //NSArray *rs = @[@"全部",@"销售单",@"销售退货单",@"销售换货单",@"零售单",@"零售退货单",@"委托结算单"];
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *value in rs){
        [result addObject:@[[self GetOrderType:value],value]];
    }
    self.select_item = result;
    
}



- (IBAction)saveClick:(id)sender {

    
    [self.fliterDic setObject:[self getTextFromView:self.view withTag:1] forKey:@"1"];
    [self.fliterDic setObject:[self.orderType objectAtIndex:0] forKey:@"2"];
    
    [self.parentVC loadData];
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)loadData{
    [self setText:[self.orderType objectAtIndex:1] forView:self.view withTag:2];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 2) {
        CangKuViewController *vc = (CangKuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CangKuViewController"];
        vc.info = self.orderType;
        vc.title = @"单据类型";
        vc.result = self.select_item;
        vc.parentVC = self;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}

@end
