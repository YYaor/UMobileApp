//
//  RCTableView.h
//  UMobile
//
//  Created by  APPLE on 2014/9/17.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDictionary_IngoreNull.h"
#import "MJRefresh.h"
#import "NSArray+IngoreIndex.h"


@protocol RCTableViewDelegate <NSObject>
@optional
-(void)tableViewClickAtIndex:(NSUInteger)index withObject:(id)obj;
-(void)tableHeaderRefreshing;
-(void)tableFooterRefreshing;
-(void)leftTableClickAtIndex:(NSUInteger)index withObject:(id)obj;
@end


@protocol RCTableViewDataSource <NSObject>


@end

@interface RCTableView : UIView<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UITableView *leftTableView;//左边列
    UITableView *contentTableView;//内容列
    UIScrollView *contentSC;
    BOOL bInit;
    NSInteger rowIndex ;
    CGFloat leftWidth;
}


@property(nonatomic,retain) UIColor *headerColor;
@property(nonatomic,retain) UIColor *leftTitleColor;
@property(nonatomic) NSUInteger fixColumn;//左边固定列
@property(nonatomic) CGFloat rowHeight;//行高

@property(nonatomic,retain) UIScrollView *titleSC;
@property(nonatomic,retain) UIView *leftTitleView;//左边列
@property(nonatomic,retain) UIView *contentTitleView;

@property(nonatomic,retain) NSArray *titles;//标题
@property(nonatomic,retain) NSArray *titleWidths;//列宽
@property(nonatomic,retain) NSArray *keys;// 显示内容对应的Key
@property(nonatomic,retain) NSArray *result;//内容，跟Keys 取
@property(nonatomic,retain) NSMutableArray *totalColumns;//用于储存列数值和
@property(nonatomic,retain) NSArray *countColumns;//需要计算的列，对应值为1 时计算

@property(nonatomic) BOOL bCountTotal;//为Yes时 添加总数行

@property(nonatomic) BOOL leftIsOrder;//为Yes时，最左一列显示行标
@property(nonatomic) NSTextAlignment alignment;

@property(nonatomic,assign) id<RCTableViewDataSource>rDataSource;
@property(nonatomic,assign) id<RCTableViewDelegate>rDelegate;

@property(nonatomic) BOOL bHeaderRefreshing;
@property(nonatomic) BOOL bFooterRefreshing;
@property(nonatomic) BOOL bInit;

-(void)initContent;
-(UITableView *)GetTableView;
-(void)setHeaderRefresh;
-(void)setFooterRefresh;
-(void)headerEndRefreshing;
-(void)footerEndRefreshing;


@end
