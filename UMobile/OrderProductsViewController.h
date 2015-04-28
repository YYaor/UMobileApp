//
//  OrderProductsViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/10/20.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"

@interface OrderProductsViewController : RCViewController<UITableViewDataSource,UITableViewDelegate>{
    BOOL hStock ;
    BOOL hUsable ;
}

@property(nonatomic,retain) NSArray *info;
@property(nonatomic,retain) NSArray *result;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,assign) NSArray *keyIndex;
@property(nonatomic,retain) NSArray *types;

@end
