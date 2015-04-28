//
//  YYYFliterViewController.m
//  UMobile
//
//  Created by Rid on 15/1/26.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "YYYFliterViewController.h"

@implementation YYYFliterViewController

@synthesize names;
@synthesize callFunction,select_item;

-(void)dealloc{
    self.names = nil;
    self.orderType = nil;
    [super dealloc];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    for(int i = 0 ; i < [self.names count] ; i ++){
        [self setText:[self.names objectAtIndex:i] forView:self.view withTag:i + 11];
    }
    self.orderType = [NSMutableArray arrayWithObjects:@"-1",@"全部", nil];
    [self loadData];

}



- (IBAction)saveClick:(id)sender {
    
    
    [self.fliterDic setObject:[self getTextFromView:self.view withTag:1] forKey:@"1"];
    [self.fliterDic setObject:[self getTextFromView:self.view withTag:2] forKey:@"2"];
    [self.fliterDic setObject:[self.orderType objectAtIndex:0] forKey:@"3"];
    
    [self.parentVC loadData];
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)loadData{
    [self setText:[self.orderType objectAtIndex:1] forView:self.view withTag:3];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 3) {
        CangKuViewController *vc = (CangKuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CangKuViewController"];
        vc.info = self.orderType;
        vc.title = @"单据类型";
        NSArray *rs = [NSArray alloc];
        if ([self.setting intForKey:@"ISBS"] == 1) {// CS BS 区分
            if (self.callFunction == 34) {
                rs = @[@"全部",@"进货单",@"进货退货单",@"进货换货单"];
            }else{
                rs = @[@"全部",@"销售单",@"销售退货单",@"销售换货单",@"零售单"];
            }
        }else{
            if (self.callFunction == 34) {
                rs = @[@"全部",@"进货单",@"进货退货单",@"进货换货单",@"受托结算单"];
            }else{
                rs = @[@"全部",@"销售单",@"销售退货单",@"销售换货单",@"零售单",@"零售退货单",@"委托结算单"];
            }
        }
        
        NSMutableArray *result = [NSMutableArray array];
        for (NSString *value in rs){
            [result addObject:@[[self GetOrderType:value],value]];
        }
        vc.result = result;
        vc.parentVC = self;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}

@end
