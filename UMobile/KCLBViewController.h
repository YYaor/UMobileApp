//
//  KCLBViewController.h
//  UMobile
//
//  Created by mocha on 15/5/6.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"

@interface KCLBViewController : RCViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSUInteger shID;
@end
