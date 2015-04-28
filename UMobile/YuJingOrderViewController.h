//
//  YuJingOrderViewController.h
//  UMobile
//
//  Created by Rid on 15/1/6.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "YuJingSPViewController.h"
#import "YuJingDDViewController.h"
#import "OrderDetailController.h"
#import "OrderDetailNoCheckViewController.h"

@interface YuJingOrderViewController : RCViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    NSInteger page;
    BOOL bDateAsc;
    BOOL bNameAsc;
}


@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,retain) NSMutableArray *result;
@property (nonatomic,retain) NSArray *keys;


@property (nonatomic) NSInteger callFunction;
@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;
@property (retain, nonatomic) IBOutlet UIButton *titleButton;

@end