//
//  CustomerListViewController.h
//  UMobile
//
//  Created by Rid on 15/1/5.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "KHGLDtlViewController.h"
#import "LeftView.h"
#import "KHGLAddViewController.h"


@interface CustomerListViewController : RCViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,LeftViewDelagete,UIActionSheetDelegate>{
    LeftView *leftView;
    NSUInteger page;
    NSUInteger index;
    NSInteger selectID;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@property (retain, nonatomic) NSMutableArray *result;

@property (nonatomic) BOOL bSelect;
@property (nonatomic,assign) NSMutableArray *customerInfo;

@property (nonatomic) NSInteger CustomerType;

@end