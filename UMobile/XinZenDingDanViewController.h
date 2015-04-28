//
//  XinZenDingDanViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/23.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "XinZenHeaderViewController.h"
#import "XinZenDetailViewController.h"
#import "RCMutileView.h"

@interface XinZenDingDanViewController : RCViewController{
    
}

@property (retain, nonatomic) IBOutlet RCMutileView *mutileView;
@property (retain, nonatomic) NSMutableArray *products;
@property (retain, nonatomic) NSMutableDictionary *headInfo;
@property (nonatomic) BOOL bEdit;
@property (nonatomic,retain) NSString *InvId;
@property (nonatomic,retain) NSString *AccID;

@property (nonatomic) BOOL bClean;

@end
