//
//  RCColumnView.m
//  UMobile
//
//  Created by  APPLE on 2014/9/19.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCColumnView.h"

#define leftMargin  25.0
#define topMargin  15.0
#define bottomMargin  20.0

@implementation RCColumnView


@synthesize maxValue,minValue,numOflines,interval,numYIntervals;

@synthesize values,valueColors,xLabels;

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
        self.numOflines = 8;
        self.widthOfColumn = 20;
        self.gap = 10;
        self.interval = 5;
        self.autoscaleYAxis = YES;
        self.numYIntervals = 4;
        self.maxValue = 980;
        self.minValue = -200;
        self.backgroundColor = [UIColor clearColor];
        scrollView =  [[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.userInteractionEnabled = YES;
        [self addSubview:scrollView];
    }
    return self;
}

-(UIColor *)getColor:(NSUInteger )index{
    if (index > [self.valueColors count] - 1 || self.valueColors == nil) {
        return EGreen;
    }else{
        return [self.valueColors objectAtIndex:index];
    }
}

-(void)dealloc{
    self.xLabels = nil;
    self.valueColors = nil;
    self.values = nil;
    [super dealloc];
}


-(BOOL)isInteger:(NSNumber *)value{
    return ([value integerValue] == [value floatValue]);
}

-(void)drawLabel{
    CGFloat width = 0;
    for (int i = 0 ; i < [self.xLabels count] ;  i ++){
        NSString *value = [self.xLabels objectAtIndex:i];
        CGRect rect= CGRectMake(leftMargin + (self.gap + self.widthOfColumn) * i, scrollView.frame.size.height - bottomMargin, self.widthOfColumn, bottomMargin + 10 );
        width = rect.size.width + rect.origin.x ;
        UILabel *label = [[UILabel alloc]initWithFrame:rect];
        label.font = [UIFont systemFontOfSize:9];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = value;
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        [scrollView addSubview:label];
    }
    scrollView.contentSize = CGSizeMake(width, 1);
}

-(void)columnTap:(UIGestureRecognizer *)sender{
    NSInteger tag = sender.view.tag;
    NSString *value = [self.values objectAtIndex:tag - 1];
    
    UILabel *label = (UILabel *)[scrollView viewWithTag:999];
    if (label == nil) {
        label = [[[UILabel alloc]init] autorelease];
        label.tag = 999;
        label.font = [UIFont systemFontOfSize:9];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:label];
    }

    label.text = value;
    label.frame = CGRectMake(sender.view.frame.origin.x, sender.view.frame.origin.y - 20, sender.view.frame.size.width, 20);
    
    
}

-(void)drawColumn{
    
    
    for (int i = 0 ; i < [self.values count] ;  i ++){
        CGFloat value = [[self.values objectAtIndex:i] floatValue];
        
        CGFloat left = leftMargin + (self.gap + self.widthOfColumn) * i;
        CGRect newRect,oldRect;
        CGFloat nheight = 0;

        nheight = fabsf(factor * value);

        oldRect = CGRectMake(left, yZero, self.widthOfColumn, 0);

        UIView *view = [[[UIView alloc]initWithFrame:oldRect] autorelease];
        
        UIGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(columnTap:)] autorelease];
        [view addGestureRecognizer:recognizer];
        
        view.backgroundColor = [self getColor:i];
        view.userInteractionEnabled = YES;
        view.tag = i + 1;
        [scrollView addSubview:view];
        
        if (value >= 0) {
            newRect = CGRectMake(left, yZero - nheight, self.widthOfColumn, nheight);
        }else{
            newRect = CGRectMake(left, yZero , self.widthOfColumn, nheight);
        }

        [UIView animateWithDuration:3.0 animations:^{
            view.frame = newRect;
        }];
        
    }
}


