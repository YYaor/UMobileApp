//
//  OrderDetailCheckViewController.m
//  UMobile
//
//  Created by Rid on 15/1/23.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "OrderDetailCheckViewController.h"

@implementation OrderDetailCheckViewController


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
    UIViewController *vc3 = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderCheckViewController"];
    
    vc1.info = self.info;
    vc1.keyIndex = self.keyIndex;
    vc1.types = self.types;
    vc1.parentVC = self;
    vc2.info = self.info;
    vc2.keyIndex = self.keyIndex;
    vc2.types = self.types;
    vc2.parentVC = self;
    
    NSString *name = @"商品明细";
    if (self.callFunction == 7 || self.callFunction == 8) {
        name = @"调拨明细";
    }
    if (self.noCheck){
        self.mutileView.viewControllers = @[vc1,vc2,vc3];
        self.mutileView.titles = @[name,@"主单据",@"审核历史"];
    }else{
        self.mutileView.viewControllers = @[vc1,vc2];
        self.mutileView.titles = @[name,@"主单据"];
    }
    
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

// fixBug       ghd         20150122
- (IBAction)copyBtnAction:(id)sender {
    NSLog(@"复制");
}

- (IBAction)printBtnAction:(id)sender {
    NSLog(@"打印");
}



- (IBAction)shenheClick:(id)sender {
    NSString *param = [NSString stringWithFormat:@"%@,%@,%@,0,'','',%@,0",[self.info objectAtIndex:2],[self.info objectAtIndex:0],[self.info objectAtIndex:4],[self GetUserID]];
    NSString *link = [self GetLinkWithFunction:56 andParam:param];
    __block OrderDetailCheckViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        NSArray *rs =  [[[obj objectFromJSONString] objectForKey:@"D_Data"] objectAtIndex:0];
        if ([[rs objectAtIndex:0] integerValue] == 0){
            [tempSelf makeToastInWindow:@"审核成功"];
            [tempSelf.parentVC performSelector:@selector(loadData) withObject:nil];
            [tempSelf dismiss];
        }else{
            [tempSelf makeToastInWindow:[rs objectAtIndex:1]];
        }
    } lock:YES];
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
