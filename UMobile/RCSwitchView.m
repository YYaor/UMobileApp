//
//  RCSwitchView.m
//  CarMap
//
//  Created by  APPLE on 2014/7/21.
//  Copyright (c) 2014年 温鹏辉. All rights reserved.
//

#import "RCSwitchView.h"

@implementation RCSwitchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titles{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect rect = CGRectZero;
        rect.origin = CGPointMake(0, 0);
        rect.size = frame.size;
        scrollView =  [[[UIScrollView alloc] initWithFrame:rect] autorelease];
        scrollView.backgroundColor = [UIColor orangeColor];
        scrollView.showsVerticalScrollIndicator = NO;
        selectView = [[[UIView alloc]initWithFrame:CGRectZero] autorelease];
        selectView.backgroundColor = [UIColor blueColor];
        [scrollView addSubview:selectView];
        [self setTitleArray:titles];
        
        [self addSubview:scrollView];
    }
    return self;
}


-(void)setTitleArray:(NSArray *)titles{
    CGFloat offset = 5;
    int i = 1;
    for (NSString *title in titles) {
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15]];
        CGRect rect = CGRectMake(offset, 0, size.width, self.frame.size.height);
        UIButton *button = [[[UIButton alloc]initWithFrame:rect] autorelease];
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
        
        
        offset += size.width + 5;
        button.tag = i++;
        [scrollView addSubview:button];
    }
    scrollView.contentSize  = CGSizeMake(offset, 1);
}

-(void)btnPress:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(switchDidSelectAtIndex:)])
        [self.delegate switchDidSelectAtIndex:button.tag];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    selectView.frame = CGRectMake(button.frame.origin.x, self.frame.size.height - 1, button.frame.size.width, 1);
    [UIView commitAnimations];
}

-(void)dealloc{
    [super dealloc];
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
