//
//  RCChooseButton.m
//  UMobile
//
//  Created by  APPLE on 2014/11/4.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCChooseButton.h"

@implementation RCChooseButton

@synthesize choose = _choose;

-(void)awakeFromNib{
    [self setChoose:NO];
}


-(void)setChoose:(BOOL)choose{
    _choose = choose;
    if (_choose)
        [self setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    else
        [self setImage:[UIImage imageNamed:@"choose_no"] forState:UIControlStateNormal];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self setChoose:!_choose];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
 
@end
