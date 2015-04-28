//
//  CHKeyChain.h
//  UMobile
//
//  Created by Rid on 14/12/18.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Security/Security.h>

#define UUIDKEY @"net.pericles.UMobile"

@interface CHKeyChain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteData:(NSString *)service;

@end
