//
//  XinZenShangPingViewController.m
//  UMobile
//
//  新增订单－－商品详情
//  订单录入－－商品详情
//
//  Created by  APPLE on 2014/9/24.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "XinZenShangPingViewController.h"

#define NUMBERS @"1234567890."

@interface XinZenShangPingViewController ()

@end

@implementation XinZenShangPingViewController
@synthesize productInfo;
@synthesize unitInfo,priceInfo,toBeString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.unitInfo = [NSMutableArray array];
    self.priceInfo = [NSMutableArray array];
    
    
    self.cpInfo = [self.productInfo mutableCopy];

    [self loadData];
    
    RCCheckButton *button = (RCCheckButton *)[self.view viewWithTag:13];
    button.choose = [self.cpInfo intForKey:@"赠品"] == 1;
    [button addTarget:self action:@selector(checkButtonClick:)];
//    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    UIColor *disableColor = [self.view viewWithTag:1].backgroundColor;
//    NSDictionary *infos =@{@"6":@"允许修改单据单价",@"9":@"允许修改折扣",@"11":@"允许修改折后金额",@"99":@"允许选择价格类型"};
//    NSArray *rs = @[@"6",@"7",@"9",@"10",@"11"];
    
    
    // fixBug
    NSArray *rs = @[@"9",@"10",@"11"];
    NSDictionary *infos =@{@"9":@"允许修改折扣",@"11":@"允许修改折后金额",@"99":@"允许选择价格类型"};
    
    //by wph 20150402
    //self.moreButton.hidden = ![self checkRight:@"允许选择价格类型"];
    
    NSArray *arr = [self.headInfo objectForKey:@"0"];
    self.moreButton.hidden = ![self checkRightXzsp:[arr objectAtIndex:1] name2:@"允许选择价格类型"];
    
    //根据权限禁用
    for (NSString *value in rs){
        UITextField *text1 = (UITextField *)[self.view viewWithTag:[value integerValue]];
        NSString *right = [infos strForKey:value];
        if ([right length] > 0) {
            if (![self checkRight:right]){
                text1.enabled = NO;
//                text1.backgroundColor = disableColor;
            }
            
        }
        [text1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    
    
    // Do any additional setup after loading the view.
}


-(void)checkButtonClick:(RCCheckButton *)sender{
    if (sender.choose) {
        NSString *oldPirce = [self getTextFromView:self.view withTag:6];
        [self.cpInfo setObject:@"1" forKey:@"赠品"];
        [self.cpInfo setObject:oldPirce forKey:@"以前价格"];
        [self setText:@"0" forView:self.view withTag:6];
        [self compute];
    }else{
        [self.cpInfo setObject:@"0" forKey:@"赠品"];
        [self setText:[self.cpInfo strForKey:@"以前价格"] forView:self.view withTag:6];
        [self compute];
    }
}

// Do any additional setup after loading the view.

-(void)keyboardWillShow:(NSNotification *)notification{
//    NSDictionary *info = notification.userInfo;
//    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
}

-(void)keyboardWillHide:(id)info{
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)loadData{
    NSArray *indexs = @[@"名称",@"商品编码",@"单位名称",@"型号",@"规格",@"单价",@"数量",@"条码",@"折扣",@"折后单价",@"折后金额",@"备注"];
    for (int i = 1 ; i < 13 ; i ++){
        [self setText:[self.cpInfo strForKey:[indexs objectAtIndex:i - 1]] forView:self.view withTag:i];
    }
    
    // add 单价根据换算率改变
    
    [self compute];
}

- (IBAction)moreButtonClick:(id)sender {
    PriceViewController *vc = (PriceViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PriceViewController"];
    vc.productInfo = self.cpInfo;
    vc.parentVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
-(void)compute:(NSUInteger)txtTag tobe:(NSString *)toBeString{
    UITextField *disText = (UITextField *)[self.view viewWithTag:9];//折扣
    UITextField *priText = (UITextField *)[self.view viewWithTag:10];//折后单价
    UITextField *amtText = (UITextField *)[self.view viewWithTag:11];//折后金额
    
    NSString *price = [self getTextFromView:self.view withTag:6];//单价
    NSString *qty = [self getTextFromView:self.view withTag:7];//数量
    
    //    NSString *str9 = [self getTextFromView:self.view withTag:9];
    //    NSString *str10 = [self getTextFromView:self.view withTag:10];
    //    NSString *str11 = [self getTextFromView:self.view withTag:11];
    
    if(txtTag == 10){
        
        CGFloat dicount = [self.toBeString floatValue] / [price floatValue] * 100;
        
        if (dicount > 10000) {
            dicount = 10000;
            priText.text = [NSString stringWithFormat:@"%0.2f",[price floatValue] * dicount / 100];
        }
        
        disText.text = [NSString stringWithFormat:@"%0.2f",dicount];
        amtText.text = [NSString stringWithFormat:@"%0.2f",[priText.text floatValue] * [qty floatValue]];
        
    }else if(txtTag == 11) {
        if([qty isEqualToString:@"0"]){
            amtText.text = @"0";
        }else{
            CGFloat dicount = [self.toBeString floatValue] / [qty floatValue] / [price floatValue] * 100;
            
            if (dicount > 10000) {
                dicount = 10000;
                amtText.text = [NSString stringWithFormat:@"%0.2f",[price floatValue] * dicount * [qty floatValue] / 100];
            }
            //NSLog(@"%@--",amtText.text);
            //NSLog(@"%@--11",[NSString stringWithFormat:@"%0.2f",[amtText.text floatValue]]);
            
            
            priText.text = [NSString stringWithFormat:@"%0.2f",[price floatValue] * dicount / 100];
            
            disText.text = [NSString stringWithFormat:@"%0.2f",dicount];
            
            //        disText.text = [NSString stringWithFormat:@"%0.2f",[priText.text floatValue] * 100 / [price floatValue]];
        }
        
        
    }else{
        // fix
        if ([disText.text floatValue] > 10000) {
            disText.text = @"10000";
        }
        priText.text = [NSString stringWithFormat:@"%0.2f",[price floatValue] *  [disText.text floatValue] / 100];
        amtText.text = [NSString stringWithFormat:@"%0.2f",[priText.text floatValue] * [qty floatValue]];
        
    }
    
    
    
}
*/

// add methods
- (void)updateMsg
{
    [self setText:[self.cpInfo strForKey:@"单位名称"] forView:self.view withTag:3];
    [self setText:[self.cpInfo strForKey:@"条码"] forView:self.view withTag:8];
    [self updatePrice];
    
    [self compute];
}

- (void)updatePrice
{
    // add 20150213
    NSString *price = [self getTextFromView:self.view withTag:6];
    self.textField = (UITextField *)[self.view viewWithTag:6];
    self.textField.text = [NSString stringWithFormat:@"%0.2f", [price doubleValue] * ([[self.cpInfo objectForKey:@"单位换算率"] doubleValue] / [self.oldValue doubleValue])];
}

-(void)compute{
    
    NSString *str6 = [self getTextFromView:self.view withTag:6];
    NSString *str7 = [self getTextFromView:self.view withTag:7];
    NSString *str9 = [self getTextFromView:self.view withTag:9];
    
    if ([str6 isEqualToString:@""]) {
        str6 = @"0";
    }
    if ([str9 isEqualToString:@""]) {
        str9 = @"0";
    }
    
    NSString *disPrice = [NSString stringWithFormat:@"%f", [str6 doubleValue] * [str9 doubleValue] / 100];
    NSString *disTotal =  [NSString stringWithFormat:@"%f", [disPrice doubleValue] * [str7 doubleValue]];
    
    [self setText:[NSString stringWithFormat:@"%0.2f",[disPrice doubleValue]] forView:self.view withTag:10];
    [self setText:[NSString stringWithFormat:@"%0.2f",[disTotal doubleValue]] forView:self.view withTag:11];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *basePrice = [NSString stringWithFormat:@"%f", [[self getTextFromView:self.view withTag:6] doubleValue]];
    
    // 区分BS 折扣最大100
    if ([self.setting intForKey:@"ISBS"] == 1) {
        
        if (textField.tag == 6 || textField.tag == 7) {
            [self compute];
        }
        if (textField.tag == 9) {
            if ([textField.text doubleValue] > 100) {
                textField.text = @"100";
                
            }
            [self compute];
        }
        if (textField.tag == 10) {
            NSString *discount = [NSString stringWithFormat:@"%0.2f", [textField.text doubleValue] /  [basePrice doubleValue] * 100];
            if ([discount doubleValue] > 100){
                textField.text = self.oldValue;
            }else if ([basePrice doubleValue] == 0)
            {
                [self setText:@"0" forView:self.view withTag:9];
            }
            else
            {
                [self setText:[NSString stringWithFormat:@"%0.2f",[discount doubleValue]] forView:self.view withTag:9];
            }
            [self compute];
        }
        
        if (textField.tag == 11) {
            NSString *disPrice = [NSString stringWithFormat:@"%f", [textField.text doubleValue] / [[self getTextFromView:self.view withTag:7] doubleValue]];
            //        CGFloat discount = disPrice  / [[self getTextFromView:self.view withTag:9] floatValue] * 100.0;
            NSString *discount = [NSString stringWithFormat:@"%0.2f", [disPrice doubleValue]  / [basePrice doubleValue] * 100.0];
            
            if ([discount doubleValue] > 100)
            {
                [self setText:@"100" forView:self.view withTag:9];
                [self compute];
            }else if ([basePrice doubleValue] == 0)
            {
                [self setText:@"0" forView:self.view withTag:9];
            }
            else{
                [self setText:[NSString stringWithFormat:@"%0.2f",[disPrice doubleValue]] forView:self.view withTag:10];
                [self setText:[NSString stringWithFormat:@"%0.2f",[discount doubleValue]] forView:self.view withTag:9];
            }
        }
    }else
    {
        
        if (textField.tag == 6 || textField.tag == 7) {
            [self compute];
        }
        if (textField.tag == 9) {
            if ([textField.text doubleValue] > 10000) {
                textField.text = @"10000";
                
            }
            [self compute];
        }
        if (textField.tag == 10) {
            NSString *discount = [NSString stringWithFormat:@"%0.2f", [textField.text doubleValue] /  [basePrice doubleValue] * 100];
            if ([discount doubleValue] > 10000){
                textField.text = self.oldValue;
            }else if ([basePrice doubleValue] == 0)
            {
                [self setText:@"0" forView:self.view withTag:9];
            }
            else
            {
                [self setText:[NSString stringWithFormat:@"%0.2f",[discount doubleValue]] forView:self.view withTag:9];
            }
            [self compute];
        }
        
        if (textField.tag == 11) {
            NSString *disPrice = [NSString stringWithFormat:@"%f", [textField.text doubleValue] / [[self getTextFromView:self.view withTag:7] doubleValue]];
            //        CGFloat discount = disPrice  / [[self getTextFromView:self.view withTag:9] floatValue] * 100.0;
            NSString *discount = [NSString  stringWithFormat:@"%0.2f", [disPrice doubleValue]  / [basePrice doubleValue] * 100.0];
            
            if ([discount doubleValue] > 10000)
            {
                [self setText:@"10000" forView:self.view withTag:9];
                [self compute];
            }else if ([basePrice doubleValue] == 0)
            {
                [self setText:@"0" forView:self.view withTag:9];
            }
            else{
                [self setText:[NSString stringWithFormat:@"%0.2f",[disPrice doubleValue]] forView:self.view withTag:10];
                [self setText:[NSString stringWithFormat:@"%0.2f",[discount doubleValue]] forView:self.view withTag:9];
            }
        }
        
    }

}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString *str11 = [self getTextFromView:self.view withTag:11];
    NSArray *rs = [str11 componentsSeparatedByString:@"."];
    if ([rs count] > 1) {
        if ([[rs objectAtIndex:0] length]> 8 | [[rs objectAtIndex:1] length]>2) {
            [self.view makeToast:@"折后金额过大"];
//            [self ShowMessage:@"折后金额过大"];
//            return NO;
        }
    }else{
        if ([[rs objectAtIndex:0] length]> 8 ) {
            [self.view makeToast:@"折后金额过大"];
//            [self ShowMessage:@"折后金额过大"];
//            return NO;
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.oldValue = textField.text;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    // fixBug 输入判断
    
    //得到输入框的内容
    self.toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
//    // add 所以录入数据都不能超过10位
//    if ([toBeString length] > 10) {
//        return NO;
//    }
    
    if (textField.tag == 12) {
        return YES;
    }else{
        /*
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        
        if (![string isEqualToString:filtered]) {
            [self ShowMessage:@"请输入正确数字"];
            return NO;
        }
        */
        
//        if (textField.tag == 6) {    //单价输入框
//            if ([toBeString length] > 10) {
//                return NO;
//            }
//        }
        
        
    }
    
//    //折扣计算与控制：单价，数量，折扣，折后金额
//    if (textField.tag == 6 || textField.tag == 7 || textField.tag == 9 || textField.tag == 11){
//        [self compute:textField.tag tobe:toBeString];
//        
//        if (textField.tag == 11) {    //折后金额
//            if ([toBeString floatValue] > [[self getTextFromView:self.view withTag:6] floatValue] * 10000) {
//                return NO;
//            }
//        }
//    }

    
    
    
/*
    
    if ([string isEqualToString:filtered] && (textField.tag != 12 || textField.tag != 13)) {
        
        NSString *newString = [NSString stringWithFormat:@"%@%@",textField.text,string];
        NSString *str6 = [self getTextFromView:self.view withTag:6];
        // fix 单价可编辑
//        if (textField.tag == 6) {
//            return [str6 floatValue] == 0;
//        }
        
        if (textField.tag == 9){
//            CGFloat discount = [newString floatValue];
//            if (discount < 0 || discount > 10000) {
//                NSLog(@"折扣不在范围内");
            
                return YES;
//            }
        }
        if (textField.tag == 10) {
//            CGFloat discount =  [newString floatValue] * 100 / [str6 floatValue];
//            if (discount < 0 || discount > 10000) {
            
//                UITextField *textField1 = (UITextField *)[self.view viewWithTag:9];
//                textField1.text = @"10000";
//                textField1.enabled = NO;
//                NSLog(@"折扣不在范围内");
                return YES;

//            }
        }
        
        if (textField.tag == 11) {
//            NSString *str6 = [self getTextFromView:self.view withTag:6];
//            NSString *str7 = [self getTextFromView:self.view withTag:7];
            
//            CGFloat disPrice = [newString floatValue] / [str7 floatValue];
//            CGFloat discount = disPrice * 100 / [str6 floatValue];
//            if (discount < 0 || discount > 10000) {
//                
//                UITextField *textField1 = (UITextField *)[self.view viewWithTag:9];
//                textField1.text = @"10000";
//                textField1.enabled = NO;
//                NSLog(@"折扣不在范围内");
                return YES;

//            }
        }
    }
    else
    {
        [self ShowMessage:@"请输入正确数字"];
        return NO;
    }
    
*/
    
    return YES;
    
}

//hgg 20150312 点击键盘return后判断是否为数字，修改填入正确数值后依然弹出提示
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *string = textField.text;
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    
    if (![string isEqualToString:filtered]) {
        [self ShowMessage:@"请输入正确数字"];
        return NO;
    }
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidChange:(id)info{
//    UITextField *textField = (UITextField *)info;
//    [self compute:textField.tag tobe:self.toBeString];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 3) {
        UnitViewController *vc = (UnitViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"UnitViewController"];
        vc.productInfo = self.cpInfo;
        vc.parentVC = self;
        self.oldValue = [self.cpInfo objectForKey:@"单位换算率"];
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    
    return YES;
}
- (IBAction)comfirmClick:(id)sender {
//    NSArray *indexs = @[@"4",@"3",@"9",@"5",@"6",@"16",@"18",@"11",@"19",@"20",@"21",@"22"];
    
    NSString *str11 = [self getTextFromView:self.view withTag:11];
    NSArray *rs = [str11 componentsSeparatedByString:@"."];
    if ([rs count] > 1) {
        if ([[rs objectAtIndex:0] length]> 12 | [[rs objectAtIndex:1] length]>2) {
            [self ShowMessage:@"折后金额过大"];
            return;
        }
    }else{
        if ([[rs objectAtIndex:0] length]> 12 ) {
            [self ShowMessage:@"折后金额过大"];
            return;
        }
    }
    
    // add textField respond
    for (int i = 6; i < 13; i ++) {
        self.textField = (UITextField *)[self.view viewWithTag:i];
        [self.textField resignFirstResponder];
    }
    for (int i = 6; i < 11; i ++) {
        if (i != 8) {
            self.textField = (UITextField *)[self.view viewWithTag:i];
            NSString *str = [NSString stringWithString:self.textField.text];
            for (int j = 0; j < str.length; j++) {
                NSString *subStr = [str substringWithRange:NSMakeRange(j, 1)];
                if ([subStr isEqualToString:@"."]) {
                    NSString *pointStr = [str substringFromIndex:j];
                    if (pointStr.length > 3) {
                        [self ShowMessage:@"小数位数不能超过两位"];
                        return;
                    }
                }
            }
            if ([self.textField.text doubleValue] >= 1000000000) {
                [self ShowMessage:@"整数位数不能超过9位"];
                return;
            }
        }
        
    }
    
//    [textField respondsToSelector:@selector(textFieldDidEndEditing:)];
    
    NSArray *indexs = @[@"名称",@"商品编码",@"单位名称",@"型号",@"规格",@"单价",@"数量",@"条码",@"折扣",@"折后单价",@"折后金额",@"备注"];
    for (int i = 1 ; i < 13 ; i ++){
        NSString *value = [self getTextFromView:self.view withTag:i];
        [self.cpInfo setObject:value forKey:[indexs objectAtIndex:i - 1]];
    }
    
    //基本单位数量
    NSInteger cot = [self.cpInfo intForKey:@"数量"] * [self.cpInfo intForKey:@"单位换算率"];
    [self.cpInfo setObject:[NSString stringWithFormat:@"%d",cot] forKey:@"基本单位数量"];
    //金额
    float total = [self.cpInfo intForKey:@"数量"] * [self.cpInfo floatForKey:@"单价"];
    [self.cpInfo setObject:[NSString stringWithFormat:@"%0.2f",total] forKey:@"金额"];
    //含税金额 用 折后金额  计算，税率为0则一样
    [self.cpInfo setObject:[self.cpInfo objectForKey:@"折后金额"] forKey:@"含税金额"];
    
    //含税单价 用 折后单价  计算，税率为0则一样
    [self.cpInfo setObject:[self.cpInfo objectForKey:@"折后单价"] forKey:@"含税单价"];
    
    RCCheckButton *button = (RCCheckButton *)[self.view viewWithTag:13];
    NSString *ch =  [[NSNumber numberWithBool:button.choose] stringValue];
    [self.cpInfo setObject:ch forKey:@"赠品"];
    

    [self.result replaceObjectAtIndex:self.selectIndex withObject:self.cpInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.parentVC performSelector:@selector(loadData) withObject:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.unitInfo = nil;
    self.priceInfo = nil;
    self.cpInfo = nil;
    self.oldValue = nil;
    [_scrollView release];
    [_moreButton release];
    [super dealloc];
}

@end
