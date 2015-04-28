//
//  ShenHeDtlViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/17.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "MHTextField.h"
#import "OrderDetailController.h"
#import "OrderDetail2ViewController.h"
#import "OrderDetailNoCheckViewController.h"

@interface ShenHeDtlViewController : RCViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    NSUInteger page;
    CGFloat rowHeight;
    BOOL bNameAsc;
    BOOL bDateAsc;
}

@property (retain, nonatomic) NSMutableArray *result;
@property (retain, nonatomic) NSArray *keys;

@property (nonatomic) NSInteger callFunction;
@property (nonatomic) NSInteger style;

@property (retain, nonatomic) IBOutlet MHTextField *dateField;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) NSString *strTitle;

@property (retain, nonatomic) NSString *searchType;
@property (retain, nonatomic) IBOutlet UIButton *titleButton;


@end
