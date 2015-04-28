//
//  KYBubbleView.h
//  driver
//
//  Created by 陈 景云 on 14-4-12.
//  Copyright (c) 2014年 rid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYBubbleView : UIScrollView{
    NSDictionary *_infoDict;
    UILabel      *titleLabel;
    UILabel      *detailLabel;
    UILabel      *contactLabel;
    UILabel      *homeAddresslabel;
    UIButton     *rightButton;
    NSUInteger   index;
    NSMutableArray      *imgViews;
}

@property(nonatomic,retain) NSDictionary *infoDict;
@property NSUInteger index;

-(BOOL)showFromRect:(CGRect)rect;
-(void)makePhoneCall;

@end
