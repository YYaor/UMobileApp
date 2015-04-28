//
//  LRFXViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/15.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCTableHeadSortView.h"
#import "ChartViewController.h"
#import "RiBaoDtlViewController.h"
#import "RCAlertView.h"
#import "RCTableView.h"

@interface LRFXViewController : RCViewController<UITableViewDataSource,UITableViewDelegate,RCTableViewDelegate>{
    NSUInteger page;
}

@property(nonatomic,retain) RCTableHeadSortView *sortView;

@property(nonatomic,retain) NSMutableArray *result;


@property (retain, nonatomic) IBOutlet RCTableView *tableView;
@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;
@property (retain, nonatomic) UIBarButtonItem *rightBarButton;

@property (nonatomic) Function_Type callFunction;

@property (nonatomic,retain) NSString *param;

@end
