//
//  RCMutileView.h
//  UMobile
//
//  Created by  APPLE on 2014/10/17.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RCMutileView : UIView<UIScrollViewDelegate>{
    UIView *headerView;
    UIScrollView *scView;
    UIView *bottomView;
    NSUInteger count;
    BOOL bMoving;
}

@property(nonatomic,retain) NSArray *viewControllers;
@property(nonatomic,retain) NSArray *titles;
@property(nonatomic) NSUInteger selectIndex;
@property(nonatomic) BOOL bloadAll;

@end
