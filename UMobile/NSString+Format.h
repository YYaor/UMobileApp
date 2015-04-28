//
//  NSString+Format.h
//  UMobile
//
//  Created by Rid on 14/11/26.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Format)

+(NSString *)numberFromString:(NSString *)str;

+(NSMutableString *)deleteSpecialChar:(NSString *)jsonStr;

@end
