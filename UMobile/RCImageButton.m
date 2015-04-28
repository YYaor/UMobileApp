//
//  RCImageButton.m
//  UMobile
//
//  Created by  APPLE on 2014/9/10.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCImageButton.h"

#define offset 5

@implementation RCImageButton



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor =  [UIColor clearColor];
        
        CGFloat width = self.frame.size.width - offset - offset;
        button =  [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(offset, offset , width, width);
        
        titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, width + offset, self.frame.size.width , self.frame.size.height - width - offset)] autorelease];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor =  [UIColor clearColor];
        titleLabel.font =  [UIFont systemFontOfSize:10];
        
        numLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, 25)] autorelease];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.backgroundColor = [UIColor orangeColor];
        numLabel.font = [UIFont systemFontOfSize:10];
        numLabel.textColor =  [UIColor whiteColor];
        numLabel.center = CGPointMake(offset + width - 10, offset + 10);
        
        CGMutablePathRef ref = CGPathCreateMutable();
        CGPathAddEllipseInRect(ref, NULL, CGRectMake(0.0, 0.0, 25, 25));
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setPath:ref];
        numLabel.layer.mask = shapeLayer;
        CGPathRelease(ref);
//        [self setNeedsDisplay];
        
        [self addSubview:button];
        [self addSubview:titleLabel];
        [self addSubview:numLabel];
        
    }
    return self;
}

-(void)setButtonTag:(NSUInteger)tag{
    button.tag = tag;
}

-(void)setImgName:(NSString *)imgName{
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}


-(void)setName:(NSString *)name{
    [titleLabel setText:name];
}


-(void)setNum:(NSString *)num{
    if ([num integerValue] == 0){
        numLabel.hidden = YES;
    }else{
        numLabel.hidden = NO;
        [numLabel setText:num];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc{
    [super dealloc];
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [button addTarget:target action:action forControlEvents:controlEvents];
}

@end
