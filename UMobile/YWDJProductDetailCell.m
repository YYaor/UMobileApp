//
//  YWDJProductDetailCell.m
//  UMobile
//
//  Created by yunyao on 15/5/8.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "YWDJProductDetailCell.h"

@implementation YWDJProductDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc {
    [_MingChengLabel release];
    [_bianMaLabel release];
    [_guiGeLabel release];
    [_xingHaoLabel release];
    [_danWeiLabel release];
    [_shuLiangLabel release];
    [_danJiaLabel release];
    [_zheHouDanJiaLabel release];
    [_zhenPingLabel release];
    [_zheHouJingELabel release];
    [_piHaoXingXiLabel release];
    [super dealloc];
}
@end
