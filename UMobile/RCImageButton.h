//
//  RCImageButton.h
//  UMobile
//
//  Created by  APPLE on 2014/9/10.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"

@interface RCImageButton : UIView{
    UILabel *numLabel ;
    UIButton *button;
    UILabel *titleLabel ;
}


-(void)setNum:(NSString *)num;
-(void)setImgName:(NSString *)imgName;
-(void)setName:(NSString *)name;
-(void)setButtonTag:(NSUInteger)tag;

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
