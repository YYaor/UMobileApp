//
//  AppDelegate.m
//  UMobile
//
//  Created by  APPLE on 2014/9/2.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "AppDelegate.h"
#import "RCViewController.h"


#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import "WeiboSDK.h"
#import <RennSDK/RennSDK.h>



@implementation AppDelegate

-(void)setInitialSetting{
    if (![USER_DEFAULT objectForKey:@"Setting"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"1",@"Show",
                                    @"1",@"Classics",
                                    @"0",@"Simple",
                                    @"0",@"Stock",
                                    @"0",@"Usable",
                                    nil];
        [dic setObject:@"32021" forKey:@"ServerPort"];
        [USER_DEFAULT setObject:dic forKey:@"Setting"];
    }
//    [USER_DEFAULT setObject:@"32021" forKey:@"ServerPort"];
}


-(void)setShareSDK{
    [ShareSDK registerApp:@"47c26903c010"];//字符串api20为您的ShareSDK的AppKey
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"568898243"
                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                              redirectUri:@"http://www.sharesdk.cn"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:@"801554502"
                                  appSecret:@"de6db597cb7794d570f6a97dfd83e082"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WeiboApi class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1103601794"
                           appSecret:@"zBPU00XHXhZO5FYh"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://open.qq.com/ 可用
    [ShareSDK connectQQWithQZoneAppKey:@"1103601794"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
    [ShareSDK connectQQWithAppId:@"1103601794"
                        qqApiCls:[QQApiInterface class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com 成功 返回
    [ShareSDK connectWeChatWithAppId:@"wx1fd81a3a03d14897"
                           wechatCls:[WXApi class]];
    
    [ShareSDK connectWeChatFavWithAppId:@"wx1fd81a3a03d14897" appSecret:@"660b2af70e44070274b1959d739cdb18" wechatCls:[WXApi class]];
    
//    //添加搜狐微博应用  注册网址  http://open.t.sohu.com
//    [ShareSDK connectSohuWeiboWithConsumerKey:@"SAfmTG1blxZY3HztESWx"
//                               consumerSecret:@"yfTZf)!rVwh*3dqQuVJVsUL37!F)!yS9S!Orcsij"
//                                  redirectUri:@"http://www.sharesdk.cn"];
//    
//    
//    [ShareSDK connectSMS];
    
//    
//    //添加豆瓣应用  注册网址 http://developers.douban.com
//    [ShareSDK connectDoubanWithAppKey:@"07d08fbfc1210e931771af3f43632bb9"
//                            appSecret:@"e32896161e72be91"
//                          redirectUri:@"http://dev.kumoway.com/braininference/infos.php"];
//    
//    //添加人人网应用 注册网址  http://dev.renren.com
//    [ShareSDK connectRenRenWithAppId:@"226427"
//                              appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
//                           appSecret:@"f29df781abdd4f49beca5a2194676ca4"
//                   renrenClientClass:[RennClient class]];
//    
//    //添加开心网应用  注册网址 http://open.kaixin001.com
//    [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c"
//                            appSecret:@"da32179d859c016169f66d90b6db2a23"
//                          redirectUri:@"http://www.sharesdk.cn/"];
//    
//    //添加Instapaper应用   注册网址  http://www.instapaper.com/main/request_oauth_consumer_token
//    [ShareSDK connectInstapaperWithAppKey:@"4rDJORmcOcSAZL1YpqGHRI605xUvrLbOhkJ07yO0wWrYrc61FA"
//                                appSecret:@"GNr1GespOQbrm8nvd7rlUsyRQsIo3boIbMguAl9gfpdL0aKZWe"];
//    
//    //添加有道云笔记应用  注册网址 http://note.youdao.com/open/developguide.html#app
//    [ShareSDK connectYouDaoNoteWithConsumerKey:@"dcde25dca105bcc36884ed4534dab940"
//                                consumerSecret:@"d98217b4020e7f1874263795f44838fe"
//                                   redirectUri:@"http://www.sharesdk.cn/"];
//    
//    //添加Facebook应用  注册网址 https://developers.facebook.com
//    [ShareSDK connectFacebookWithAppKey:@"107704292745179"
//                              appSecret:@"38053202e1a5fe26c80c753071f0b573"];
//    
//    //添加Twitter应用  注册网址  https://dev.twitter.com
//    [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg"
//                             consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc"
//                                redirectUri:@"http://www.sharesdk.cn"];
}

-(void)reachabilityChanged:(NSNotification *)note{
    RCObjectManager *OM = [RCObjectManager shared];
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status =  [curReach currentReachabilityStatus];
    
    switch (status) {
        case NotReachable:
            OM.netType = 2;
            break;
        case ReachableViaWiFi:
            OM.netType = 1;
            break;
        case kReachableViaWWAN:
            OM.netType = 0;
            break;
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self setInitialSetting];
    [self setShareSDK];
    
    
    RCViewController *vc =  [[[RCViewController alloc]init] autorelease];
    NSString *link =  [vc GetLinkWithFunction:888 andParam:@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    hostReach = [[Reachability reachabilityWithHostName:link] retain];
    [hostReach startNotifier];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
