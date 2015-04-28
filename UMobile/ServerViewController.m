//
//  ServerViewController.m
//  UMobile
//
//  Created by 陈 景云 on 14-11-4.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "ServerViewController.h"

@interface ServerViewController ()

@end

@implementation ServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.text1.text = [self.setting strForKey:@"Server"];
    self.text2.text = [self.setting strForKey:@"ServerPort"];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self setNavigationShow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveClick:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.text1.text length] > 0){
        NSString *link = [NSString stringWithFormat:@"http://%@:%@/Test.api",self.text1.text,self.text2.text];
        __block ServerViewController *tempSelf = self;
        [self StartQuery:link completeBlock:^(id obj) {
            NSDictionary *info = [obj objectFromJSONString];
            if ([info intForKey:@"success"] == 0) {
                [tempSelf makeToastInWindow:@"服务器不可用，请检查服务器地址"];
                return;
            }else{
                [tempSelf makeToastInWindow:@"已成功设置服务器地址"];
                [tempSelf.setting setObject:self.text1.text forKey:@"Server"];
                [tempSelf.setting setObject:self.text2.text forKey:@"ServerPort"];
                [USER_DEFAULT setObject:tempSelf.setting forKey:@"Setting"];
                
                [tempSelf.setting setObject:@"" forKey:@"ZhangTao"];
                [tempSelf.setting setObject:@"" forKey:@"UserName"];
                [tempSelf.setting setObject:@"" forKey:@"PassWord"];
                [USER_DEFAULT setObject:self.setting forKey:@"Setting"];
                
                if ([tempSelf.parentVC respondsToSelector:@selector(clearTextFields)]) {
                    //清除登陆页内容
                    [tempSelf.parentVC performSelector:@selector(clearTextFields)];
                }
                [tempSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        } lock:YES];

    }

}


- (void)dealloc {
    [_text1 release];
    [_text2 release];
    [super dealloc];
}
@end
