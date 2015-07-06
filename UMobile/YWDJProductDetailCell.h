//
//  YWDJProductDetailCell.h
//  UMobile
//
//  Created by yunyao on 15/5/8.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWDJProductDetailCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *MingChengLabel;
@property (retain, nonatomic) IBOutlet UILabel *bianMaLabel;
@property (retain, nonatomic) IBOutlet UILabel *guiGeLabel;
@property (retain, nonatomic) IBOutlet UILabel *xingHaoLabel;
@property (retain, nonatomic) IBOutlet UILabel *danWeiLabel;
@property (retain, nonatomic) IBOutlet UILabel *shuLiangLabel;
@property (retain, nonatomic) IBOutlet UILabel *danJiaLabel;
@property (retain, nonatomic) IBOutlet UILabel *zheHouDanJiaLabel;
@property (retain, nonatomic) IBOutlet UILabel *zhenPingLabel;
@property (retain, nonatomic) IBOutlet UILabel *zheHouJingELabel;
@property (retain, nonatomic) IBOutlet UILabel *piHaoXingXiLabel;
-(void) updateData;
@end
