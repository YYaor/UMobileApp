//
//  SetDefaultConfigViewController.h
//  UMobile
//
//  Created by live on 15-5-4.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"

@interface SetDefaultConfigViewController : RCViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UIView *backView;
@property (retain, nonatomic) IBOutlet UITextField *JSRField;
@property (retain, nonatomic) IBOutlet UITextField *BMField;
@property (retain, nonatomic) IBOutlet UITextField *KHField;
@property (retain, nonatomic) IBOutlet UITextField *GYSField;
@property (retain, nonatomic) IBOutlet UITextField *FHCKField;
@property (retain, nonatomic) IBOutlet UITextField *DHCKField;
@property (retain, nonatomic) IBOutlet UITextField *FKZHField;
@property (retain, nonatomic) IBOutlet UITextField *SKZHField;
@property (retain, nonatomic) IBOutlet UIButton *CZButton;

@end
