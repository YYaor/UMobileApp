//
//  YuJingDDViewController.h
//  UMobile
//
//  报警详情
//
//  Created by 陈 景云 on 14-11-9.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "KxMenu.h"

@interface YuJingDDViewController : RCViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) KxMenu *menu;

@property(nonatomic,retain) NSArray *info;
@property(nonatomic) NSUInteger type;

- (IBAction)addClick1:(id)sender;
- (IBAction)addClick2:(id)sender;


@end
