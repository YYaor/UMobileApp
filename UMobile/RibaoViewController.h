//
//  RibaoViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/4.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "LRFXViewController.h"
#import "RCTableView.h"
#import "RiBaoDtlTagViewController.h"
#import "ChartViewController.h"

@interface RibaoViewController : RCViewController<UITableViewDataSource,UITableViewDelegate,RCTableViewDelegate>{
    NSInteger page;
    BOOL bload;
    BOOL bdata;
    BOOL bExcahnge;

}

@property (retain, nonatomic) IBOutlet UIView *subVcView;
@property (retain, nonatomic) IBOutlet UITableView *leftTable;
@property(nonatomic,retain) NSMutableArray *viewControllers;
@property (retain, nonatomic) NSArray *leftTableArr;
@property (nonatomic) NSInteger selectIndex;
@property (nonatomic,retain) NSString *param;

@property (retain, nonatomic) IBOutlet RCTableView *tableView;
@property (nonatomic) NSInteger callFunction;
@property (nonatomic,retain) NSMutableArray *result;

@property (nonatomic,retain) NSString *searchText;

@end
