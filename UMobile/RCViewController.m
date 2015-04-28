//
//  RCViewController.m
//  PingChangTourismFestival
//
//  Created by  APPLE on 2014/4/15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "RCViewController.h"

#include "sys/types.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface RCViewController ()

@end



@implementation RCViewController
@synthesize parentVC;
@synthesize setting ;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark Key

-(NSString *)GetOrderType:(NSString *)name{
    NSDictionary *dic = nil;
    if ([self.setting intForKey:@"ISBS"] == 1) {
        
        dic = @{@"全部":@"-1",
              @"进货单":@"0",
              @"进货退货单":@"3",
              @"进货订单":@"5",
              @"进货换货单":@"61",
              @"销售单":@"1",
              @"销售退货单":@"4",
              @"销售订单":@"6",
              @"销售换货单":@"14",
              @"付款单":@"100",
              @"收款单":@"101",
              @"现金费用单":@"102",
              @"一般费用单":@"103",
              @"其它收入单":@"104",
              @"内部转款单":@"105",
              @"固定资产购买单":@"106",
              @"固定资产折旧单":@"107",
              @"固定资产变卖单":@"108",
              @"应收款增加":@"109",
              @"应收款减少":@"110",
              @"应付款增加":@"111",
              @"应付款减少":@"112",
              @"资金增加":@"113",
              @"资金减少":@"114",
              @"待摊费用发生单":@"115",
              @"待摊费用摊销单":@"116",
              @"会计凭证":@"117",
              @"库存成本调价单":@"2",
              @"同价调拨单":@"7",
              @"变价调拨单":@"8",
              @"报损单":@"9",
              @"报溢单":@"10",
              @"赠送单":@"11",
              @"获赠单":@"12",
              @"拆装单":@"13",
              @"盘点单":@"67",
              @"其它入库单":@"17",
              @"其它出库单":@"18",
              @"经销商订单":@"118",
              @"要货单":@"119",
              @"配货单":@"120",
              @"经销商库存销量上报单":@"121",
              @"特价促销单":@"122",
              @"赠品促销单":@"123",
              @"打折促销单":@"124",
              @"让利促销单":@"125",
              @"组合促销单":@"126",
              @"零售单":@"127",
              @"预收款单":@"128",
              @"预付款单":@"129",
              @"报价单":@"19",
              @"询价单":@"15",
              @"采购费用分摊单":@"130",
              @"销售费用分摊单":@"131",
              @"进货发票":@"132",
              @"销售发票":@"133"
              };
    }else{
        dic = @{@"全部":@"-1",
                @"进货单":@"0",
                @"进货退货单":@"3",
                @"进货订单":@"5",
                @"进货换货单":@"61",
                @"销售单":@"1",
                @"销售退货单":@"4",
                @"销售订单":@"6",
                @"销售换货单":@"14",
                @"销售报价单":@"19",
                @"零售单":@"15",
                @"零售退货单":@"16",
                @"付款单":@"100",
                @"收款单":@"101",
                @"现金费用单":@"102",
                @"一般费用单":@"103",
                @"其它收入单":@"104",
                @"内部转款单":@"105",
                @"应收款增加":@"109",
                @"应收款减少"	:@"110",
                @"应付款增加":@"111",
                @"应付款减少":@"112",
                @"资金增加":@"113",
                @"资金减少":@"114",
                @"预收款单":@"118",
                @"预付款单":@"119",
                @"同价调拨单":@"7",
                @"变价调拨单":@"8",
                @"报损单":@"9",
                @"报溢单":@"10",
                @"赠送单":@"11",
                @"获赠单":@"12",
                @"拆装单":@"13",
                @"委托发货单":@"51",
                @"委托退货单":@"52",
                @"委托结算单":@"53",
                @"委托调价单":@"54",
                @"受托收货单":@"55",
                @"受托退货单":@"56",
                @"受托结算单":@"57",
                @"受托调价单":@"58",
                @"固定资产购买单":@"106",
                @"待摊费用发生单":@"115",
                @"会计凭证":@"117",
                @"固定资产变卖单":@"108",
                @"待摊费用发生单":@"115",
                @"应收款增加":@"109",
                @"应收款减少":@"110"
                };
    }

    return [dic strForKey:name];
}

