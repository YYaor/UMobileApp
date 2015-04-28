//
//  YuJingDDViewController.m
//  UMobile
//
//  报警详情
//
//  Created by 陈 景云 on 14-11-9.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "YuJingDDViewController.h"

@interface YuJingDDViewController ()

@end

@implementation YuJingDDViewController
@synthesize info;
@synthesize type;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [@[@"95",@"80",@"205"][indexPath.section] floatValue];//调节cell高度
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identify = [NSString stringWithFormat:@"Cell%d",indexPath.section + 1];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
//    if (indexPath.section == 0) {
//        [self setText:[self.info objectAtIndex:0] forView:cell withTag:1];
//        [self setText:[self.info objectAtIndex:1] forView:cell withTag:2];
//        [self setText:[self.info objectAtIndex:2] forView:cell withTag:3];
//    }else if (indexPath.section == 1){
//        [self setText:[self.info objectAtIndex:3] forView:cell withTag:4];
//        [self setText:[self.info objectAtIndex:4] forView:cell withTag:5];
//    }else{
//        [self setText:[self.info objectAtIndex:5] forView:cell withTag:6];
//        [self setText:[self.info objectAtIndex:6] forView:cell withTag:7];
//        [self setText:[self.info objectAtIndex:7] forView:cell withTag:8];
//        [self setText:[self.info objectAtIndex:8] forView:cell withTag:9];
//        [self setText:[self.info objectAtIndex:9] forView:cell withTag:10];
//        [self setText:[self.info objectAtIndex:10] forView:cell withTag:11];
//        [self setText:[self.info objectAtIndex:11] forView:cell withTag:12];
//        [self setText:[self.info objectAtIndex:12] forView:cell withTag:13];
//    }
    if (indexPath.section == 0){
        NSString *nt = self.type == 3?@"供应商:":@"客户:";
        NSString *nt1 = self.type == 3?@"供应商信息":@"客户信息";
        [self setText:nt forView:cell withTag:999];
        [self setText:nt1 forView:cell withTag:9991];
    }
    /*
    for (int i = 0 ; i < 13 ; i ++){
        [self setText:[self.info objectAtIndex:i] forView:cell withTag:i + 1];
    }
    */
    for (int i = 0 ; i < 14 ; i ++){
        [self setText:[self.info objectAtIndex:i] forView:cell withTag:i+1];
    }
    
    if (self.type != 3) {
        NSArray *arr = @[@"应收期限:",@"应收额:",@"已收额:",@"欠收额:",@"收款期限:"];
        for (int i = 91 ; i < 96 ; i ++){
            [self setText:[arr objectAtIndex:i - 91] forView:cell withTag:i];
        }
    }

    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 3 || self.type == 4) {
        
//    }else
//    {
        if (indexPath.section == 0) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            NSArray *menus = @[
                               [KxMenuItem menuItem:@"拨打电话" image:[UIImage imageNamed:@"guhua"] target:self action:@selector(cell0InfoClick:)],
                               [KxMenuItem menuItem:@"发送短信" image:[UIImage imageNamed:@"popup_icon_msg"] target:self action:@selector(cell0InfoClick:)],
                               ];
            [KxMenu showMenuInView:self.view fromRect:cell.frame menuItems:menus];
        }else if(indexPath.section == 1){
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            NSArray *menus = @[
                               [KxMenuItem menuItem:@"拨打电话" image:[UIImage imageNamed:@"guhua"] target:self action:@selector(cell1InfoClick:)],
                               [KxMenuItem menuItem:@"拨打手机" image:[UIImage imageNamed:@"popup_icon_phone"] target:self action:@selector(cell1InfoClick:)],
                               [KxMenuItem menuItem:@"发送短信" image:[UIImage imageNamed:@"popup_icon_msg"] target:self action:@selector(cell1InfoClick:)],
                               ];
            [KxMenu showMenuInView:self.view fromRect:cell.frame menuItems:menus];
        }
    }
    
}

-(void)cell0InfoClick:(KxMenuItem *)item{
    NSDictionary *dic =@{@"拨打电话":@"1",@"拨打手机":@"2",@"发送短信":@"3"};
    switch ([dic intForKey:item.title]) {
        case 1:
            [self callANumber:[self.info objectAtIndex:2]];
            break;
        case 2:
            [self callANumber:[self.info objectAtIndex:2]];
            break;
        case 3:
            [self sendToNumber:[self.info objectAtIndex:2]];
            break;
        default:
            break;
    }
}

-(void)cell1InfoClick:(KxMenuItem *)item{
    NSDictionary *dic =@{@"拨打电话":@"1",@"拨打手机":@"2",@"发送短信":@"3"};
    switch ([dic intForKey:item.title]) {
        case 1:
            [self callANumber:[self.info objectAtIndex:4]];
            break;
        case 2:
            [self callANumber:[self.info objectAtIndex:13]];
            break;
        case 3:
            [self sendToNumber:[self.info objectAtIndex:13]];
            break;
        default:
            break;
    }
}

// 打开注释     20150129

//弹出拨打电话，发送短信
- (IBAction)addClick1:(id)sender {
    NSArray *menus = @[
                       [KxMenuItem menuItem:@"拨打电话" image:[UIImage imageNamed:@"popup_icon_phone"] target:self action:@selector(phoneClick1:)],
                       [KxMenuItem menuItem:@"发送短信" image:[UIImage imageNamed:@"popup_icon_msg"] target:self action:@selector(msgClick1:)],
                       ];
    [KxMenu showMenuInView:self.view fromRect:CGRectMake(60, 150, 10, 1) menuItems:menus];
}

//弹出拨打电话，发送短信
- (IBAction)addClick2:(id)sender {
    NSArray *menus = @[
                       [KxMenuItem menuItem:@"拨打电话" image:[UIImage imageNamed:@"popup_icon_phone"] target:self action:@selector(phoneClick2:)],
                       [KxMenuItem menuItem:@"发送短信" image:[UIImage imageNamed:@"popup_icon_msg"] target:self action:@selector(msgClick2:)],
                       ];
    [KxMenu showMenuInView:self.view fromRect:CGRectMake(60, 235, 10, 1) menuItems:menus];
}

//拨打电话1
-(void)phoneClick1:(id)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[self.info objectAtIndex:2]];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    [callWebview release];
    [str release];
}

//发送短信1
-(void)msgClick1:(id)sender{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"sms://%@",[self.info objectAtIndex:2]]]];
    
}

//拨打电话2
-(void)phoneClick2:(id)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[self.info objectAtIndex:4]];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    [callWebview release];
    [str release];
}

//发送短信2
-(void)msgClick2:(id)sender{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"sms://%@",[self.info objectAtIndex:4]]]];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dealloc{
    self.info = nil;
    [_tableView release];
    [super dealloc];
}

@end
