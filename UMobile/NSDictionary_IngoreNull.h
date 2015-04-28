//
//  NSDictionary_IngoreNull.h
//  BooksBB
//
//  Created by rid on 11-9-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary(NSDictionary_IngoreNull)

-(NSString *)strForKey:(id)aKey;

-(NSString *)preStringForKey:(NSString *)aKey;

-(NSString *)sqlStringForKey:(NSString *)akey;

-(double )floatForKey:(NSString *)akey;

-(NSString *)numForKey:(NSString *)aKey;

-(NSInteger)intForKey:(NSString *)aKey;

-(BOOL) emptyForKey:(NSString *)aKey;


@end
