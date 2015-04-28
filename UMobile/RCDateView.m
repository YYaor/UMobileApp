//
//  RCDateView.m
//  UMobile
//
//  Created by  APPLE on 2014/12/4.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCDateView.h"

@implementation RCDateView

@synthesize isOk,isVisiable,strDate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)keyBoardShow:(id)info{
    if (!self.isVisiable) return;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3f];
    msgView.center = CGPointMake(MainSize.width/2, MainSize.height/3);
    [UIView commitAnimations];
    
}

-(void)keyBoardHide:(id)info{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3f];
    msgView.center = CGPointMake(MainSize.width/2, MainSize.height/2);
    [UIView commitAnimations];
}

-(id)init{
    CGSize mSize = MainSize;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self = [super initWithFrame:CGRectMake(0, 0, mSize.width, mSize.height)]) {
        self.backgroundColor =  [UIColor clearColor];
        basicView =  [[[UIView alloc]initWithFrame:self.frame] autorelease];
        basicView.backgroundColor = [UIColor grayColor];
        basicView.alpha = 0.9;
        UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewDismiss)] autorelease];
        [basicView addGestureRecognizer:recognizer];
        [self addSubview:basicView];
        
        
        msgView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)] autorelease];
        msgView.backgroundColor = [UIColor whiteColor];
        msgView.center = CGPointMake(mSize.width/2, mSize.height/2);
        msgView.layer.masksToBounds = YES;
        msgView.layer.cornerRadius = 5.0;
        [self addSubview:msgView];
        
        
        label = [[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 260, 30)] autorelease];
        label.textColor =  [UIColor colorWithRed:51.0/255 green:181.0/255 blue:229.0/255 alpha:1.0];
        //        label.textAlignment = NSTextAlignmentCenter;
        

        datePicker = [[[UIDatePicker alloc] init] autorelease];
        datePicker.center = CGPointMake(150, 150);
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        
        button1 = [UIButton buttonWithType:UIButtonTypeSystem];
        [button1 setTitle:@"取消" forState:UIControlStateNormal];
        [button1 setFrame:CGRectMake(0, 250, 150, 50)];
        button1.tag = 2;
        [button1 addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //        [self setButtonConner:button1];
        
        button2 = [UIButton buttonWithType:UIButtonTypeSystem];
        [button2 setTitle:@"确定" forState:UIControlStateNormal];
        [button2 setFrame:CGRectMake(150, 250, 150, 50)];
        button2.tag = 1;
        [button2 addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [self setButtonConner:button2];
        
        
        UIView *line1 =  [[[UIView alloc]initWithFrame:CGRectMake(0, 250, 300, 1)] autorelease];
        line1.backgroundColor =  [UIColor lightGrayColor];
        line1.alpha = 0.8;
        [msgView addSubview:line1];
        
        UIView *line2 =  [[[UIView alloc]initWithFrame:CGRectMake(150, 250, 1, 50)] autorelease];
        line2.backgroundColor =  [UIColor lightGrayColor];
        line2.alpha = 0.8;
        [msgView addSubview:line2];
        
        UIView *line3 =  [[[UIView alloc]initWithFrame:CGRectMake(20, 45, 260, 1)] autorelease];
        line3.backgroundColor =  [UIColor colorWithRed:51.0/255 green:181.0/255 blue:229.0/255 alpha:1.0];
        line3.alpha = 0.8;
        [msgView addSubview:line3];
        
        [msgView addSubview:label];
        [msgView addSubview:datePicker];
        [msgView addSubview:button1];
        [msgView addSubview:button2];
        
    }
    return self;
}

-(void)dateChange:(id)sender{
    [self computeWeekDay];
}

-(void)computeWeekDay{
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps;
    comps = [calendar components:unitFlags fromDate:datePicker.date];
    //NSInteger week = [comps week]; // 今年的第几周
    NSInteger weekday = [comps weekday];
    NSArray *arr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    label.text = [NSString stringWithFormat:@"%@ %@",[self GetDate], arr[weekday - 1]];
}

-(NSString *)GetDate{
    NSDateFormatter *format = [[[NSDateFormatter alloc]init] autorelease];
    [format setDateFormat:@"YYYY-MM-dd"];
    return [format stringFromDate:datePicker.date];
}

-(void)setButtonConner:(UIButton *)button{
    button.backgroundColor =  [UIColor colorWithRed:0.1 green:0.1 blue:0.8 alpha:1.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    button.layer.mask         = maskLayer;
}

-(void)ButtonClick:(UIButton *)sender{
    self.isOk = sender.tag == 1;
    self.strDate = [self GetDate];
//    self.num = [datePicker date];
//    [self ViewDismiss];
    
    msgView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ViewDismiss)];
    msgView.transform = CGAffineTransformMakeScale(0.8f, .8f);
    msgView.alpha = 0;
    [UIView commitAnimations];
}

-(void)viewBeShow{
   	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1f];
    msgView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}



-(void)ShowViewInObject:(id)obj withMsg:(NSString *)msg{
    UIWindow *window = nil;
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if ([delegate respondsToSelector:@selector(window)])
        window = [delegate performSelector:@selector(window)];
    else window = [[UIApplication sharedApplication] keyWindow];
    
    self.isOk = NO;
    self.isVisiable = YES;
//    [label setText:msg];
    [window addSubview:self];
    
    [self computeWeekDay];
    
    msgView.transform = CGAffineTransformMakeScale(.8f, .8f);
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(viewBeShow)];
    msgView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    
    [UIView commitAnimations];
    

}

-(void)ViewDismiss{
    self.isVisiable = NO;

    [self removeFromSuperview];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.strDate = nil;
    [super dealloc];
}

@end
