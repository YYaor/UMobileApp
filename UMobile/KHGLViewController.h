//
//  KHGLViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/11.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "KHGLDtlViewController.h"
#import "LeftView.h"
#import "KHGLAddViewController.h"

@interface KHGLViewController : RCViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,LeftViewDelagete,UIActionSheetDelegate>{
    LeftView *leftView;
    NSUInteger page;
    NSUInteger index;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@property (retain, nonatomic) NSMutableArray *result;

@property (nonatomic) BOOL bSelect;
@property (nonatomic,assign) NSMutableArray *customerInfo;

@end
