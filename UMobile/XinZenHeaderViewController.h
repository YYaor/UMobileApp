//
//  XinZenHeaderViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/23.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "KHGLViewController.h"
#import "MHTextField.h"
#import "SPGLViewController.h"
#import "CangKuViewController.h"
#import "RCDateView.h"
#import "SaleViewController.h"
#import "DepartmentViewController.h"
#import "StockViewController.h"
#import "KHGLAddViewController.h"
#import "CustomerListViewController.h"
#import "AccountViewController.h"
#import "DHSmartScreenshot.h"

@protocol PrintDelegate <NSObject>

-(void)print;

@end
@interface XinZenHeaderViewController : RCViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    BOOL loadNo;
    NSUInteger invType;
}


@property (nonatomic,retain) NSMutableDictionary *allInfo;

@property (nonatomic,retain) NSArray *titles;
@property (nonatomic,retain) NSArray *titles_in;
@property (nonatomic,retain) NSArray *titles_out;

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign)id<PrintDelegate> delegate;
@property (nonatomic) BOOL bEdit;
@property (nonatomic) BOOL bClean;

-(void)reset;

@end
