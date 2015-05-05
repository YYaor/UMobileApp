//
//  YWDJViewController.h
//  UMobile
//
//  Created by mocha on 15/5/4.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"

@interface YWDJViewController : RCViewController<UITextFieldDelegate>

@property(nonatomic,retain) NSMutableArray *orderType;
@property(nonatomic,retain) NSMutableArray *salesType;
@property(nonatomic,retain) NSMutableArray *customerType;
@property(nonatomic,retain) NSMutableArray *stockType;
@property(nonatomic,retain) NSMutableArray *checkType;

@end
