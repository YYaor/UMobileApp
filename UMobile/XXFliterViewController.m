//
//  XXFliterViewController.m
//  UMobile
//
//  Created by Rid on 15/1/25.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "XXFliterViewController.h"

@implementation XXFliterViewController

@synthesize titles,callFunction,select_item;

-(void)dealloc{
    self.names = nil;
    self.orderType = nil;
    [_backView release];
    [super dealloc];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSArray *rs = [NSArray alloc];
    if(self.callFunction == 21 ){
        UILabel *title5 = (UILabel *)[self.view viewWithTag:5];
        UILabel *title6 = (UILabel *)[self.view viewWithTag:6];
        UILabel *title7 = (UILabel *)[self.view viewWithTag:7];
        UILabel *title8 = (UILabel *)[self.view viewWithTag:8];
        
        if ([self.setting intForKey:@"ISBS"] == 1) {// CS BS 区分
            titles = @[@"经手人",@"客户名称",@"单据日期",@"单据类型"];
            rs = @[@"全部",@"销售单",@"销售退货单",@"销售换货单",@"零售单"];
        }else{
            titles = @[@"客户名称",@"经手人",@"单据编号",@"单据类型"];
            rs = @[@"全部",@"销售单",@"销售退货单",@"销售换货单",@"零售单",@"零售退货单",@"委托结算单"];
        }
        
        
        title5.text = [titles objectAtIndex:0];
        title6.text = [titles objectAtIndex:1];
        title7.text = [titles objectAtIndex:2];
        title8.text = [titles objectAtIndex:3];

    }else if(self.callFunction == 22 ){
        UILabel *title5 = (UILabel *)[self.view viewWithTag:5];
        UILabel *title6 = (UILabel *)[self.view viewWithTag:6];
        UILabel *title7 = (UILabel *)[self.view viewWithTag:7];
        UILabel *title8 = (UILabel *)[self.view viewWithTag:8];
        
        titles = @[@"业务员",@"供应商名称",@"单据编号",@"单据类型"];
        
        title5.text = [titles objectAtIndex:0];
        title6.text = [titles objectAtIndex:1];
        title7.text = [titles objectAtIndex:2];
        title8.text = [titles objectAtIndex:3];
        
        
        if ([self.setting intForKey:@"ISBS"] == 1) {// CS BS 区分
            rs = @[@"全部",@"进货单",@"进货退货单",@"进货换货单"];
        }else{
            rs = @[@"全部",@"进货单",@"进货退货单",@"进货换货单",@"受托结算单"];
        }
    }else if (self.callFunction == 1){
        
    }else{
        rs = @[@"全部",@"销售单",@"销售退货单",@"销售换货单",@"零售单"];
    }
    
    //NSArray *rs = @[@"全部",@"销售单",@"销售退货单",@"销售换货单",@"零售单",@"零售退货单",@"委托结算单"];
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *value in rs){
        [result addObject:@[[self GetOrderType:value],value]];
    }
    self.select_item = result;
    
    self.orderType = [NSMutableArray arrayWithObjects:@"-1",@"全部", nil];
    [self setTitleNames];
    [self loadData];
}

-(void)setTitleNames{
    if (self.names) {
        int i = 10;
        for(NSString *name in self.names){
            if ([name length]>0)
                [self setText:name forView:self.view withTag:i++];
        }
    }
}



- (IBAction)saveClick:(id)sender {
    for (int i  = 1 ; i < 4 ; i ++){
        [self.fliterDic setObject:[self getTextFromView:self.backView withTag:i] forKey:[NSString stringWithFormat:@"%d",i]];
    }
    [self.fliterDic setObject:[self.orderType objectAtIndex:0] forKey:@"4"];
    
    [self.parentVC loadData];
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)loadData{
    [self setText:[self.orderType objectAtIndex:1] forView:self.view withTag:4];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 4) {
        CangKuViewController *vc = (CangKuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CangKuViewController"];
        vc.info = self.orderType;
        vc.title = @"查询";
        vc.result = self.select_item;
        vc.parentVC = self;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}

@end
