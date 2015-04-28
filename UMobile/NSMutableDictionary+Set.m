//
//  NSMutableDictionary+Set.m
//  UMobile
//
//  Created by  APPLE on 2015/3/20.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "NSMutableDictionary+Set.h"

@implementation NSMutableDictionary (Set)

-(void)setObj:(id)anObject forKey:(id<NSCopying>)aKey{
    if (anObject) {

        [self setObject:anObject forKey:aKey];
    }
}

@end
