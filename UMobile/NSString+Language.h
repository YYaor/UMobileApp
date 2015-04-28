//
//  NSString+Language.h
//  WebPOS_APP
//
//  Created by  APPLE on 2014/4/28.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
	L_English,
	L_SChinese,
	L_TChinese,
}Language_Type;

@interface NSString (Language)

+(NSString *)strConvert:(NSString *)str;
+(void)SetLanguageType:(Language_Type)tp;
+(Language_Type)GetLanguageType;

@end
