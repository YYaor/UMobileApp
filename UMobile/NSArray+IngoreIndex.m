//
//  NSArray+IngoreIndex.m
//  UMobile
//
//  Created by  APPLE on 2014/9/15.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "NSArray+IngoreIndex.h"

@implementation NSArray (IngoreIndex)

-(id)ingoreObjectAtIndex:(NSInteger)index{
    NSInteger maxIndex =  [self count] - 1;
    if (index - maxIndex > 0) {
        NSLog(@"%@ out of index at %d",NSStringFromClass([self class]),index);
        return @"";
    }else{
        return [self objectAtIndex:index];
    }
}

-(id)keyObjectAtIndex:(NSInteger)index{
    NSInteger maxIndex =  [self count] - 1;
    if (index - maxIndex > 0) {
        NSLog(@"%@ out of index at %d",NSStringFromClass([self class]),index);
        return @"";
    }else{
        return [[self objectAtIndex:index] objectAtIndex:0];
    }
}

@end
