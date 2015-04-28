//
//  FeedbackViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/11/11.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "FeedbackViewController.h"
#import "NetWebServiceRequest.h"

@interface FeedbackViewController ()<NetWebServiceRequestDelegate>
@property (nonatomic, retain) NetWebServiceRequest* runningRequest;
@end

@implementation FeedbackViewController
@synthesize runningRequest = _runningRequest;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveClick:(id)sender {
    
    [self.textView resignFirstResponder];
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<AddFeedBack xmlns=\"http://tempuri.org/\">\n"
                             "<mobile>%@</mobile>\n"
                             "<feedContent>%@</feedContent>\n"
                             "</AddFeedBack>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             [self.setting strForKey:@"Mobile"],
                             self.textView.text];
    
    
    
    
    
    //请求发送到的路径
    NSString *url = @"http://fankui.893863.com/FeedBack.asmx";// http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx";
    NSString *soapActionURL = @"http://tempuri.org/AddFeedBack";// @"http://WebXml.com.cn/getMobileCodeInfo";
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"getMobileCodeInfo" SoapMessage:soapMessage];
    
    [request startAsynchronous];
    [request setDelegate:self];
    self.runningRequest = request;
}


#pragma mark NetWebServiceRequestDelegate Methods
- (void)netRequestStarted:(NetWebServiceRequest *)request
{
    
    [ProgressHUD show:nil];
}


- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSData *)requestData{
    [ProgressHUD dismiss];
    if ([[result lowercaseString] isEqualToString:@"true"]){
        [self makeToastInWindow:@"感谢你的反馈，我们已经收到你的意见和建议"];
        [self dismiss];
    }
    
}


- (void)netRequestFailed:(NetWebServiceRequest *)request didRequestError:(NSError *)error{
    [ProgressHUD dismiss];
    [self makeToastInWindow:error.description];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_textView release];
    [super dealloc];
}
@end
