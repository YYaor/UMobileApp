//
//  DDGLViewController.h
//  UMobile
//
//  Created by 陈 景云 on 14-10-21.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "OrderDetailController.h"

@interface DDGLViewController : RCViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger page;
}
@property(nonatomic,retain) NSString *link;
@property(nonatomic,retain) NSString *param;
@property(nonatomic,retain) NSMutableArray *result;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) NSUInteger callFunction;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UIButton *titleButton;

@end
