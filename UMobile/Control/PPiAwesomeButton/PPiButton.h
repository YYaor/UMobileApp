//
//  PPiButton.h
//  UMobile
//
//  Created by Rid on 15/1/28.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
typedef enum {
    IconPositionRight,
    IconPositionLeft,
} IconPosition;

@class PPiButton;

@interface PPiButton : UIButton




+(PPiButton*)buttonWithType:(UIButtonType)type text:(NSString*)text icon:(NSString*)icon textAttributes:(NSDictionary*)attributes andIconPosition:(IconPosition)position;
-(id)initWithFrame:(CGRect)frame text:(NSString*)text icon:(NSString*)icon textAttributes:(NSDictionary*)attributes andIconPosition:(IconPosition)position;
-(id)initWithFrame:(CGRect)frame text:(NSString*)text iconString:(NSString*)iconString textAttributes:(NSDictionary*)attributes andIconPosition:(IconPosition)position;
+(PPiButton*)buttonWithType:(UIButtonType)type text:(NSString*)text iconString:(NSString*)iconString textAttributes:(NSDictionary*)attributes andIconPosition:(IconPosition)position;

-(id)initWithFrame:(CGRect)frame text:(NSString*)text textAttributes:(NSDictionary*)attributes;

-(void)setTextAttributes:(NSDictionary*)attributes forUIControlState:(UIControlState)state;
-(void)setBackgroundColor:(UIColor*)color forUIControlState:(UIControlState)state;
-(void)setIconPosition:(IconPosition)position;
-(void)setButtonText:(NSString*)text;
-(void)setButtonIcon:(NSString*)icon;
-(void)setButtonIconString:(NSString *)icon;
-(void)setRadius:(CGFloat)radius;
-(void)setSeparation:(NSUInteger)separation;
-(void)setIsAwesome:(BOOL)isAwesome;

@end
