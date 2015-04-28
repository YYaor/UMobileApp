//
//  SettingViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/10/17.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCChooseButton.h"

@interface SettingViewController : RCViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) NSArray *titles;




@end
