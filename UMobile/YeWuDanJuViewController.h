//
//  YeWuDanJuViewController.h
//  UMobile
//
//  Created by mocha on 15/4/30.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCImageButton.h"
#import "RCMutileView.h"
#import "XinZenHeaderViewController.h"

@interface YeWuDanJuViewController : RCViewController

@property (retain, nonatomic) IBOutlet RCMutileView *mutileView;
@property (retain, nonatomic) NSMutableArray *products;
@property (retain, nonatomic) NSMutableDictionary *headInfo;
@property (nonatomic) BOOL bEdit;
@property (nonatomic,retain) NSString *InvId;
@property (nonatomic,retain) NSString *AccID;

@property (nonatomic) BOOL bClean;
@end
