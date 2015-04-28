//
//  OrderCheckViewController.h
//  UMobile
//
//  Created by 陈 景云 on 14-10-20.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "OrderHeaderViewController.h"
@interface OrderCheckViewController : RCViewController<UITableViewDataSource,UITableViewDelegate>

// fix  20150125

@property (retain, nonatomic) IBOutlet UILabel *checkLabel;

@property (assign, nonatomic) BOOL noCheck;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *result;
@property (nonatomic) NSInteger InvID;
@property (nonatomic) NSInteger InvType;

@end
