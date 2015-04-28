//
//  RCSwitchView.h
//  CarMap
//
//  Created by  APPLE on 2014/7/21.
//  Copyright (c) 2014年 温鹏辉. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RCSwitchViewDelegate <NSObject>
-(void)switchDidSelectAtIndex:(NSUInteger)index;
@end


@interface RCSwitchView : UIView{
    UIScrollView *scrollView;
    UIView *selectView;
}
@property(nonatomic,assign) id <RCSwitchViewDelegate>delegate;
-(id)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titles;

@end
