//
//  RCCheckButton.h
//  UMobile
//
//  Created by  APPLE on 2014/11/19.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCCheckButton : UIImageView{
    id tar;
    SEL act;
}

@property(nonatomic) BOOL choose;
-(void)addTarget:(id)target action:(SEL)action;

@end
