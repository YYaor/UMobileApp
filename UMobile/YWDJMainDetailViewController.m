//
//  YWDJMainDetailViewController.m
//  UMobile
//
//  Created by yunyao on 15/5/7.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "YWDJMainDetailViewController.h"
#import "KxMenu.h"
@interface YWDJMainDetailViewController ()

@end

@implementation YWDJMainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.danJuBianHaoLabel.text = [self.array objectAtIndex:5];
    self.DanJuRiQiLabel.text =[self.array objectAtIndex:4];
    self.changKuLabel.text =[self.array objectAtIndex:13];
    self.jinShouRenLabel.text = [self.array objectAtIndex:15];
    self.shuLianLabel.text = [self.array objectAtIndex:23];
    self.jingENeiRongLabel.text = [self.array objectAtIndex:16];
    self.shouKuanZhangHuLabel.text = [self.array objectAtIndex:21];
    self.shouKuanJingELabel.text = [self.array objectAtIndex:22];
    
    self.mingChengLabel.text = [self.array objectAtIndex:8];
    self.lianXiRenLabel.text = [self.array objectAtIndex:9];
    self.lianXiDianHua.text = [self.array objectAtIndex:10];
    self.shouJiHaoLabel.text = [self.array objectAtIndex:11];
    
    self.zhaiYaoLabel.text = [self.array objectAtIndex:18];
    self.fuJiaShuoMing.text = [self.array objectAtIndex:19];
    self.shouJiHaoLabel.userInteractionEnabled = YES;
    self.lianXiDianHua.userInteractionEnabled = YES;
    
    [self.shouJiHaoLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)]];
    [self.lianXiDianHua addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)]];
}

-(void)tapClick{
    NSArray *menus = @[
                       [KxMenuItem menuItem:@"拨打电话" image:[UIImage imageNamed:@"guhua"] target:self action:@selector(addressInfoClick:)],
                       [KxMenuItem menuItem:@"拨打手机" image:[UIImage imageNamed:@"popup_icon_phone"] target:self action:@selector(addressInfoClick:)],
                       [KxMenuItem menuItem:@"发送短信" image:[UIImage imageNamed:@"popup_icon_msg"] target:self action:@selector(addressInfoClick:)],
                       ];
    
    [KxMenu showMenuInView:self.view fromRect:CGRectMake(self.shouJiHaoLabel.frame.origin.x+10, self.shouJiHaoLabel.frame.origin.y+self.shouJiHaoLabel.frame.size.height+5, 100, 150) menuItems:menus];
}

-(void)addressInfoClick:(KxMenuItem *)item{
    NSDictionary *info =@{@"拨打电话":@"1",@"拨打手机":@"2",@"发送短信":@"3"};
    switch ([info intForKey:item.title]) {
        case 1:
            [self callANumber:self.lianXiDianHua.text];
            break;
        case 2:
            [self callANumber:self.shouJiHaoLabel.text];
            break;
        case 3:
            [self sendToNumber:self.shouJiHaoLabel.text];
            break;
        default:
            break;
    }
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

- (void)dealloc {
    [_danJuBianHaoLabel release];
    [_DanJuRiQiLabel release];
    [_changKuLabel release];
    [_jinShouRenLabel release];
    [_shuLianLabel release];
    [_jingENeiRongLabel release];
    [_shouKuanZhangHuLabel release];
    [_shouKuanJingELabel release];
    [_mingChengLabel release];
    [_lianXiRenLabel release];
    [_lianXiDianHua release];
    [_shouJiHaoLabel release];
    [_zhaiYaoLabel release];
    [_fuJiaShuoMing release];
    [super dealloc];
}
@end
