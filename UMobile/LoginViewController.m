//
//  LoginViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/10/16.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize info;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.info = [NSMutableArray array];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    if ([[self.setting strForKey:@"PsdClick"] isEqual:@"YES"]) {
        self.checkButton.choose = YES;
        
        [self setText:[self.setting strForKey:@"UserName"] forView:self.view withTag:1];
        [self setText:[self.setting strForKey:@"PassWord"] forView:self.view withTag:2];
        [self setText:[self.setting strForKey:@"ZhangTao"] forView:self.view withTag:3];
    }
    else {
        self.checkButton.choose = NO;
        
        [self.setting setObject:@"" forKey:@"ZhangTao"];
        [self.setting setObject:@"" forKey:@"UserName"];
        [self.setting setObject:@"" forKey:@"PassWord"];
        [USER_DEFAULT setObject:self.setting forKey:@"Setting"];
    }

    if (bHighRetain) {
        [self.imageView setImage:[UIImage imageNamed:@"login1136"]];
        self.backView.frame = CGRectMake(0, 200, 320, self.backView.frame.size.height);
    }else{
        [self.imageView setImage:[UIImage imageNamed:@"login960"]];
        self.backView.frame = CGRectMake(0, 190, 320, self.backView.frame.size.height);
    }
    
    
    [self setBackViewFrame];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    //每次显示页面重置
    //默认登录模式
    [self.setting setObject:@"0" forKey:@"Demo"];
    //默认产品标识
    [self.setting setObject:@"U+" forKey:@"Identy"];
    //默认职员ID
    [self.setting setObject:@"1" forKey:@"UID"];
    [self setNavigationHide];
}

-(void)setBackViewFrame{
    if (bHighRetain) {
        self.backView.frame = CGRectMake(0, 200, self.backView.frame.size.width, self.backView.frame.size.height);
    }else{
        self.backView.frame = CGRectMake(0, 190, self.backView.frame.size.width, self.backView.frame.size.height);
    }
    self.backView.backgroundColor = [UIColor clearColor];
}

-(void)keyboardWillShow:(id)info{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backView.frame = CGRectMake(0, 20, self.backView.frame.size.width, self.backView.frame.size.height);
        self.backView.backgroundColor = [UIColor whiteColor];
    });

}