-(NSString *)uuid{
    
    //return @"10200CE516024F4F93041BCD5C58F9E0";

    
    if ([CHKeyChain load:UUIDKEY]) {
        
        NSString *result = [CHKeyChain load:UUIDKEY];
        
//        [self ShowMessage:result];
        
        return result;
    }
    else
    {
        NSString *result = [[UIDevice currentDevice].identifierForVendor.UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [CHKeyChain save:UUIDKEY data:result];
        
//        [self ShowMessage:result];
        
        return [result autorelease];
    }
    
    
    return nil;
}

-(void)setTel:(NSString *)tel{
    [OM saveTel:tel];
}

-(NSString *)tel{
    return  [OM getTel];
}

-(BOOL)checkRight:(NSString *)strName{
    if ([setting intForKey:@"Demo"] == 1) {
        return YES;
    }else{
        for (NSArray * arr in OM.rights){
            if ([strName isEqualToString:[arr objectAtIndex:3]]){
                //NSLog(@"%@",[arr objectAtIndex:3]);
                return [[arr objectAtIndex:4] isEqualToString:@"True"];
            }
            
        }
    }
//    [self makeToastInWindow:@"没有此模块权限"];
    return NO;
}

//针对新增商品
-(BOOL)checkRightXzsp:(NSString *)strName1 name2:(NSString *)strName2{
    if ([setting intForKey:@"Demo"] == 1) {
        return YES;
    }else{
        for (NSArray * arr in OM.rights){
            if ([strName1 isEqualToString:[arr objectAtIndex:2]] && [strName2 isEqualToString:[arr objectAtIndex:3]]){
                //NSLog(@"%@",[arr objectAtIndex:3]);
                return [[arr objectAtIndex:4] isEqualToString:@"True"];
            }
            
        }
    }
    //    [self makeToastInWindow:@"没有此模块权限"];
    return NO;
}

-(void)awakeFromNib{
    self.shType = -1;
    self.yjType = -1;
}

-(void)backClick:(id)sender{
    [self dismiss];
}

//缓存
-(NSMutableDictionary *)GetCache{
    static dispatch_once_t once = 0;
    static NSMutableDictionary *dic;
    //---------------------------------------------------------------------------------------------------------------------------------------------
    dispatch_once(&once, ^{ dic = [[NSMutableDictionary alloc] init]; });
    
    return dic;
}

-(NSString *)GetCurrentDate{


    NSDateFormatter *format = [[[NSDateFormatter alloc]init] autorelease];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *date =[NSDate date];
    NSString *strdate =  [format stringFromDate:date];
    return strdate;
}

-(NSString *)GetCurrentTime{
    NSDateFormatter *format = [[[NSDateFormatter alloc]init] autorelease];
    [format setDateFormat:@"HH:MM:ss"];
    return [format stringFromDate:[NSDate date]];

}

-(NSString *)GetCurrentDateTime{
    NSDateFormatter *format = [[[NSDateFormatter alloc]init] autorelease];
    [format setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    return [format stringFromDate:[NSDate date]];
}

//json格式化前，替换字符串 \'  为 '
-(NSString *)encoardStringBeforeJson:(NSString *)str{

    //[str stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    //[str stringByReplacingOccurrencesOfString:@"\\\'" withString:@"\'"];

    NSString* test = str;
    test = [test stringByReplacingOccurrencesOfString:@"\\\'" withString:@"\'"];
    //NSDictionary* dic =  test.JSONValue;
    return test;
}

#pragma mark -
#pragma refresh

- (void)setupRefresh:(UITableView *)tableView
{

    [self setHeaderRefresh:tableView];
    [self setFooterRefresh:tableView];

}

-(void)setHeaderRefresh:(UITableView *)tableView{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    contentTableView = tableView;
    [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tableView.headerPullToRefreshText = @"下拉刷新";
    tableView.headerReleaseToRefreshText = @"松开刷新";
    tableView.headerRefreshingText = @"数据加载中...";
}


-(void)setFooterRefresh:(UITableView *)tableView{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    tableView.footerPullToRefreshText = @"上拉加载";
    tableView.footerReleaseToRefreshText = @"松开加载";
    tableView.footerRefreshingText = @"数据加载中...";
}

-(void)viewDidDisappear:(BOOL)animated{
    [contentTableView footerEndRefreshing];
    [contentTableView headerEndRefreshing];
}

-(void)addListener{
    
}

-(void)headerRereshing{
    
}

-(void)footerRereshing{
    
}

-(RCObjectManager *)GetOM{
    return OM;
}

-(void)setBackgroundView:(NSString *)imageName forCell:(UITableViewCell *)cell{
    UIImageView *imageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, 44)] autorelease];
    imageView.image =  [UIImage imageNamed:imageName];
    [cell setBackgroundView:imageView];
}

