//
//  BaoBiaoViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/19.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RiBaoDtlViewController.h"
#import "ZiJinRiBaoDtlViewController.h"

@interface BaoBiaoViewController : RCViewController<UITableViewDataSource,UITableViewDelegate>{
    BOOL bload;
}


@property (retain, nonatomic) IBOutlet UIView *subVcView;
@property(nonatomic,retain) NSMutableArray *viewControllers;
@property(nonatomic,retain) NSArray *leftArray;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic) NSInteger callBackType;

@end
