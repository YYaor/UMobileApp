//
//  RCCheckButton.m
//  UMobile
//
//  Created by  APPLE on 2014/11/19.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCCheckButton.h"

@implementation RCCheckButton

@synthesize choose = _choose;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.contentMode  =  UIViewContentModeScaleAspectFit;
        self.userInteractionEnabled = YES;
        [self setChoose:NO];
        UITapGestureRecognizer *recognizer =  [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)] autorelease];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

-(void)tap:(id)info{
    [self setChoose:!_choose];
    if (tar) {
        [tar performSelector:act withObject:self];
    }
}

-(void)addTarget:(id)target action:(SEL)action{
    tar = target;
    act = action;
}


-(void)setChoose:(BOOL)choose{
    _choose = choose;
    
    if (_choose)
        [self setImage:[UIImage imageNamed:@"goods_cb_checked"] ];
    else
        [self setImage:[UIImage imageNamed:@"goods_cb_default"] ];
         
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
