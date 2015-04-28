//
//  RCNetWork.h
//  UMobile
//
//  Created by  APPLE on 2014/11/3.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCNetWork : NSObject

int getGprs3GFlowIOBytes();

- (long long int)getInterfaceBytes;
NSString *bytesToAvaiUnit(int bytes);

@end