#pragma mark -
#pragma share

-(void)shareContent:(NSString *)content{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ic120" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"友加移动"
                                                  url:@"http://www.mob.com"
                                          description:@""
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    [container setIPhoneContainerWithViewController:self];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                   
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
//    [self dismissModalViewControllerAnimated:YES];
    [controller dismissViewControllerAnimated:YES completion:NULL];
    if(result == MessageComposeResultSent){
        [self.view makeToast:@"发送成功"];
    }

}

-(void)sendToNumber:(NSString *)number{
    MFMessageComposeViewController *vc = [[[MFMessageComposeViewController alloc]init] autorelease];
    vc.delegate = self;
    if ([MFMessageComposeViewController canSendText]) {
        vc.body = @"";
        vc.recipients = @[number];
        vc.messageComposeDelegate = self;
        [self presentViewController:vc animated:YES completion:NULL];
    }
}

-(void)callANumber:(NSString *)number{
    NSString *tel = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark -

-(void)setProductImage:(NSString *)Pid inImageView:(UIView *)imageView{
    if (![imageView isKindOfClass:[UIImageView class]]) return;

    NSString *strID = @"";
    NSString *server = @"";
    NSString *serverPort = @"";
    NSString *serverPath = @"";
    
    if ([setting intForKey:@"Demo"] == 0){
        strID = [self uuid];// [UIDevice currentDevice].identifierForVendor.UUIDString;// [setting strForKey:@"UserID"];
        server = [setting strForKey:@"Server"];
        serverPort = [setting strForKey:@"ServerPort"];
        serverPath = [setting strForKey:@"ServerPath"];
    }

    
    if ([strID length] == 0) strID = @"119";
    if ([server length] == 0) server = @"www.cnsub.net";
    if ([serverPort length] == 0) serverPort = @"32021";
    if ([serverPath length] == 0) serverPath = @"cnsubMB01";
    
    
    NSString *serverLink =  [NSString stringWithFormat:@"%@:%@/",server,serverPort];
    NSString *link = [NSString stringWithFormat:@"http://%@Imge.api?UID=%@/%@&Prod=%@",serverLink,strID,serverPath,Pid];
    [(UIImageView *)imageView setImage:nil];
    if ([[self GetCache] objectForKey:link]) {
        [(UIImageView *)imageView setImage:[UIImage imageWithData:[[self GetCache] objectForKey:link]]];
    }else{

        __block NSMutableDictionary *cache = [self GetCache];
        [loadPictureQueue addOperationWithBlock:^{
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:link]];
            [cache setObj:data forKey:link];//缓存
            UIImage * image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if([imageView respondsToSelector:@selector(setImage:)])
                    [imageView performSelector:@selector(setImage:) withObject:image];
            });
        }];
    }
}

-(void)clearPictureCache{
    [pictureCache removeAllObjects];
}

- (void)setImageWithURL:(NSURL *)url{
    
}



