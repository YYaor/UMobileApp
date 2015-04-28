//
//  XinZenShangPingViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/24.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "CangKuViewController.h"
#import "RCCheckButton.h"
#import "UnitViewController.h"
#import "PriceViewController.h"

@interface XinZenShangPingViewController : RCViewController<UITextFieldDelegate>{
   
}

@property(nonatomic,assign) NSMutableDictionary *productInfo;
@property(nonatomic,retain) NSMutableDictionary *cpInfo;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property(retain, nonatomic) NSMutableArray *unitInfo;
@property(retain, nonatomic) NSMutableArray *priceInfo;

@property(retain, nonatomic) NSString * toBeString;
@property(retain,nonatomic) NSString *oldValue;

@property (retain, nonatomic) IBOutlet UIButton *moreButton;

@property (nonatomic) NSUInteger selectIndex;
@property(nonatomic,assign) NSMutableArray *result;
@property (nonatomic,assign) NSMutableDictionary *headInfo;

// add
@property (nonatomic, retain) NSString *orderType;

@property (nonatomic, retain) UITextField *textField;

- (void)updateMsg;


@end
