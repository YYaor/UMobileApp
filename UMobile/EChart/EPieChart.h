//
//  EPieChart.h
//  EChartDemo
//
//  Created by Efergy China on 24/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EPie;
@class EPieChartDataModel;
@class EPieChart;

@protocol EPieChartDataSource <NSObject>

@optional
/** You can customize the front view by implimenting
    this dataSoure, If it's not implimented, it will use
    default view*/
- (UIView *) frontViewForEPieChart:(EPieChart *) ePieChart;

/** You can customize the back view by implimenting
 this dataSoure, If it's not implimented, it will use
 default view*/
- (UIView *) backViewForEPieChart:(EPieChart *) ePieChart;

@end

@protocol EPieChartDelegate <NSObject>

@optional
- (void)                ePieChart:(EPieChart *)ePieChart
  didTurnToFrontViewWithFrontView:(UIView *)frontView;

- (void)                ePieChart:(EPieChart *)ePieChart
    didTurnToBackViewWithBackView:(UIView *)backView;

@end


@interface EPieChart : UIView

@property (retain, nonatomic) EPie *frontPie;

@property (retain, nonatomic) EPie *backPie;

@property (retain, nonatomic) EPieChartDataModel *ePieChartDataModel;

@property (nonatomic) BOOL isUpsideDown;

@property (assign, nonatomic) id <EPieChartDelegate> delegate;

@property (assign ,nonatomic) id <EPieChartDataSource> dataSource;

- (id)initWithFrame:(CGRect)frame
 ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel;

- (void) turnPie;

@end

@interface EPie : UIView

@property (retain, nonatomic) UIView *contentView;

@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat radius;

@property (assign, nonatomic) UIColor *budgetColor;
@property (assign, nonatomic) UIColor *currentColor;
@property (assign, nonatomic) UIColor *estimateColor;


@property (retain, nonatomic) EPieChartDataModel *ePieChartDataModel;

- (void) reloadContent;

- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius;

- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
  ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel;
@end


@interface EPieChartDataModel : NSObject
@property (nonatomic) CGFloat budget;
@property (nonatomic) CGFloat current;
@property (nonatomic) CGFloat estimate;

- (id)initWithBudget:(CGFloat) budget
             current:(CGFloat) current
            estimate:(CGFloat) estimate;
@end