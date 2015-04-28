//
//  UnitViewController.h
//  UMobile
//
//  Created by Rid on 14/12/11.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"

@interface UnitViewController : RCViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) NSArray *result;
@property (retain, nonatomic) NSArray *keys;

@property (assign, nonatomic) NSMutableDictionary *productInfo;

@end
