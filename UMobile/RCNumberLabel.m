//
//  RCNumberLabel.m
//  UMobile
//
//  Created by  APPLE on 2014/12/2.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCNumberLabel.h"
#import "NSString+Format.h"

@implementation RCNumberLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setText:(NSString *)text{
    [super setText:[NSString numberFromString:text]];
}

@end