-(NSString *)GetLinkWithFunction:(NSUInteger)functionType andParam:(NSString *)param{
    
    NSLog(@"Class %@   function %d",[self class],functionType);
    NSString *link = @"";
    
    NSString *strID = @"";
    NSString *server = @"";
    NSString *serverPort = @"";
    NSString *serverPath = @"";
    
    if ([setting intForKey:@"Demo"] == 0){
        strID = [self uuid];// [UIDevice currentDevice].identifierForVendor.UUIDString;// [setting strForKey:@"UserID"];
        server = [setting strForKey:@"Server"];
        serverPort = [setting strForKey:@"ServerPort"];
        serverPath = [setting strForKey:@"ServerPath"];
    }
//    NSLog(@"striD %@",strID);
    
    if ([strID length] == 0) strID = @"119";
    if ([server length] == 0) server = @"www.cnsub.net";
    if ([serverPort length] == 0) serverPort = @"32021";
    if ([serverPath length] == 0) serverPath = @"cnsubMB01";
    
    NSString *serverLink =  [NSString stringWithFormat:@"%@:%@/",server,serverPort];
    
    if (functionType == 999){
        link = [NSString stringWithFormat:@"http://%@ZTlist.api?UID=%@&Tel=%@",serverLink,strID,param];//帐套选择
        
    }else if (functionType == 888) {
        link = [NSString stringWithFormat:@"http://%@Test.api",serverLink];//网络测试
    }else if (functionType == 777){
        link = [NSString stringWithFormat:@"http://%@Info.api?UID=%@",serverLink,strID];//到期时间
    }else{
        
        if (param == nil) {
            return [NSString stringWithFormat:@"http://%@Bill.api?UID=%@/%@",serverLink,strID,serverPath];
        }
        link = [NSString stringWithFormat:@"http://%@Data.api?UID=%@/%@&Call=%d&Param=%@",serverLink,strID,serverPath,functionType,param];
    }
    NSLog(@"link %@",link);

    return link;
}

-(NSString *)GetUserID{
    return [setting strForKey:@"UID"];
}

-(NSString *)GetSystemDate{
    NSString *link = [self GetLinkWithFunction:85 andParam:@""];
    NSString *date =  nil;
    ASIHTTPRequest * request =  [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:link]] autorelease];
    [request startSynchronous];
    NSArray *info = [[request.responseString objectFromJSONString] objectForKey:@"D_Data"];
    if ([info count] > 0) {
        NSLog(@"get system date");
        date = [info objectAtIndex:0];
    }else{
        date = [self GetCurrentDate];
    }
    
    return date;
}

#pragma mark -

-(NSMutableDictionary *)GetSetting{
    static NSMutableDictionary *info;
    @synchronized(self){
        if (!info) {
            info = [[NSMutableDictionary alloc] initWithDictionary:[USER_DEFAULT objectForKey:@"Setting"]];
        }
    }
    return info;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.setting =  [self GetSetting];
    
    [self setBackgroundImage:@"SuperList_bg"];
    self.queue = [NSMutableArray array];
    
    loadPictureQueue = [[NSOperationQueue alloc]init];
    loadPictureQueue.maxConcurrentOperationCount = 1;
    pictureCache = [[NSMutableDictionary alloc] init];
    OM =  [RCObjectManager shared];
	// Do any additional setup after loading the view.
}

-(void)makeToastInWindow:(NSString *)msg {
    UIWindow *window = nil;
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if ([delegate respondsToSelector:@selector(window)])
        window = [delegate performSelector:@selector(window)];
    else window = [[UIApplication sharedApplication] keyWindow];
    
    [window makeToast:msg];
}

-(void)setNavigationHide{
    self.navigationController.navigationBarHidden = YES;
}

-(void)setNavigationShow{
    self.navigationController.navigationBarHidden = NO;
}


-(void)setBackgroundImage:(NSString *)name{
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:name]];
}

-(void)SetLanguage{
    
}

-(void)loadData{
    
}

-(UIViewController *)GetSuperViewController:(UIViewController *)vc{
    if (vc.parentViewController == nil) {
        return vc;
    }else{
        return [self GetSuperViewController:vc.parentViewController];
    }
}

-(UITableViewCell *)GetSuperCell:(id)sender{
    if ([sender superview] == nil) return  nil;
    if ([[sender superview] isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell *)[sender superview];
    }else{
        return [self GetSuperCell:[sender superview]];
    }
}


-(void)SetView:(UIView *)view aboveTag:(NSUInteger )tag{

}

-(NSString *)explandJsonString:(NSString *)str{
    NSString *str0 = [str substringToIndex:1];
    if ([str0 isEqualToString:@"["] | [str0 isEqualToString:@"{"]) {
        return str;
    }else{
        NSRange range1 = [str rangeOfString:@"["];
        NSRange range2 = [str rangeOfString:@"{"];
        if (range1.location == NSNotFound && range2.location == NSNotFound) {
            return str;
        }
        if (range1.location > range2.location) {
            return [str substringFromIndex:range2.location];
        }else{
            return [str substringFromIndex:range1.location];
        }
    }
    return str;
}


