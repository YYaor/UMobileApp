//
//  OrderDetailCheckViewController.h
//  UMobile
//
//  Created by Rid on 15/1/23.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCMutileView.h"
#import "OrderProductsViewController.h"
#import "OrderHeaderViewController.h"

@interface OrderDetailCheckViewController : RCViewController{
    BOOL b;
}


@property (retain, nonatomic) IBOutlet RCMutileView *mutileView;
@property (retain, nonatomic) NSArray *info;


@property (retain,nonatomic) NSArray *keyIndex;

@property (nonatomic) NSUInteger callFunction;

@property (nonatomic,retain) NSArray *types;

@property(nonatomic) BOOL noCheck;


@end
