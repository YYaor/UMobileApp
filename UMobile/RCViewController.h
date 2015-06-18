//
//  RCViewController.h
//  PingChangTourismFestival
//
//  Created by  APPLE on 2014/4/15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "NSDictionary_IngoreNull.h"
#import "NSMutableDictionary+Set.h"
#import "NSArray+IngoreIndex.h"
#import "ProgressHUD.h"
#import "RCObjectManager.h"
#import "UIImageView+Addition.h"
#import "MJRefresh.h"
#import "JSON.h"
#import "UIView+Extension.h"
#import "Toast+UIView.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "NSString+Format.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import "WeiboSDK.h"
#import <RennSDK/RennSDK.h>
#import "CHKeyChain.h"

#define UUIDKEY @"net.pericles.UMobile"
#define TELKey @"net.pericles.UMobile.Tel"


typedef void(^myBlock)(id obj);

typedef enum{
    FromType_None,
    FromType_ShenHe,
    FromType_DDGL
}FromType;

@class RCViewController;

@interface RCViewController : UIViewController<ASIHTTPRequestDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,NSStreamDelegate>{
    UITableView *contentTableView;
    RCObjectManager *OM;
    NSOperationQueue *loadPictureQueue;
    NSMutableDictionary *pictureCache;
    
}

@property(nonatomic,retain) NSMutableArray *queue;

@property(nonatomic,assign) RCViewController *parentVC;

@property(nonatomic,assign) NSMutableDictionary *setting;

@property(nonatomic,retain) NSInputStream *inputStream;

@property(nonatomic,retain) NSString *PTCODE;

@property(nonatomic) FromType fromType;

@property(nonatomic,assign,readwrite) NSString *tel;

-(void)StartQuery:(NSString *)link withInfo:(NSDictionary *)info completeBlock:(myBlock)block;
-(void)StartQuery:(NSString *)link withStrInfo:(NSDictionary *)info completeBlock:(myBlock)block;
-(void)StartQuery:(NSString *)link completeBlock:(myBlock)block lock:(BOOL)lock;
-(void)ShowMessage:(NSString *)str;
-(void)serverRequestFinished:(id)obj;
-(id)StartQuery:(NSString *)link;

//-(NSString *)getPTCODE;

-(void)serverRequestFailed:(id)obj;
-(void)reSizeImage:(NSMutableString *)result;//用于设置Html String 里image 宽度，暂只做了jpg
-(void)reSizeOfString:(NSString *)str withTextField:(UITextView *)view;//用于计算字符串高度

-(void)setText:(NSString *)str forView:(UIView *)view withTag:(NSUInteger)tag;
-(NSString *)getTextFromView:(UIView *)view withTag:(NSUInteger)tag;

-(void)setImage:(UIImage *)image forView:(UIView *)view withTag:(NSUInteger)tag;

-(void)SetView:(UIView *)view aboveTag:(NSUInteger )tag;
-(void)setBackgroundView:(NSString *)imageName forCell:(UITableViewCell *)cell;

-(void)SetLanguage;

-(void)loadData;

-(NSString *)explandJsonString:(NSString *)str;

-(UIViewController *)GetSuperViewController:(UIViewController *)vc;
-(UITableViewCell *)GetSuperCell:(id)sender;

-(NSString *)getDataSizeString:(int) nSize;
-(void)dismiss;

-(void)setBackgroundImage:(NSString *)name;

-(void)setNavigationHide;

-(void)setNavigationShow;

-(IBAction)backClick:(id)sender;

-(NSString *)GetCurrentDate;
-(NSString *)GetCurrentTime;
-(NSString *)GetCurrentDateTime;


-(void)setupRefresh:(UITableView *)tableView;
-(void)setHeaderRefresh:(UITableView *)tableView;
-(void)setFooterRefresh:(UITableView *)tableView;

-(void)headerRereshing;
-(void)footerRereshing;

-(NSString *)GetLinkWithFunction:(NSUInteger)functionType andParam:(NSString *)param;
-(void)setProductImage:(NSString *)Pid inImageView:(UIView *)imageView;


-(void)callANumber:(NSString *)number;
-(void)sendToNumber:(NSString *)number;

-(RCObjectManager *)GetOM;

-(void)makeToastInWindow:(NSString *)msg;

-(NSString *)GetUserID;


-(NSString *)GetSystemDate;

-(void)shareContent:(NSString *)content;

-(NSString *)uuid;


-(BOOL)checkRight:(NSString *)strName;
-(BOOL)checkRightXzsp:(NSString *)strName1 name2:(NSString *)strName2;

-(NSString *)GetOrderType:(NSString *)name;

-(NSString *)encoardStringBeforeJson:(NSString *)str;

-(void)clearPictureCache;

-(NSString *) getParamStringWithParamArray:(NSArray *)paramArray;

@property (nonatomic) int shType;//审核类型
@property (nonatomic) int yjType;//预警类型

@end

@interface RCTableViewController : UITableViewController<ASIHTTPRequestDelegate>

-(void)StartQuery:(NSString *)link withInfo:(NSDictionary *)info;
-(void)StartQuery:(NSString *)link;
-(void)StartQuery:(NSString *)link completeBlock:(myBlock)block;
-(NSDictionary *)GetUser;
-(void)ShowMessage:(NSString *)str;

-(void)serverRequestFinished:(id)obj;

-(void)serverRequestFailed:(id)obj;
    
@end