-(NSString *)getTextFromView:(UIView *)view withTag:(NSUInteger)tag{
    UIView *subView = [view viewWithTag:tag];
    if ([subView respondsToSelector:@selector(setText:)])
        return [subView performSelector:@selector(text)];
    
    return @"";
}

-(NSString *)replaceCharetor:(NSString *)str{
    
    return [[str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""] stringByReplacingOccurrencesOfString:@"\\\'" withString:@"\'"];
    
}


//-(void)StartQuery:(NSString *)link{
//    ASIHTTPRequest * request =  [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:link]] autorelease];
//    request.delegate = self;
//    [request setDidFinishSelector: @selector(serverRequestFinished:)];
//    [request setDidFailSelector: @selector(serverRequestFailed:)];
//    [request startAsynchronous];
//}

-(id)StartQuery:(NSString *)link{
    ASIHTTPRequest * request =  [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:link]] autorelease];
    [request startSynchronous];
    NSString *newString =  [self replaceCharetor:request.responseString];
    return [newString objectFromJSONString];
}

-(void)StartQuery:(NSString *)link completeBlock:(myBlock)block lock:(BOOL)lock{
    __block ASIHTTPRequest * request =  [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:link]] autorelease];
    __block RCViewController *tempSelf = self;

    if (lock) [ProgressHUD show:nil];
    [self.queue addObject:request];
    
    [request setResponeBlock:^(NSString *responeString) {
        NSData *data =  [responeString dataUsingEncoding:NSUTF8StringEncoding];
        [OM saveFlow:[tempSelf GetCurrentDate] byte:[data length] type:0];
        NSString *newString =  [tempSelf replaceCharetor:responeString];
        block((id)newString);
        dispatch_async(dispatch_get_main_queue(), ^{
            [tempSelf.queue removeObject:request];
            if(lock) [ProgressHUD dismiss];
        });
        
    }];
    
    
    [request setFailedBlock:^{
        block((id)@"");
        dispatch_async(dispatch_get_main_queue(), ^{
            [tempSelf.queue removeObject:request];
            if(lock) [ProgressHUD dismiss];
        });
    }];
    
    [request startAsynchronous];


}

-(void)StartQuery:(NSString *)link withStrInfo:(NSDictionary *)info completeBlock:(myBlock)block{
    __block ASIHTTPRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:link]];
//    __block RCViewController *tempSelf = self;
    
    NSMutableString *bodyContent = [NSMutableString string];
    //NSString *POST_BOUNDS = [NSString stringWithFormat:@"%ld",[[NSDate date] timeIntervalSince1970]];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *s = [NSString stringWithFormat:@"%f",a];
    NSString *POST_BOUNDS = [NSString stringWithFormat:@"%d", [s intValue]];
    
    //    for(NSString *key in info.allKeys){
    //        id value = [info objectForKey:key];
    /*
     [bodyContent appendFormat:@"———————%@\r\n",POST_BOUNDS];
     [bodyContent appendFormat:@"Content-Disposition: form-data; name=\"Param\"\r\n"];
     [bodyContent appendFormat:@"%@\r\n\r\n —————————%@—\r\n",[info JSONString],POST_BOUNDS];
     [bodyContent appendFormat:@"Content-Disposition: form-data; name=\"Submit\" \r\n"];
     [bodyContent appendFormat:@"提交\r\n\r\n —————————%@—",POST_BOUNDS];//dataover
     */
    
    [bodyContent appendFormat:@"-----------------------------%@\r\n",POST_BOUNDS];
    [bodyContent appendFormat:@"Content-Disposition: form-data; name=\"Param\"\r\n\r\n"];
    [bodyContent appendFormat:@"%@\r\n-----------------------------%@\r\n",[info JSONString],POST_BOUNDS];
    
    //[bodyContent appendFormat:@"Content-Disposition: form-data; name=\"Submit\"\r\n\r\n提交\r\n"];
    //[bodyContent appendFormat:@"-----------------------------%@--\r\n",POST_BOUNDS];
    
    
    //    }
    
    NSLog(@"%@",bodyContent);
    
    NSStringEncoding encoding;
    encoding = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingGB_18030_2000);
    
    
    [request setRequestMethod:@"POST"];
    NSData *bodyData=[bodyContent dataUsingEncoding:encoding];
    
    
    [request setPostBody:bodyData];
    [request setPostLength:bodyData.length];
    
    [request setDelegate:self];
    
    if (block) {
        [ProgressHUD show:nil];
//        [tempSelf.queue addObject:request];
        [request setResponeBlock:^(NSString *responeString) {
            [ProgressHUD dismiss];
//            [tempSelf.queue removeObject:request];
            block((id)responeString);
        }];
        [request setFailedBlock:^{
            NSLog(@"faile");
            [ProgressHUD dismiss];
        }];
        
    }else{
        [request setDidFailSelector:@selector(serverRequestFailed:)];
        [request setDidFinishSelector:@selector(serverRequestFinished:)];
        [request setDidStartSelector:@selector(serverRequestStart:)];
    }
    [request startAsynchronous];
    
    //    [self multiPartPost:info withlink:link];
    
}

