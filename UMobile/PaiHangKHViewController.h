//
//  PaiHangKHViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/16.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCTableTitleView.h"
#import "PaiHangListViewController.h"

@interface PaiHangKHViewController : RCViewController<UITableViewDataSource,UITableViewDelegate>{
    BOOL bload;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) RCTableTitleView *titleView1;
@property (retain, nonatomic) RCTableTitleView *titleView2;

@property (retain, nonatomic) NSMutableArray *result;
@property (retain, nonatomic) NSMutableArray *result2;

@end
