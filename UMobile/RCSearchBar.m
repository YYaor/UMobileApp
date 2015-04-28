//
//  RCSearchBar.m
//  UMobile
//
//  Created by 陈 景云 on 14-10-15.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCSearchBar.h"

@implementation RCSearchBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    for(UIView *view in [[self.subviews objectAtIndex:0] subviews]){
        if ([view isKindOfClass:[UIButton class]]){
            UIButton *b =  (UIButton *)view;
            [b setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

@end
