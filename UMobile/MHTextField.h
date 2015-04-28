//
//  MHTextField.h
//
//  Created by Mehfuz Hossain on 4/11/13.
//  Copyright (c) 2013 Mehfuz Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHTextField;

@protocol MHTextFieldDelegate <NSObject>

@required
- (MHTextField*) textFieldAtIndex:(int)index;
- (int) numberOfTextFields;
- (UIScrollView *)GetScrollView;
-(void)doneButtonClick:(id)sender;

@end

@interface MHTextField : UITextField

@property (nonatomic) BOOL required;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, setter = setDateField:) BOOL isDateField;
@property (nonatomic, setter = setEmailField:) BOOL isEmailField;
@property (nonatomic, setter = setShowToolButton:) BOOL showToolButton;

@property (nonatomic, assign) id<MHTextFieldDelegate> textFieldDelegate;



- (BOOL) validate;

@end
