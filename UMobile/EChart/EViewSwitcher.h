//
//  EViewSwitcher.h
//  EChartDemo
//
//  Created by Scott Zhu on 14-1-30.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EViewSwitcher;

@protocol EViewSwitcherDataSource <NSObject>

@required
- (NSInteger) numberOfViewsInEViewSwitcher:(EViewSwitcher *)eViewSwitcher;

- (UIView *) eSwitcher:(EViewSwitcher *)eViewSwitcher
           viewAtIndex:(NSInteger)index;


@end

@protocol EViewSwitcherDelegate <NSObject>

@optional

@end

@interface EViewSwitcher : UIView

@property (retain, nonatomic) NSArray *arrayOfViews;
@property (retain, nonatomic) UIView *topView;

@property (assign, nonatomic) id <EViewSwitcherDataSource> dataSource;
@property (assign, nonatomic) id <EViewSwitcherDelegate> delegate;


@end
