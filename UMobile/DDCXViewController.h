//
//  DDCXViewController.h
//  UMobile
//
//  Created by 陈 景云 on 14-10-21.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "CangKuViewController.h"
#import "DDGLViewController.h"
#import "RCDateView.h"
#import "SaleViewController.h"
#import "DepartmentViewController.h"
#import "StockViewController.h"
#import "KHGLViewController.h"
#import "CustomerListViewController.h"
#import "AccountViewController.h"


@interface DDCXViewController : RCViewController<UITextFieldDelegate>{
    BOOL bShow;
    KxMenu *showMenu;
}

@property(nonatomic,retain) NSMutableArray *orderType;
@property(nonatomic,retain) NSMutableArray *salesType;
@property(nonatomic,retain) NSMutableArray *customerType;
@property(nonatomic,retain) NSMutableArray *stockType;
@property(nonatomic,retain) NSMutableArray *checkType;

@property (retain, nonatomic) IBOutlet UIButton *titleButton;

@end
