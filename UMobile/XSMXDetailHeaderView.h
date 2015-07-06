//
//  XSMXDetailHeaderView.h
//  UMobile
//
//  Created by live on 15-5-5.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XSMXDetailHearViewDelegate <NSObject>

-(void) contentOffsetXChange:(CGFloat)offsetX;

@end

@interface XSMXDetailHeaderView : UITableViewHeaderFooterView<UIScrollViewDelegate>

@property(nonatomic , assign) id<XSMXDetailHearViewDelegate> delegate;

-(void) updateHeaderWidthScrollOffsetX:(CGFloat)offsetX;
@end
