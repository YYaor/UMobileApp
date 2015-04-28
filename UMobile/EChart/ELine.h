//
//  ELine.h
//  EChartDemo
//
//  Created by Efergy China on 15/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELineChartDataModel.h"

@class ELine;
@class ELineChart;

@protocol ELineDataSource <NSObject>

@required

- (NSInteger) numberOfPointsInELine:(ELine *)eLine;

- (ELineChartDataModel *) highestValueInELine:(ELine *)eLine;

- (ELineChartDataModel *) eLine:(ELine *) eLine
                  valueForIndex:(NSInteger) index;

@end

@interface ELine : UIView

@property (retain, nonatomic) CAShapeLayer *shapeLayer;

@property (retain, nonatomic) UIView *dot;

@property (nonatomic) NSInteger lineWidth;

@property (retain, nonatomic) UIColor *lineColor;

@property (assign, nonatomic) id <ELineDataSource> dataSource;

- (id)initWithFrame:(CGRect)frame
          lineColor:(UIColor *)color
          lineWidth:(NSInteger)lineWidth;

- (void) putDotAt:(NSInteger) index;

- (void) reloadDataWithAnimation: (BOOL) shouldAnimation;

@end
