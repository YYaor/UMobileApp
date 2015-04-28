//
//  KHFliterViewController.h
//  UMobile
//
//  Created by Rid on 15/1/25.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "CangKuViewController.h"

@interface KHFliterViewController : RCViewController

@property(nonatomic,assign) NSMutableDictionary *fliterDic;
@property(nonatomic,retain) NSMutableArray *orderType;
@property(nonatomic) NSUInteger callFunction;
@property(retain, nonatomic)NSArray *select_item;

@end
