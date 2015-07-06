//
//  USettingModel.h
//  UMobile
//
//  Created by yunyao on 15/5/5.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USettingModel : NSObject

@property(nonatomic , assign) NSInteger JSRId;
@property(nonatomic , retain) NSString *JSRName;

@property(nonatomic , assign) NSInteger BMId;
@property(nonatomic , retain) NSString *BMName;

@property(nonatomic , assign) NSInteger KHId;
@property(nonatomic , retain) NSString *KHName;

@property(nonatomic , assign) NSInteger GRSId;
@property(nonatomic , retain) NSString *GRSName;

@property(nonatomic , assign) NSInteger FHCKId;
@property(nonatomic , retain) NSString *FHCKName;

@property(nonatomic , assign) NSInteger DHCKId;
@property(nonatomic , retain) NSString *DHCKName;

@property(nonatomic , assign) NSInteger FKZHId;
@property(nonatomic , retain) NSString *FKZHName;

@property(nonatomic , assign) NSInteger SKZHId;
@property(nonatomic , retain) NSString *SKZHName;

+(USettingModel *) getSetting;

@end
