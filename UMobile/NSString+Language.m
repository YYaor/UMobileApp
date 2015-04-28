//
//  NSString+Language.m
//  WebPOS_APP
//
//  Created by  APPLE on 2014/4/28.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "NSString+Language.h"

@implementation NSString (Language)


+ (void)SetLanguageType:(Language_Type)tp{
    [[NSUserDefaults standardUserDefaults] setInteger:tp forKey:@"LanguageType"];
}

+(Language_Type)GetLanguageType{
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"LanguageType"];
}

+ (NSString *)strConvert:(NSString *)str{
    NSUInteger lt = [[NSUserDefaults standardUserDefaults]integerForKey:@"LanguageType"];
    
    NSDictionary *dic  = nil;
	NSString *strValue = nil;
	if (lt==L_English ) {
		return str;
	}else if (lt==L_SChinese) {
		dic = [[self GetLanguageDictionary] objectForKey:@"SimpleChinese"];
		
	}else {
		dic = [[self GetLanguageDictionary] objectForKey:@"TraditionChinese"];
		
	}
	strValue = [dic objectForKey:str];
	if (strValue==nil) return str;
	return strValue;
    return nil;
}

+(NSDictionary *)GetLanguageDictionary{
    static NSDictionary *language;
    @synchronized(self){
		if (!language) {
			language =[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Language" ofType:@"plist"]];
//            NSLog(@"init a  language dictionary");
		}
	}
    return language;
}

@end
