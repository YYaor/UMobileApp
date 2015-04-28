//
//  RCColumnView.h
//  UMobile
//
//  Created by  APPLE on 2014/9/19.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EGrey         [UIColor colorWithRed:113.0/255.0 green:112.0/255.0 blue:115.0/255.0 alpha:1.0f]
#define ELightBlue    [UIColor colorWithRed:94.0/255.0 green:147.0/255.0 blue:196.0/255.0 alpha:1.0f]
#define EGreen        [UIColor colorWithRed:138.0/255.0 green:192.0/255.0 blue:66.0/255.0 alpha:1.0f]
#define EDeepGrey     [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0f]
#define ELightGrey    [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0f]
#define EBlack        [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0f]

#define EMaxValueColor   [UIColor colorWithRed:241.0/255.0 green:93.0/255.0 blue:31.0/255.0 alpha:1.0]
#define EMinValueColor   [UIColor colorWithRed:142.0/255.0 green:196.0/255.0 blue:45.0/255.0 alpha:1.0]
#define EBlueGreenColor  [UIColor colorWithRed:255.0/255.0 green:209.0/255.0 blue:41.0/255.0 alpha:0.5]


#define EYellow [UIColor colorWithRed:255.0/255.0 green:227.0/255.0 blue:61.0/255.0 alpha:1]
#define EBlue [UIColor colorWithRed:100.0/255.0 green:236.0/255.0 blue:241.0/255.0 alpha:1]

@interface RCColumnView : UIView{
    CGFloat yZero;
    UIScrollView *scrollView;
    CGFloat factor;//比例
}


@property(nonatomic) CGFloat maxValue;
@property(nonatomic) CGFloat minValue;
@property(nonatomic) NSUInteger numOflines;
@property(nonatomic) CGFloat widthOfColumn;
@property(nonatomic) CGFloat interval;
@property(nonatomic) CGFloat gap;
@property(nonatomic) BOOL autoscaleYAxis;
@property(nonatomic) NSUInteger numYIntervals;

@property(nonatomic,retain) NSArray *values;
@property(nonatomic,retain) NSArray *xLabels;
@property(nonatomic,retain) NSArray *valueColors;


-(void)drawColumn;
-(void)reloadInView;

@end
