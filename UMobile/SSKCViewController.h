//
//  SSKCViewController.h
//  UMobile
//
//  Created by mocha on 15/5/4.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"

@interface SSKCViewController : RCViewController<UITextFieldDelegate>

@property(nonatomic,retain) NSMutableArray *stockType;

-(IBAction)restClick:(id)sender;

-(IBAction)searchClick:(id)sender;

@end
