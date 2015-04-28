//
//  RCDateView.h
//  UMobile
//
//  Created by  APPLE on 2014/12/4.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDateView : UIView{
    UIView *basicView;
    UIView *msgView;
    UILabel *label;
    
    UIButton *button1;
    UIButton *button2;
    UIDatePicker *datePicker;
}

-(void)ShowViewInObject:(id)obj withMsg:(NSString *)msg;

@property(nonatomic) BOOL isOk;
@property(nonatomic) BOOL isVisiable;
@property(nonatomic,retain) NSString *strDate;

@end