// delegate




- (NSString *)stringFromGB2313:(NSData *)data {
    NSStringEncoding encoding;
    encoding = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingGB_18030_2000);
    return [[NSString alloc] initWithData:data encoding:encoding];
}

-(void)StartQuery:(NSString *)link withInfo:(NSDictionary *)info completeBlock:(myBlock)block{
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:link]];
    __block RCViewController *tempSelf = self;
    
    for (NSString *key in [info allKeys]){
        [request setPostValue:[info objectForKey:key] forKey:key];
    }
    [request setDelegate:self];
    
    
    if (block) {
        [ProgressHUD show:nil];
        [tempSelf.queue addObject:request];
        [request setResponeBlock:^(NSString *responeString) {
            [ProgressHUD dismiss];
            [tempSelf.queue removeObject:request];
            block((id)responeString);
        }];

    }else{
        [request setDidFailSelector:@selector(serverRequestFailed:)];
        [request setDidFinishSelector:@selector(serverRequestFinished:)];
        [request setDidStartSelector:@selector(serverRequestStart:)];
    }
    [request startAsynchronous];

}



-(void)ShowMessage:(NSString *)str{
    UIAlertView *alertView = [[[UIAlertView alloc]initWithTitle:@"信息" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
    [alertView show];
//    while (alertView.visible) {
//        [[NSRunLoop mainRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
//    }
}

-(void)serverRequestStart:(id)obj{
//    [ProgressHUD show:[NSString strConvert:@"loading..."]];
}

-(void)serverRequestFinished:(id)obj{
    
}

-(void)serverRequestFailed:(id)obj{
    [ProgressHUD dismiss];
//    [ProgressHUD showError:[NSString strConvert:@"Error"]];
}

-(void)dismiss{
//    [contentTableView headerEndRefreshing];
//    [contentTableView footerEndRefreshing];
//    [USER_DEFAULT setObject:self.setting forKey:@"Setting"];
    if (self.navigationController){
        NSString *strName = NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:0] class]);
        
        if ([strName isEqualToString:NSStringFromClass([self class])]) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
}


-(void)setImage:(UIImage *)image forView:(UIView *)view withTag:(NSUInteger)tag{
    UIView *v = [view viewWithTag:tag];
    if ([v isKindOfClass:[UIImageView class]]){
            UIImageView *imageView = (UIImageView *)v;
            [imageView setImage:image];
    }
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}


//判断是否为浮点形：


- (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}

-(void)setText:(NSString *)str forView:(UIView *)view withTag:(NSUInteger)tag{
    UIView *v = [view viewWithTag:tag];
    if (!v) return;
    if ([v respondsToSelector:@selector(setText:)]) {
        [v performSelectorOnMainThread:@selector(setText:) withObject:str waitUntilDone:YES];
    }else if ([v isKindOfClass:[UIImageView class]]){
        if ([v respondsToSelector:@selector(setImageWithURL:)]){
            UIImageView *imageView = (UIImageView *)v;
            [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"def"]];
            [imageView addDetailShow];
        }
//        [v performSelectorOnMainThread:@selector(setImageWithURL:) withObject:[NSURL URLWithString:str] waitUntilDone:YES];
    }
}

