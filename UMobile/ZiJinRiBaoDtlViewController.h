//
//  ZiJinRiBaoDtlViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/21.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCTableView.h"
#import "PPiFlatSegmentedControl.h"
#import "XXFliterViewController.h"
#import "RiBaoDtlViewController.h"

@interface ZiJinRiBaoDtlViewController : RCViewController<RCTableViewDelegate>{
    NSUInteger page ;
}

@property (retain, nonatomic) NSMutableArray *result;
@property (retain, nonatomic) IBOutlet RCTableView *tableView;

@property (retain, nonatomic) IBOutlet PPiFlatSegmentedControl *segment;

@property (retain, nonatomic) NSString *navTitle;
@property (nonatomic) NSUInteger callFunction;
@property (nonatomic) NSUInteger callType;
@property (nonatomic) NSUInteger callID;

@property (nonatomic,retain) NSMutableDictionary *fliterDic;





@end
