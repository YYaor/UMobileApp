//
//  XXFliterViewController.h
//  UMobile
//
//  Created by Rid on 15/1/25.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "CangKuViewController.h"
#import "RCView.h"

@interface XXFliterViewController : RCViewController<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet RCView *backView;
@property(nonatomic,assign) NSMutableDictionary *fliterDic;
@property(nonatomic,retain) NSMutableArray *orderType;
@property(retain, nonatomic)NSArray *titles;
@property(retain, nonatomic)NSArray *select_item;
@property (nonatomic) NSUInteger callFunction;
@property(retain, nonatomic) NSArray *names;

@end
