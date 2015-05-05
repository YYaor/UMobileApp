//
//  SaleViewController.h
//  UMobile
//
//  Created by Rid on 14/12/30.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "LeftView.h"

@protocol saleViewControllerDelegate <NSObject>

-(void) salesmanSelectedWithSalesId:(NSInteger) salesId salesName:(NSString *)salesName;

@end

@interface SaleViewController : RCViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,LeftViewDelagete>{
    NSInteger page;
    LeftView *leftView;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, retain) NSMutableArray *info; //hgg 20150312 retain后调用removeAllObject后才不会出现内存崩溃，后面同
@property (nonatomic, retain) NSMutableArray *departMentInfo;

@property (nonatomic, retain) NSMutableArray *result;
@property (nonatomic, retain) NSString *selectId;

@property (nonatomic) NSUInteger CustomerType;

@property(nonatomic , assign) id<saleViewControllerDelegate> delegate;

@end
