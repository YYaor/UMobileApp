//
//  SPGLViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/14.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "ShangPinDtlViewController.h"
#import "LeftView.h"
#import "XinZenShangPingViewController.h"
#import "ScanViewController.h"
#import "SDImageCache.h"

@interface SPGLViewController : RCViewController<UITableViewDelegate,UITableViewDataSource,LeftViewDelagete,UIActionSheetDelegate>{
    NSUInteger page;
    LeftView *leftView;
}

@property (retain, nonatomic) NSMutableArray *result;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) BOOL bSelect;
@property (nonatomic,assign) NSMutableArray *products;
@property (nonatomic,retain) NSString *searchCode;

@end
