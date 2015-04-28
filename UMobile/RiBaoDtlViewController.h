//
//  RiBaoDtlViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/21.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCTableView.h"
#import "RCAlertView.h"
#import "XXDMXViewController.h"
#import "KHFliterViewController.h"
#import "YYYFliterViewController.h"
typedef NS_ENUM(NSInteger, DateType) {
    DateTypeToday,
    DateTypeThisWeek,
    DateTypeThisMonth,
    DateTypeThisSeason
};
@interface RiBaoDtlViewController : RCViewController<RCTableViewDelegate>{
    NSUInteger page;
    NSUInteger nColumn;
}

@property(nonatomic,retain) NSMutableArray *result;
@property (retain, nonatomic) IBOutlet RCTableView *tableView;

@property (retain, nonatomic) NSString *navTitle;
@property (nonatomic) NSUInteger callFunction;
@property (nonatomic, copy) NSString *sId;
@property (nonatomic) DateType dateType;
@property (nonatomic) NSUInteger fixColumn;
@property (nonatomic,retain) NSMutableDictionary *fliterDic;

// add
@property (nonatomic) NSUInteger callType;

@end
