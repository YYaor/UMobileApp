//
//  KCCXViewController.h
//  UMobile
//
//  Created by mocha on 15/5/6.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "ShangPinDtlViewController.h"
#import "LeftView.h"
#import "XinZenShangPingViewController.h"
#import "ScanViewController.h"
#import "SDImageCache.h"

@interface KCCXViewController : RCViewController<UITableViewDelegate,UITableViewDataSource,LeftViewDelagete,UIActionSheetDelegate>{
    NSUInteger page;
    LeftView *leftView;
}

@property (retain, nonatomic) NSMutableArray *result;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,retain) NSString *cangkuName;
@property (nonatomic,retain) NSString *shangpinName;

@property (nonatomic) BOOL bSelect;
@property (nonatomic,assign) NSMutableArray *products;
@property (nonatomic,retain) NSString *searchCode;

@end