-(void)reSizeOfString:(NSString *)str withTextField:(UITextView *)view{
    if ([view canPerformAction:@selector(setText:) withSender:nil]) {
        CGSize size = CGSizeMake(view.frame.size.width, 10000);
        CGSize newSize =  [str sizeWithFont:view.font constrainedToSize:size];
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, newSize.width, newSize.height + 50);
    }
}

-(void)reSizeImage:(NSMutableString *)result{
    BOOL find = YES;
    NSInteger loc = 0;
    NSInteger length = [result length];
    NSMutableArray *arr = [NSMutableArray array];
    NSRange curRange;
    while (find) {
        curRange = NSMakeRange(loc, length - loc - 1);
        NSRange imgStart = [result rangeOfString:@"<img" options:NSCaseInsensitiveSearch range:curRange];
        loc = imgStart.location;
//        length = length - imgStart.location;

            if (imgStart.location != NSNotFound) {
                @try {
                    curRange = NSMakeRange(loc, length - loc - 1);
                    NSRange imgEnd = [result rangeOfString:@"jpg\"" options:NSCaseInsensitiveSearch range:curRange];
                    loc = imgEnd.location;
//                    length = length - imgEnd.location;
                    [arr addObject:[NSString stringWithFormat:@"%d",imgEnd.location + 4] ]; // 4  为 jpg" 偏移量
                    
                }
                @catch (NSException *exception) {
                    NSLog(@"exception %@",exception);
                    find = NO;
                }
            }else{
                find = NO;
            }
        
    }
    NSString *add = [NSString stringWithFormat:@" width=\"300\""];
    NSUInteger offset = 0;
    for (NSString *lc in arr){
        [result insertString:add
                     atIndex:[lc integerValue] + offset ];
        offset += [add length];
    }
    NSLog(@"result %@",result);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getDataSizeString:(int) nSize
{
	NSString *string = nil;
	if (nSize<1024)
	{
		string = [NSString stringWithFormat:@"%dB", nSize];
	}
	else if (nSize<1048576)
	{
		string = [NSString stringWithFormat:@"%dK", (nSize/1024)];
	}
	else if (nSize<1073741824)
	{
		if ((nSize%1048576)== 0 )
        {
			string = [NSString stringWithFormat:@"%dM", nSize/1048576];
        }
		else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%dMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%d.%@M", nSize/1048576, decimalStr];
            }
        }
	}
	else	// >1G
	{
		string = [NSString stringWithFormat:@"%dG", nSize/1073741824];
	}
	
	return string;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


-(void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
    contentTableView = nil;
    [pictureCache release];
    [loadPictureQueue cancelAllOperations];
    [loadPictureQueue release];
    [self.queue makeObjectsPerformSelector:@selector(clearDelegatesAndCancel)];
    [super dealloc];
}
@end


#pragma mark -


@implementation RCTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)ShowMessage:(NSString *)str{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"信息" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

-(void)StartQuery:(NSString *)link completeBlock:(myBlock)block{
    ASIHTTPRequest * request =  [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:link]] autorelease];
    request.delegate = self;
    [request setDidFinishSelector: @selector(serverRequestFinished:)];
    [request setDidFailSelector: @selector(serverRequestFailed:)];
    [request setDataReceivedBlock:^(NSData *data){
        NSString *result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        block((id)[result objectFromJSONString]);
    }];
    [request startAsynchronous];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)StartQuery:(NSString *)link{
    ASIHTTPRequest * request =  [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:link]] autorelease];
    request.delegate = self;
    [request setDidFinishSelector: @selector(serverRequestFinished:)];
    [request setDidFailSelector: @selector(serverRequestFailed:)];
    [request startAsynchronous];
}

-(void)StartQuery:(NSString *)link withInfo:(NSDictionary *)info{
    ASIFormDataRequest *request = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:link]] autorelease];
    for (NSString *key in [info allKeys]){
        [request setPostValue:[info objectForKey:key] forKey:key];
    }
    [request setDelegate:self];
    [request setDidFailSelector:@selector(serverRequestFailed:)];
    [request setDidFinishSelector:@selector(serverRequestFinished:)];
    [request startAsynchronous];
}

-(NSDictionary *)GetUser{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"UserInfo"];
}

-(void)serverRequestFinished:(id)obj{
    
}

-(void)serverRequestFailed:(id)obj{
//    [self ShowMessage:@"网络错误"];
//    NSLog(@"error %@",obj);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
