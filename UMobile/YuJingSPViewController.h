//
//  YuJingSPViewController.h
//  UMobile
//
//  Created by 陈 景云 on 14-11-9.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCView.h"

@interface YuJingSPViewController : RCViewController<UITableViewDataSource, UITableViewDelegate>

@property(retain, nonatomic) NSArray *info;
@property(nonatomic) NSUInteger type;

// change
@property (retain, nonatomic) IBOutlet UITableView *tableview;

@end
