//
//  XSMXDetailTableViewCell.h
//  UMobile
//
//  Created by live on 15-5-5.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XSMXDetailCellModel.h"

@protocol XSMXDetailTableViewCellDelegate <NSObject>

-(void) contentOffsetXChange:(CGFloat)offsetX;

@end

@interface XSMXDetailTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property(nonatomic , assign) id<XSMXDetailTableViewCellDelegate> delegate;

-(void)updateCellWithData:(XSMXDetailCellModel *)model contentOffset:(CGFloat) offsetX;
-(void) updateScrollOffsetX:(CGFloat) offsetX;
@end
