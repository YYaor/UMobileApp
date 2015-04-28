//
//  OrderHeaderViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/10/20.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "KxMenu.h"

@interface OrderHeaderViewController : RCViewController<UITableViewDataSource,UITableViewDelegate>{
    NSInteger callFunction;
}

@property(nonatomic,retain) NSArray *info;
@property(nonatomic,retain) NSArray *result;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,retain) NSArray *keys;
@property(nonatomic,retain) NSArray *footKeys;
@property(nonatomic,assign) NSArray *keyIndex;
@property(nonatomic,retain) NSArray *types;
@property (retain, nonatomic) KxMenu *menu;
@property(nonatomic) BOOL bInDDGL;
@property(nonatomic) BOOL bClean;

@property(nonatomic,retain)NSString *strID;//订单ID

@end
