//
//  NSString+Format.m
//  UMobile
//
//  Created by Rid on 14/11/26.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "NSString+Format.h"

@implementation NSString (Format)


+(NSString *)numberFromString:(NSString *)str{
    return [NSString stringWithFormat:@"%0.02f",[str doubleValue]];
}

// add methods ghd  20150127
+(NSMutableString *)deleteSpecialChar:(NSString *)jsonStr
{
    NSMutableString *jsonString = [NSMutableString stringWithString:jsonStr];
    NSString *str = nil;
    for (int i = 0; i < jsonString.length; i ++) {
        str = [jsonString substringWithRange:NSMakeRange(i, 1)];
        if ([str isEqualToString:@"\\"]) {
            [jsonString deleteCharactersInRange:NSMakeRange(i, 1)];
        }
    }
    NSLog(@"%@", jsonString);
    return jsonString;
}

@end

