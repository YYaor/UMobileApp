//
//  NSMutableDictionary+Set.h
//  UMobile
//
//  Created by  APPLE on 2015/3/20.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Set)

-(void)setObj:(id)anObject forKey:(id<NSCopying>)aKey;

@end
