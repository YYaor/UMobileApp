//
//  ShangPinXZViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/11/13.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "ShangPinDtlViewController.h"
#import "LeftView.h"
#import "XinZenShangPingViewController.h"
#import "ScanViewController.h"
#import "RCCheckButton.h"

@interface ShangPinXZViewController : RCViewController<UITableViewDelegate,UITableViewDataSource,LeftViewDelagete,UIActionSheetDelegate>{
    NSUInteger page;
    LeftView *leftView;
}

@property (retain, nonatomic) NSMutableArray *result;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) BOOL bSelect;
@property (nonatomic,assign) NSMutableArray *products;
@property (nonatomic,retain) NSMutableArray *curProducts;
@property (nonatomic,retain) NSString *searchCode;
@property (nonatomic) BOOL bMutileSelect;
@property (nonatomic,retain) NSMutableDictionary *selectDic;

@property (retain, nonatomic) NSString *companyID;
@property (retain, nonatomic) NSString *stockID;

@property (assign, nonatomic) NSMutableDictionary *allInfo;

@property (nonatomic) BOOL canShow;



@end
