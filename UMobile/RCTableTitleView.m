//
//  RCTableTitleView.m
//  UMobile
//
//  Created by  APPLE on 2014/9/16.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCTableTitleView.h"

@implementation RCTableTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setBackgroundImage:(NSString *)imageName{
    if (imageName){
        UIImage *image = [UIImage imageNamed:imageName];
        self.backgroundColor =  [UIColor colorWithPatternImage:image];
    }else{
        self.backgroundColor =  [UIColor clearColor];
    }
}

-(void)setIcon:(NSString *)imageName withText:(NSString *)str{
    
    CGFloat offset = 3;
    CGFloat height = self.frame.size.height - 6 ;
    if(imageName){
        UIImageView *imageView = [[[UIImageView alloc]initWithFrame:CGRectMake(offset, offset, height, height)] autorelease];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:imageName];
        
        [self addSubview:imageView];
    }
    UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height, offset, 100, height)] autorelease];
    label.backgroundColor =  [UIColor clearColor];
    label.font =  [UIFont systemFontOfSize:12];
    label.text = str ;
    
    [self addSubview:label];
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
