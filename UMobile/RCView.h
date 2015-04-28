//
//  RCView.h
//  PILOT
//
//  Created by  on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface RCView : UIView

@property(nonatomic) NSUInteger style;

-(void)setbackImage:(NSString *)imgName;

@end
