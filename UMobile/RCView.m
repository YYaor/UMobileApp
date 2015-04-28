//
//  RCView.m
//  PILOT
//
//  Created by  on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCView.h"

@implementation RCView

@synthesize style;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //
        
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
        
        
//        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(1, 1);
//        self.layer.shadowOpacity = 1.0;
//        self.layer.shadowRadius = 1.0;
        
//        self.userInteractionEnabled = NO;
    }
    
    return self;
}

-(void)awakeFromNib{
    self.backgroundColor = style == 3?[UIColor clearColor]:[UIColor whiteColor];
}

-(void)setbackImage:(NSString *)imgName{
    self.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:imgName]];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (style == 1) [[self GetSuperView:self] endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(UIView *)GetSuperView:(UIView *)curView{
    UIView *supView = [curView superview];
    if ([NSStringFromClass([supView class]) isEqualToString:@"UIView"]) {
        return supView;
    }else{
        return [self GetSuperView:supView];
    }
}

//-(void)layoutSubviews{
//
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

}
*/

@end
