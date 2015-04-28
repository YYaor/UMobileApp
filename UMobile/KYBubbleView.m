//
//  KYBubbleView.m
//  driver
//
//  Created by 陈 景云 on 14-4-12.
//  Copyright (c) 2014年 rid. All rights reserved.
//

#import "KYBubbleView.h"

@implementation KYBubbleView

static const float kBorderWidth = 10.0f;
//static const float kEndCapWidth = 20.0f;
static const float kMaxLabelWidth = 230.0f;

@synthesize infoDict = _infoDict;
@synthesize index;

/*
 初始化气泡view 和气泡 view中对所有元素
 先把气泡view 中对所有元素都添加到气泡view上之后，在别的方法中再对气泡view中对元素进行排列组合
 */
//此处应该是初始化气泡弹出后对矩形框
- (id)initWithFrame:(CGRect)frame
{
    //在这个方法里  self 就是一个透明对气泡view    气泡view中所有元素的属性全部在这里进行设置
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //初始化标题lable
        
        imgViews = [[NSMutableArray alloc]init];
        titleLabel = [[UILabel alloc] init] ;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:titleLabel];       //self 应该指气泡弹出后对矩形框
        
        UIImage *img = [UIImage imageNamed:@"d_03"];
        CGRect rect = CGRectZero;
        rect.size = img.size;
        for(int i = 0;i < 5; i++){
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:rect] ;
            imgView.image = img;
            [imgViews addObject:imgView];
        }
        
    
    }
    
    //    CGRect iRect = CGRectZero;
    //    iRect.size.width = 300;
    //    iRect.size.height = 200;
    //    self.frame = iRect;
    self.scrollEnabled = YES;
    
    return self;
}

/*
 生成气泡view和气泡view中的元素
 在此方法中对气泡 view以及其中对元素进行排列组合，呈现出我们想要对效果（即自定义气泡view）
 */
//显示矩形框  -  对气泡弹出后对矩形框内对数据进行初始化
- (BOOL)showFromRect:(CGRect)rect {
    if (self.infoDict == nil) {
        return NO;
    }
    
    //显示 标题label
    titleLabel.text = [_infoDict objectForKey:@"Name"];
    titleLabel.frame = CGRectZero;   //暂时不定标题对尺寸
    [titleLabel sizeToFit];         //标题设置为自适应
    CGRect rect1 = titleLabel.frame;      //rect1为字符串对size 即(0,0,168,18)
    rect1.origin = CGPointMake(kBorderWidth, kBorderWidth);  //(x,y) = (10,10)
    if (rect1.size.width > kMaxLabelWidth) {
        rect1.size.width = kMaxLabelWidth;
    }
    titleLabel.frame = rect1;   //（10,10,168，18）
    
    for (int i = 0 ; i < 5 ; i ++){
        UIImageView *imgView = [imgViews objectAtIndex:i];
        imgView.center = CGPointMake(self.frame.size.width - 20 - (imgView.frame.size.width + 5) * i, 5);
    }

    return YES;
}

- (void)makePhoneCall {
    UIWebView *webView = (UIWebView*)[self viewWithTag:123];
    if (webView == nil) {
        webView = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
    }
    NSString *url = [NSString stringWithFormat:@"tel://%@", [_infoDict objectForKey:@"Phone"]];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
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
