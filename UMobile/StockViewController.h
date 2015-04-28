//
//  StockViewController.h
//  UMobile
//
//  Created by Rid on 14/12/30.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "LeftView.h"

@interface StockViewController : RCViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,LeftViewDelagete>{
    NSInteger page;
    LeftView *leftView;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, assign) NSMutableArray *info;

@property (nonatomic, retain) NSMutableArray *result;
@property (nonatomic, retain) NSString *selectId;

@end
