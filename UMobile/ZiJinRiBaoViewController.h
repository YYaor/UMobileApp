//
//  ZiJinRiBaoViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/19.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "PCPieChart.h"
#import "PCLineChartView.h"
#import "RCColumnView.h"
#import "ZiJinRiBaoDtlViewController.h"
#import "RiBaoDtlViewController.h"

@interface ZiJinRiBaoViewController : RCViewController<UITableViewDelegate,UITableViewDataSource>



@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain,nonatomic) NSMutableArray *result;
- (IBAction)buttonClick:(id)sender;

@end
