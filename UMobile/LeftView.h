//
//  LeftView.h
//  UMobile
//
//  Created by  APPLE on 2014/10/14.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh/MJRefresh.h"
#import "ASIHTTPRequest.h"


@interface UIView (Moving)

-(void)moveToRight:(NSNumber *)num;
-(void)moveToLeft:(NSNumber *)num;

@end


@protocol LeftViewDelagete <NSObject>

@optional
-(void)leftViewClickAtIndex:(NSInteger)index;
-(void)leftViewClickWithInfo:(NSArray *)info;

@end

@interface LeftView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tbView;
}

@property(nonatomic,assign) id<LeftViewDelagete> delegate;
@property(nonatomic,assign) UIView *mainView;
@property(nonatomic,retain) NSArray *dataSource;
@property(nonatomic) NSInteger selectIndex;

@property(nonatomic,retain) NSString *link;
@property(nonatomic,retain) UITableView *tbView;
@property(nonatomic,retain) NSString *selectID;

@property(nonatomic) CGFloat width;

-(void)layoutLeftView;


@end
