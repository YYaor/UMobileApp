//
//  KHGLAddViewController.h
//  UMobile
//
//  Created by 陈 景云 on 14-10-14.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "CangKuViewController.h"
#import "APRoundedButton.h"

@interface KHGLAddViewController : RCViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UITextField *curTextField;
    NSUInteger cellCount ;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableDictionary *info;
@property (retain, nonatomic) NSMutableArray *categoryInfo;
@property (retain, nonatomic) NSMutableArray *typeInfo;
@property (retain, nonatomic) NSMutableArray *priceInfo;
@property (retain, nonatomic) NSMutableArray *priceInfo2;
@property (assign, nonatomic) NSMutableArray *cusInfo;

@end
