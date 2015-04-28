//
//  YSZZDtlViewController.h
//  UMobile
//
//  Created by Rid on 15/1/16.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"


#import "RCTableView.h"
#import "RCAlertView.h"
typedef NS_ENUM(NSInteger, DateType) {
    DateTypeToday,
    DateTypeThisWeek,
    DateTypeThisMonth,
    DateTypeThisSeason
};
@interface YSZZDtlViewController : RCViewController<RCTableViewDelegate>{
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
@end
