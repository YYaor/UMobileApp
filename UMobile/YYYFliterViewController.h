//
//  YYYFliterViewController.h
//  UMobile
//
//  Created by Rid on 15/1/26.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "CangKuViewController.h"

@interface YYYFliterViewController : RCViewController<UITextFieldDelegate>

@property(nonatomic,assign) NSMutableDictionary *fliterDic;
@property(nonatomic,retain) NSMutableArray *orderType;
@property(nonatomic) NSUInteger callFunction;
@property(nonatomic,retain) NSArray *names;
@property(retain, nonatomic)NSArray *select_item;


@end
