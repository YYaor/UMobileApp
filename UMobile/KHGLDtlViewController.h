//
//  KHGLDtlViewController.h
//  UMobile
//
//  往来单位明细
//
//  Created by  APPLE on 2014/9/16.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "KHGLAddViewController.h"
#import "RCTableTitleView.h"
#import "KHGLYSViewController.h"

#import "KHGLAddViewController.h"
#import "DDGLViewController.h"
#import "XinZenDingDanViewController.h"
#import "KxMenu.h"

@interface KHGLDtlViewController : RCViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>


@property(nonatomic,retain) NSMutableArray *result;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) KxMenu *menu;

- (IBAction)addClick:(id)sender;

@end
