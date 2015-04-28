//
//  OrderDetailController.h
//  UMobile
//
//  Created by  APPLE on 2014/10/17.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCMutileView.h"
#import "OrderProductsViewController.h"
#import "OrderHeaderViewController.h"
#import "OrderCheckViewController.h"
#import "XinZenDingDanViewController.h"

//无审核 功能 订单详情

@interface OrderDetailController : RCViewController{
    BOOL b;
    BOOL b1,b2,b3;
    BOOL bEdit;
}


@property (retain, nonatomic) IBOutlet RCMutileView *mutileView;
@property (retain, nonatomic) NSArray *info;


@property (retain,nonatomic) NSArray *keyIndex;

@property (nonatomic) NSUInteger callFunction;

@property (nonatomic,retain) NSArray *types;

@property(nonatomic) BOOL noCheck;
@property(nonatomic,retain) NSMutableDictionary *hInfo;

// fix add button.hidden flag   20150124

@property (assign, nonatomic) BOOL isHidden;
@property (assign, nonatomic) BOOL fromCheck;
@property (nonatomic) BOOL bClean;

@property (retain, nonatomic) IBOutlet UIButton *cpoyButton;
@property (retain, nonatomic) IBOutlet UIButton *printButton;
@property (retain, nonatomic) IBOutlet UIButton *checkButton;

@property (nonatomic) BOOL bloadInfo;

@property (nonatomic,retain) NSArray *headInfo;//未审核订单传单头信息
@property (nonatomic,retain) NSString *strID; //未审核订单ID

@end
