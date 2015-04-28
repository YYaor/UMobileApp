//
//  OrderDetail2ViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/12/1.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "OrderDetail2ViewController.h"

@interface OrderDetail2ViewController ()

@end

@implementation OrderDetail2ViewController

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
    OrderProducts2ViewController *vc1 = (OrderProducts2ViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"OrderProducts2ViewController"];
    OrderHeader2ViewController *vc2 = (OrderHeader2ViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHeader2ViewController"];
    //    UIViewController *vc3 = [self.storyboard instant ghghiateViewControllerWithIdentifier:@"OrderCheckViewController"];
    
    vc1.info = self.info;
    vc1.keyIndex = self.keyIndex;
    vc1.types = self.types;
    vc2.info = self.info;
    vc2.keyIndex = self.keyIndex;
    vc2.types = self.types;
    self.mutileView.viewControllers = @[vc1,vc2];
    NSString *name = @"";
    NSInteger curFunction = [[self.types objectAtIndex:2] integerValue];
    if (curFunction == 101) {
        name = @"收款&核销明细";
    }else if(curFunction == 100) {
        name = @"付款&核销明细";
    }else if(curFunction == 118) {
        name = @"预收明细";
    }else if(curFunction == 119){
        name = @"预付明细";
    }else if(curFunction == 104){
        name = @"收入明细";
    }else if(curFunction == 102){
        name = @"费用单明细";
    }else if (callFunction == 105){
        name = @"转款明细";
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
- (IBAction)shenheClick:(id)sender {
    NSString *param = [NSString stringWithFormat:@"%d,0,%@,0,'','',1,0",self.callFunction,[self.info objectAtIndex:0]];
    NSString *link = [self GetLinkWithFunction:56 andParam:param];
    __block OrderDetail2ViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        NSArray *rs =  [[[obj objectFromJSONString] objectForKey:@"D_Data"] objectAtIndex:0];
        [tempSelf ShowMessage:[rs objectAtIndex:1]];
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
