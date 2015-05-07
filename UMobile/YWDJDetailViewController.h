//
//  YWDJDetailViewController.h
//  UMobile
//
//  Created by yunyao on 15/5/7.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCMutileView.h"

@interface YWDJDetailViewController : RCViewController
@property (retain, nonatomic) IBOutlet RCMutileView *mutliView;
@property (retain, nonatomic) IBOutlet UIButton *dataCopyButton;

@property (retain, nonatomic) IBOutlet UIButton *printButton;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;

@end
