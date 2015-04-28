//
//  OrderDetail2ViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/12/1.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCMutileView.h"
#import "OrderHeader2ViewController.h"
#import "OrderProducts2ViewController.h"
#import "OrderCheckViewController.h"

// 可审核订单
/* for 以下类型
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
}else if(curFunction == 102 || curFunction == 103){
    name = @"费用单明细";
}else if (curFunction == 105){
    name = @"转款明细";
}
*/

@interface OrderDetail2ViewController : RCViewController{
    BOOL b;
}


@property (retain, nonatomic) IBOutlet RCMutileView *mutileView;
@property (retain, nonatomic) NSArray *info;


@property (retain,nonatomic) NSArray *keyIndex;

@property (nonatomic) NSUInteger callFunction;

@property (nonatomic,retain) NSArray *types;

@end
