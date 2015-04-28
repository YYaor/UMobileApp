//
//  XinZenDetailViewController.h
//  UMobile
//
//  Created by 陈 景云 on 14-10-28.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "SPGLViewController.h"
#import "ShangPinXZViewController.h"
#import "ScanViewController.h"
#import "XinZenShangPingViewController.h"

#import "XinZenDingDanViewController.h"
#import "XinZenHeaderViewController.h"

@interface XinZenDetailViewController : RCViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *products;
@property (retain, nonatomic) NSMutableArray *delProducts;
@property (retain, nonatomic) IBOutlet UIView *totalView;

@property (retain, nonatomic) NSString *total;
@property (retain, nonatomic) NSString *count;
@property (retain, nonatomic) NSString *disTotal;

// add  ghd
@property (retain, nonatomic) NSString *companyID;
@property (retain, nonatomic) NSString *orderType;

@property (nonatomic) BOOL bClean;

@end
