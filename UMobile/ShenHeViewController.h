//
//  ShenHeViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/14.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "ShenHeDtlViewController.h"
#import "RCImageButton.h"

@interface ShenHeViewController : RCViewController

@property(nonatomic,retain) NSMutableArray *buttons;
@property(nonatomic,retain) NSMutableDictionary *types;
@property (retain, nonatomic) IBOutlet UIScrollView *scView;

@end
