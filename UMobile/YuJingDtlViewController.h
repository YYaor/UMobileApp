//
//  YuJingDtlViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/10.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "YuJingSPViewController.h"
#import "YuJingDDViewController.h"
#import "OrderDetailController.h"
#import "OrderDetailNoCheckViewController.h"


@interface YuJingDtlViewController : RCViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    NSInteger page;
}


@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,retain) NSMutableArray *result;
@property (nonatomic,retain) NSArray *keys;


@property (nonatomic) NSInteger callFunction;
@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;

@end
