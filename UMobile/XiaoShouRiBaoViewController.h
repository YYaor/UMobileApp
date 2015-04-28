//
//  XiaoShouRiBaoViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/20.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCColumnView.h"
#import "PPiFlatSegmentedControl.h"

@interface XiaoShouRiBaoViewController : RCViewController

@property (retain, nonatomic) IBOutlet RCColumnView *columnView;
@property (retain, nonatomic) NSArray *result;
@property (retain, nonatomic) IBOutlet PPiFlatSegmentedControl *segmentedController;

@end
