//
//  XSMXDetailViewController.h
//  UMobile
//
//  Created by live on 15-5-5.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"

@interface XSMXDetailViewController : RCViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *dataTableView;
@property (nonatomic , retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSString *link;
@property (nonatomic,retain) NSString *parma;
@property (nonatomic,retain) NSMutableArray *paramArray;

@end
