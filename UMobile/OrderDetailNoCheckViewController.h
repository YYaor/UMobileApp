//
//  OrderDetailNoCheckViewController.h
//  UMobile
//
//  Created by Rid on 14/12/14.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCMutileView.h"
#import "OrderProductsViewController.h"
#import "OrderHeaderViewController.h"

@interface OrderDetailNoCheckViewController : RCViewController{
    BOOL b;
}


@property (retain, nonatomic) IBOutlet RCMutileView *mutileView;
@property (retain, nonatomic) NSArray *info;


@property (retain,nonatomic) NSArray *keyIndex;

@property (nonatomic) NSUInteger callFunction;

@property (nonatomic,retain) NSArray *types;


@end