-(void)keyboardWillHide:(id)info{
    [self setBackViewFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// add methods
- (void)resetUser
{
    [self setText:@"" forView:self.view withTag:1];
    [self setText:@"" forView:self.view withTag:2];
}

-(void)clearTextFields{
    [self setText:@"" forView:self.view withTag:1];
    [self setText:@"" forView:self.view withTag:2];
    [self setText:@"" forView:self.view withTag:3];
    self.info = [NSMutableArray array];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//登陆
- (IBAction)loginClick:(id)sender {

    if (self.checkButton.choose == YES) {
        
        [self.setting setObject:[self getTextFromView:self.view withTag:1] forKey:@"UserName"];
        [self.setting setObject:[self getTextFromView:self.view withTag:2] forKey:@"PassWord"];
        [self.setting setObject:[self getTextFromView:self.view withTag:3] forKey:@"ZhangTao"];
        //设置BS区分
        [self.setting setObject:[[self setting] objectForKey:@"ZhangTaoIsBS"] forKey:@"ISBS"];
        [USER_DEFAULT setObject:self.setting forKey:@"Setting"];
    }

    NSArray *alerts = @[@"请输入帐号",@"请输入密码",@"请选择账套"];
    for (int i = 1 ; i < 4 ; i ++){
        if ([[self getTextFromView:self.view withTag:i] length] == 0){
            [self ShowMessage:[alerts objectAtIndex:i - 1]];
            return;
        }
    }
    [self.view endEditing:YES];
    NSString *param = [NSString stringWithFormat:@"'%@','%@','01'",
                       [self getTextFromView:self.view withTag:1],
                       [self getTextFromView:self.view withTag:2]
                       ];
    
    NSString *link =  [[self GetLinkWithFunction:71 andParam:param] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __block LoginViewController *tempSelf = self;
    
    [self StartQuery:link completeBlock:^(id obj) {
        NSDictionary * dic =  [obj objectFromJSONString];
        NSArray *result = nil;
        if ([[dic objectForKey:@"success"] intValue] == 0) {
            [tempSelf ShowMessage:@"找不到服务器,请稍后重试"];
            
        }else{
            result = [[dic objectForKey:@"D_Data"] objectAtIndex:0];
            // change
            if ([[result objectAtIndex:0] isEqualToString:@"登录成功"]) {
                // BS
//                if ([@"1" isEqual:[[self setting] objectForKey:@"ISBS"]]) {
//                    //设置BS区分
//                    [self.setting setObject:[[self setting] objectForKey:@"ZhangTaoIsBS"] forKey:@"ISBS"];
//                    //设置产品标识
//                    [self.setting setObject:[result objectAtIndex:2] forKey:@"Identy"];
//                    //设置职员ID
//                    [self.setting setObject:[result objectAtIndex:1] forKey:@"UID"];
//                }
                
                //设置BS区分
                [self.setting setObject:[[self setting] objectForKey:@"ZhangTaoIsBS"] forKey:@"ISBS"];
                //设置产品标识
                [self.setting setObject:[result objectAtIndex:2] forKey:@"Identy"];
                //设置职员ID
                [self.setting setObject:[result objectAtIndex:1] forKey:@"UID"];
                
                UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
                [tempSelf.navigationController pushViewController:vc animated:YES];
            }else
            {
//                [tempSelf ShowMessage:[result objectAtIndex:0]];
                if ([[dic strForKey:@"Result"] length] > 0) {
                    [tempSelf ShowMessage:[dic strForKey:@"Result"]];
                }else if ([[dic strForKey:@"错误"] length] > 0) {
                    [tempSelf ShowMessage:[dic strForKey:@"错误"]];
                }else if ([[result objectAtIndex:0] isEqualToString:@""]){
                    [tempSelf ShowMessage:@"无效的操作员编码"];
                }else
                {
                    [tempSelf ShowMessage:[result objectAtIndex:0]];
                }
            }
        }
        
    } lock:YES];
    
}

//演示
- (IBAction)demoClick:(id)sender {
    if ([[self.setting strForKey:@"Show"] isEqual:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置未启用演示功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else {
        //设置BS区分
        [self.setting setObject:@"0" forKey:@"ISBS"];
        
        [self.setting setObject:@"1" forKey:@"Demo"];
        UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)loadData{
    [self setText:[self.info objectAtIndex:1] forView:self.view withTag:3];
    [self.setting setObject:[self.info objectAtIndex:1] forKey:@"ZhangTao"];
    [self.setting setObject:[self.info objectAtIndex:0] forKey:@"ServerPath"];
    [self.setting setObject:[self.info objectAtIndex:3] forKey:@"ZhangTaoIsBS"];
    [USER_DEFAULT setObject:self.setting forKey:@"Setting"];

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag == 3){
        //判断是否绑定过
        //获取应用程序沙盒的Documents目录
//        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//        NSString *plistPath1 = [paths objectAtIndex:0];
//
//        //得到完整的文件名
//        NSString *filename=[plistPath1 stringByAppendingPathComponent:@"user.plist"];
//
//        //那怎么证明我的数据写入了呢？读出来看看
//        NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
//        //NSLog(@"%@", data1);
//        NSString *uid = [data1 objectForKey:@"uid"];
//
//        NSString *tel = [self.setting strForKey:@"PhoneNum"];
        
        
        if (self.tel == nil) {    //未绑定
            RCAlertView *alertView =  [[[RCAlertView alloc]init] autorelease];
            [alertView ShowViewInObject:self.view withMsg:@"请输入手机号码" PhoneNum:[self.setting strForKey:@"PhoneNum"]];
            while(alertView.isVisiable) {
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
            }
            if (alertView.isOk){
                CangKuViewController *vc = (CangKuViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"CangKuViewController"];
                vc.link = [self GetLinkWithFunction:999 andParam:alertView.num];
                
                [self.setting setObject:alertView.num forKey:@"PhoneNum"];
                
                [USER_DEFAULT setObject:self.setting forKey:@"Setting"];
                
                vc.info = self.info;
                vc.parentVC = self;
                vc.title = @"选择账套";
                [self.navigationController pushViewController:vc animated:YES];
            }
            return NO;
        }else{  //已绑定
            
//            NSString *tel = [self.setting strForKey:@"PhoneNum"];// objectForKey:@"tel"];
            
            CangKuViewController *vc = (CangKuViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"CangKuViewController"];
            vc.link = [self GetLinkWithFunction:999 andParam:self.tel];
            
//            [self.setting setObject:self.tel forKey:@"PhoneNum"];
//
//            [USER_DEFAULT setObject:self.setting forKey:@"Setting"];
            
            vc.info = self.info;
            vc.parentVC = self;
            vc.title = @"选择账套";
            [self.navigationController pushViewController:vc animated:YES];
            return NO;
        }
        
        
    }

//    if(textField.tag == 3) {
//        CangKuViewController *vc = (CangKuViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"CangKuViewController"];
//        vc.link =  @"http://www.cnsub.net:32021/ZTlist.api?UID=119";
//        vc.info = self.info;
//        vc.parentVC = self;
//        vc.title = @"选择帐套";
//        [self.navigationController pushViewController:vc animated:YES];
//        return NO;
//    }
    
    
    return YES;
}
- (IBAction)psdClick:(id)sender {
    self.checkButton.choose = !self.checkButton.choose;
    if(self.checkButton.choose == YES) {
        
        [self.setting setObject:@"YES" forKey:@"PsdClick"];
    
    }else{
    
        [self.setting setObject:@"NO" forKey:@"PsdClick"];
        [self.setting setObject:@"" forKey:@"ZhangTao"];
        [self.setting setObject:@"" forKey:@"UserName"];
        [self.setting setObject:[self getTextFromView:self.view withTag:2] forKey:@"PassWord"];
        [USER_DEFAULT setObject:self.setting forKey:@"Setting"];
    
    }
    NSLog(@"setting = %@",self.setting);
}

- (IBAction)settingClick:(id)sender {
    RCViewController *vc =  (RCViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"ServerViewController"];
    vc.parentVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.info = nil;
    [_checkButton release];
    [_imageView release];
    [_backView release];
    [super dealloc];
}

@end
