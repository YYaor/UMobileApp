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
    OrderCheckViewController *vc3 = (OrderCheckViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"OrderCheckViewController"];
    
    vc1.info = self.info;
    vc1.keyIndex = self.keyIndex;
    vc1.types = self.types;
    vc2.info = self.info;
    vc2.keyIndex = self.keyIndex;
    vc2.types = self.types;
    vc3.noCheck = YES;// self.noCheck;
    
    vc1.shType = self.shType;
    vc2.shType = self.shType;
    vc3.shType = self.shType;
    
    vc3.parentVC = vc2;
    
    
    NSString *name = @"";
    NSInteger curFunction = [[self.types objectAtIndex:2] integerValue];
    if (curFunction == 101) {
        name = @"收款&核销明细";
    }else if(curFunction == 100) {
        name = @"付款&核销明细";
    }else if(curFunction == 128 || curFunction == 118) {
        name = @"预收明细";
    }else if(curFunction == 129 || curFunction == 119){
        name = @"预付明细";
    }else if(curFunction == 104){
        name = @"收入明细";
    }else if(curFunction == 102 || curFunction == 103){
        name = @"费用单明细";
    }else if (curFunction == 105){
        name = @"转款明细";
    }
    if ((curFunction == 101 || curFunction == 100 || curFunction == 102 || curFunction == 105 ||
         curFunction == 103 || curFunction == 104  || curFunction == 128 || curFunction == 118 ||
         curFunction == 129 || curFunction == 119)
        && [self.setting intForKey:@"ISBS"] == 1) {
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
- (IBAction)shenheClick:(id)sender {
    NSString *param = [NSString stringWithFormat:@"%@,%@,%@,0,'','',%@,0",[self.info objectAtIndex:2],[self.info objectAtIndex:0],[self.info objectAtIndex:4],[self GetUserID]];
    NSString *link = [self GetLinkWithFunction:56 andParam:param];
    __block OrderDetail2ViewController *tempSelf = self;
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
