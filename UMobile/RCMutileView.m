//
//  RCMutileView.m
//  UMobile
//
//  Created by  APPLE on 2014/10/17.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCMutileView.h"

#define hHeight 40

@implementation RCMutileView

@synthesize viewControllers = _viewControllers;
@synthesize titles = _titles;
@synthesize selectIndex = _selectIndex;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        //
        self.backgroundColor = [UIColor clearColor];
        _selectIndex = 0;
        count = 0;
        bottomView = [[[UIView alloc]init] autorelease];
        bottomView.backgroundColor = [UIColor clearColor];
        headerView = [[[UIView alloc]init] autorelease];
        headerView.backgroundColor  = [UIColor clearColor];
        scView = [[[UIScrollView alloc]init] autorelease];
        scView.pagingEnabled = YES;
        scView.delegate = self;
        scView.backgroundColor = [UIColor clearColor];
        [self addSubview:headerView];
        [headerView addSubview:bottomView];
        bottomView.backgroundColor =  [UIColor blueColor];
        [self addSubview:scView];
    }
    return self;
}

-(void)layoutSubviews{
    if (count == 0)return;
    CGSize size = self.frame.size ;
    CGFloat width = size.width / count ;
    headerView.frame = CGRectMake(0, 0, size.width, hHeight);
    scView.frame = CGRectMake(0, hHeight, size.width, size.height - hHeight);
    bottomView.frame = CGRectMake(width * _selectIndex , hHeight - 1 , width, 1);
    for (int i  = 1 ; i < count + 1 ; i ++){
        UIButton *button = (UIButton *)[headerView viewWithTag:i];
        button.frame = CGRectMake(width * (i- 1), 0, width, hHeight - 1);
        button.backgroundColor =  [UIColor clearColor];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:[self getTitle:i - 1] forState:UIControlStateNormal];
        
        
        UIViewController *vc = [self.viewControllers objectAtIndex:i - 1];
        CGRect rect = CGRectMake(scView.frame.size.width * (i - 1) , 0, scView.frame.size.width, scView.frame.size.height);
        vc.view.frame = rect;
        if (_selectIndex == i - 1) {
            [scView scrollRectToVisible:rect animated:NO];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        [scView addSubview:vc.view];
    }
    scView.contentSize = CGSizeMake(scView.frame.size.width * count, 1);
    NSOperationQueue *queue = [[[NSOperationQueue alloc]init] autorelease];
    [queue setMaxConcurrentOperationCount:1];
    if (self.bloadAll) {
        NSLog(@"load all");
        for(UIViewController *vc in self.viewControllers){
            NSInvocationOperation *op = [[[NSInvocationOperation alloc] initWithTarget:vc selector:@selector(loadData) object:nil] autorelease];
            [queue addOperation:op];
        }
        
//        [self.viewControllers makeObjectsPerformSelector:@selector(loadData)];
    }else{
        NSLog(@"load sub");
        UIViewController *vc =  [self.viewControllers objectAtIndex:_selectIndex];
        if ([vc respondsToSelector:@selector(loadData)])
            [vc performSelector:@selector(loadData) withObject:nil];
    }
}

-(void)setTitles:(NSArray *)titles{
    if(_titles) [_titles release];
    _titles = [titles  retain];
    
    for (int i  = 1 ; i < count + 1 ; i ++){
        UIButton *button = (UIButton *)[headerView viewWithTag:i];
        if(!button){
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:button];
        }
        [button setTitle:[self getTitle:i - 1] forState:UIControlStateNormal];
    }
}

-(NSString *)getTitle:(NSUInteger )index{
    if ([_titles count] > 0)
        return [_titles objectAtIndex:index];
    else
        return @"";
}


-(void)setViewControllers:(NSArray *)viewControllers{
    if (_viewControllers) [_viewControllers release];
    _viewControllers = [viewControllers retain];
    count =  [_viewControllers count];
    [scView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i  = 1 ; i < count + 1 ; i ++){
        UIButton *button = (UIButton *)[headerView viewWithTag:i];
        if(!button){
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag =  i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:button];
        }
        [button setTitle:[self getTitle:i - 1] forState:UIControlStateNormal];
    }
    
}

-(void)buttonClick:(UIButton *)button{
    
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [UIView beginAnimations:NULL context:nil];
    [UIView setAnimationDuration:0.3];
    
    bottomView.frame = CGRectMake(button.frame.origin.x, bottomView.frame.origin.y, button.frame.size.width, bottomView.frame.size.height);
    [UIView commitAnimations];
    
    UIButton *bt = (UIButton *)[headerView viewWithTag:_selectIndex+1];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    CGRect rect = CGRectZero;
    rect.size = scView.frame.size;
    rect.origin = CGPointMake((button.tag - 1) * rect.size.width , 0);
    [scView scrollRectToVisible:rect animated:YES];
    _selectIndex = button.tag - 1;
    UIViewController *vc =  [self.viewControllers objectAtIndex:button.tag - 1];
    if ([vc respondsToSelector:@selector(loadData)])
        [vc performSelector:@selector(loadData) withObject:nil];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (bMoving) return;
    UIButton *bt = (UIButton *)[headerView viewWithTag:_selectIndex+1];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    int  cc =  lroundf(scView.contentOffset.x / scView.frame.size.width) + 1;
    UIButton *button = (UIButton *)[headerView viewWithTag:cc];
    [UIView beginAnimations:NULL context:nil];
    [UIView setAnimationDuration:0.3];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _selectIndex = cc - 1;
    bottomView.frame = CGRectMake(button.frame.origin.x, bottomView.frame.origin.y, button.frame.size.width, bottomView.frame.size.height);
    [UIView commitAnimations];
    
    UIViewController *vc =  [self.viewControllers objectAtIndex:button.tag - 1];
    if ([vc respondsToSelector:@selector(loadData)])
        [vc performSelector:@selector(loadData) withObject:nil];
}



-(void)dealloc{
    self.titles = nil;
    self.viewControllers = nil;
    [super dealloc];
}


@end
