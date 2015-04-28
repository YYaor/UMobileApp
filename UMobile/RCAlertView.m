//
//  RCAlertView.m
//  WebRest
//
//  Created by  APPLE on 2013/12/16.
//  Copyright (c) 2013年  APPLE. All rights reserved.
//

#import "RCAlertView.h"

@implementation RCAlertView

@synthesize isOk,isVisiable,num,viewOrientation;

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
    msgView.center = CGPointMake(viewSize.width/2, viewSize.height/3.5);
    [UIView commitAnimations];
    
}

-(void)keyBoardHide:(id)info{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3f];
    msgView.center = CGPointMake(viewSize.width/2, viewSize.height/2);
    [UIView commitAnimations];
}

-(instancetype)initwithOrientation:(ViewOrientation)orientation{
    viewOrientation = orientation;
    if (self = [self init]) {
        
    }
    return self;
}

-(id)init{
    CGSize mSize = CGSizeZero;
    if (viewOrientation == ViewOrientation_vertical) {
        mSize = MainSize;
    }else{
        if (MainSize.width > MainSize.height)
            mSize = MainSize;
        else
            mSize = CGSizeMake(MainSize.height, MainSize.width);
    }
    
    viewSize = mSize;
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self = [super initWithFrame:CGRectMake(0, 0, mSize.width, mSize.height)]) {
        self.backgroundColor =  [UIColor clearColor];
        basicView =  [[[UIView alloc]initWithFrame:self.frame] autorelease];
        basicView.backgroundColor = [UIColor grayColor];
        basicView.alpha = 0.9;
        UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textViewResign)] autorelease];
        [basicView addGestureRecognizer:recognizer];
        [self addSubview:basicView];
        
        
        msgView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 150)] autorelease];
        msgView.backgroundColor = [UIColor whiteColor];
        msgView.center = CGPointMake(mSize.width/2, mSize.height/2.5);
        msgView.layer.masksToBounds = YES;
        msgView.layer.cornerRadius = 5.0;
        [self addSubview:msgView];
        
        
        label = [[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 260, 30)] autorelease];
        label.textColor =  [UIColor colorWithRed:51.0/255 green:181.0/255 blue:229.0/255 alpha:1.0];
//        label.textAlignment = NSTextAlignmentCenter;
        
        textView =  [[[UITextField alloc]initWithFrame:CGRectMake(20, 50, 260, 30)] autorelease];
        textView.placeholder = @"请输入手机号码";
        textView.borderStyle = UITextBorderStyleNone;
        textView.keyboardType = UIKeyboardTypeDefault;
        
        
        button1 = [UIButton buttonWithType:UIButtonTypeSystem];
        [button1 setTitle:@"取消" forState:UIControlStateNormal];
        [button1 setFrame:CGRectMake(0, 100, 150, 50)];
        button1.tag = 2;
        [button1 addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
//        [self setButtonConner:button1];
        
        button2 = [UIButton buttonWithType:UIButtonTypeSystem];
        [button2 setTitle:@"确定" forState:UIControlStateNormal];
        [button2 setFrame:CGRectMake(150, 100, 150, 50)];
        button2.tag = 1;
        [button2 addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self setButtonConner:button2];
        
        
        UIView *line1 =  [[[UIView alloc]initWithFrame:CGRectMake(0, 100, 300, 1)] autorelease];
        line1.backgroundColor =  [UIColor lightGrayColor];
        line1.alpha = 0.8;
        [msgView addSubview:line1];
        
        UIView *line2 =  [[[UIView alloc]initWithFrame:CGRectMake(150, 100, 1, 50)] autorelease];
        line2.backgroundColor =  [UIColor lightGrayColor];
        line2.alpha = 0.8;
        [msgView addSubview:line2];
        
        UIView *line3 =  [[[UIView alloc]initWithFrame:CGRectMake(20, 80, 260, 1)] autorelease];
        line3.backgroundColor =  [UIColor colorWithRed:51.0/255 green:181.0/255 blue:229.0/255 alpha:1.0];
        line3.alpha = 0.8;
        [msgView addSubview:line3];
        
        [msgView addSubview:label];
        [msgView addSubview:textView];
        [msgView addSubview:button1];
        [msgView addSubview:button2];
        
    }
    return self;
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
    self.num = textView.text;
    [self ViewDismiss];
}

-(void)viewBeShow{
   	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1f];
	msgView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

-(void)textViewResign{
    [textView resignFirstResponder];
}

-(void)ShowViewInObject:(id)obj withMsg:(NSString *)msg PhoneNum:(NSString *)phoneNum{
    self.isOk = NO;
    self.isVisiable = YES;
    [label setText:msg];
    [textView setText:phoneNum];
    [textView setPlaceholder:msg];
    
    
//    UIWindow *window = nil;
//    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
//    //---------------------------------------------------------------------------------------------------------------------------------------------
//    if ([delegate respondsToSelector:@selector(window)])
//        window = [delegate performSelector:@selector(window)];
//    else window = [[UIApplication sharedApplication] keyWindow];
    
    [obj addSubview:self];
    
    msgView.transform = CGAffineTransformMakeScale(.8f, .8f);
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(viewBeShow)];
    msgView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    
    [UIView commitAnimations];
    
//    [textView becomeFirstResponder];
}

-(void)ViewDismiss{
    self.isVisiable = NO;
    [textView resignFirstResponder];
    [self removeFromSuperview];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.num = nil;
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
