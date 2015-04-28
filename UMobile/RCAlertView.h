//
//  RCAlertView.h
//  WebRest
//
//  Created by  APPLE on 2013/12/16.
//  Copyright (c) 2013年  APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ViewOrientation_vertical,
    ViewOrientation_horizontal
}ViewOrientation;

@interface RCAlertView : UIView{
    UIView *basicView;
    UIView *msgView;
    UILabel *label;
    UITextField *textView;
    UIButton *button1;
    UIButton *button2;
    
    CGSize viewSize;

}

-(void)ShowViewInObject:(id)obj withMsg:(NSString *)msg PhoneNum:(NSString *)phoneNum;

@property(nonatomic) BOOL isOk;
@property(nonatomic) BOOL isVisiable;
@property(nonatomic,retain) NSString *num;
@property(nonatomic) ViewOrientation viewOrientation;

-(instancetype)initwithOrientation:(ViewOrientation)orientation;

@end
