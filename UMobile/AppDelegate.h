//
//  AppDelegate.h
//  UMobile
//
//  Created by  APPLE on 2014/9/2.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "RCObjectManager.h"
#import "Toast+UIView.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    Reachability *hostReach;
}

@property (strong, nonatomic) UIWindow *window;

@end
