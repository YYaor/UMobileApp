//
//  PaiHangListViewController.h
//  UMobile
//
//  Created by 陈 景云 on 14-11-9.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCTableView.h"
#import "RCTableHeadSortView.h"
#import "RiBaoDtlViewController.h"

typedef enum{
    Type_Normal,
    Type_Product_XL,
    Type_Product_XE,
    Type_Product_ML,
    Type_Customer_GX,
    Type_Customer_QK,
    Type_Customer_XZ,
    Type_Sales_CD,
    Type_Sales_QD,
    Type_Sales_HK
}PaiHang_Type;


@interface PaiHangListViewController : RCViewController<RCTableViewDelegate>


@property (retain, nonatomic) IBOutlet RCTableView *tableView;

@property(nonatomic,retain) RCTableHeadSortView *sortView;

@property(nonatomic) NSUInteger callFunction;

@property(nonatomic,retain) NSString *strTitle;

@property(nonatomic,retain) NSString *link;

@property(nonatomic) PaiHang_Type type;

@property(nonatomic) DateType dateType;
@end
