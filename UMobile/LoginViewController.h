//
//  LoginViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/10/16.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "CangKuViewController.h"
#import "RCCheckButton.h"
#import "RCAlertView.h"
#import "AppDelegate.h"
#import "RCView.h"

@interface LoginViewController : RCViewController<UITextFieldDelegate>{
      AppDelegate *_appDelegate;
}


@property(nonatomic,retain) NSMutableArray *info;
@property (retain, nonatomic) IBOutlet RCCheckButton *checkButton;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet RCView *backView;

@end
