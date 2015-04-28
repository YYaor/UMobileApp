//
//  ShangPinDtlViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/14.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCTableTitleView.h"

@interface ShangPinDtlViewController : RCViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *result;
@property (nonatomic) NSUInteger shID;

@property (assign, nonatomic) NSMutableArray *products;
@property (nonatomic, getter=isFailedJSON) BOOL failedJSON;
@property (nonatomic, copy) NSString * detail;

@end