-(void)reloadInView{
    
    [[scrollView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(UIView *view in self.subviews){
        if (![view isKindOfClass:[UIScrollView class]]) [view removeFromSuperview];
    }
    [self drawView];
}

-(void)drawLines{
    
}


-(void)drawView{
    //    [self drawLabel];
    
    //    self.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
    
    scrollView.frame = CGRectMake(leftMargin, 0 , self.frame.size.width - leftMargin - 1, self.frame.size.height );
    
    CGFloat width = 0;
    for (int i = 0 ; i < [self.xLabels count] ;  i ++){
        NSString *value = [self.xLabels objectAtIndex:i];
        CGRect rect= CGRectMake(leftMargin + (self.gap + self.widthOfColumn) * i, scrollView.frame.size.height - bottomMargin  , self.widthOfColumn , bottomMargin );
        if (i == 0) NSLog(@"label frame %@",NSStringFromCGRect(rect));
        width = rect.size.width + rect.origin.x ;
        UILabel *label = [[UILabel alloc]initWithFrame:rect];
        label.font = [UIFont systemFontOfSize:8];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = value;
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        [scrollView addSubview:label];
    }
    scrollView.contentSize = CGSizeMake(width, 1);
    
    int n_div;
    int power = 0;
    float scale_min, scale_max, div_height;
//    float top_margin = topMargin;
//    float bottom_margin = bottomMargin;
//    float x_label_height = 20;
    
    //计算间距
    if (self.autoscaleYAxis) {
        scale_min = self.minValue > 0?0:self.minValue;
        
        power = floor(log10(maxValue/5));
        float increment = maxValue / (5 * pow(10,power));
        increment = (increment <= 5) ? ceil(increment) : 10;
        increment = increment * pow(10,power);
        scale_max = 5 * increment;
        //
        //
        if (scale_min < 0) {
            power = floor(log10(fabsf(minValue)/5));
            increment = fabsf(minValue) / (5 * pow(10,power));
            increment = (increment <= 5) ? ceil(increment) : 10;
            increment = increment * pow(10,power);
            scale_min = -5 * increment;
        }
        if (scale_max == 0 || fabs(scale_max) < fabs(scale_min)) {
            self.interval = -scale_min / 5;
            
            for (int i = 1 ; i < 99 ; i ++){
                if (self.interval * i > fabs(scale_max)) {
                    scale_max = self.interval * i ;
                    break;
                }
            }
        }else{
            self.interval = scale_max / 5 ;// numYIntervals;
            
            for (int i = 1 ; i < 99 ; i ++){
                if (self.interval * i > fabs(scale_min)) {
                    scale_min = - self.interval * i ;
                    break;
                }
            }
        }
    } else {
        scale_min = minValue;
        scale_max = maxValue;
    }

    n_div = ceil((scale_max-scale_min)/self.interval + 1) ;
    div_height = (scrollView.frame.size.height-topMargin-bottomMargin)/(n_div-1);
    factor = self.interval == 0?1:div_height / self.interval;
    for (int i=0; i<n_div; i++)
    {
        float y_axis = scale_max - i*self.interval;
        
        
        float y = topMargin + div_height*i;
        NSLog(@"y %f %f",y_axis,y);
        
        if (y_axis == 0) yZero = y;
        if (i == 0 )    self.maxValue = y_axis;
        if (i == n_div - 1) self.minValue = y_axis;
        //左边 标题
        CGRect textFrame = CGRectMake(0,y-8 ,leftMargin,20);
        NSString *formatString = [NSString stringWithFormat:@"%%.%if", (power < 0) ? -power : 0];
        NSString *text = [NSString stringWithFormat:formatString, y_axis];
        
        UILabel *label = [[[UILabel alloc]initWithFrame:textFrame] autorelease];
        label.font = [UIFont systemFontOfSize:8];
        label.textAlignment = NSTextAlignmentRight;
        label.text = text;
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode = NSLineBreakByCharWrapping;
        [label sizeToFit];
        [self addSubview:label];
        
        //线
        // These are "grid" lines
        UIView *line = [[[UIView alloc]initWithFrame:CGRectMake(leftMargin, y  , self.frame.size.width - leftMargin, 1)] autorelease];
        line.backgroundColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:0.1f];
        [self addSubview:line];
        
    }
    
    
    [self drawColumn];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    
}


@end
