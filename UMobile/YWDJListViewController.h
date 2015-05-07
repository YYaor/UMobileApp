//
//  YWDJListViewController.h
//  UMobile
//
//  Created by yunyao on 15/5/7.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"

@interface YWDJListViewController : RCViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *dataTableView;
@property (retain, nonatomic) IBOutlet UISearchBar *dataSearchBar;

@property(nonatomic,retain) NSString *link;
@property(nonatomic,retain) NSString *param;
@property(nonatomic) NSUInteger callFunction;
@end
