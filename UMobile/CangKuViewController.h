//
//  CangKuViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/23.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"

@interface CangKuViewController : RCViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>


@property (nonatomic,assign) NSMutableArray *info;
@property (nonatomic,retain) NSArray *result;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *link;
@property (nonatomic) NSUInteger showIndex;

@end
