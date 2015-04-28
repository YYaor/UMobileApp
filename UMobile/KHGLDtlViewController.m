//
//  KHGLDtlViewController.m
//  UMobile
//
//  来往单位明细
//
//  Created by  APPLE on 2014/9/16.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "KHGLDtlViewController.h"

@interface KHGLDtlViewController ()

@end

@implementation KHGLDtlViewController

@synthesize result;

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
    self.navigationItem.title =  [self.result objectAtIndex:2];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark table view
//
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSArray *titles = @[@"基本信息",@"财务信息",@"收/发货地址"];
//    return titles[section];
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *titles = @[@"基本信息",@"财务信息",@"收/发货地址"];
    RCTableTitleView *titleView = [[[RCTableTitleView alloc]initWithFrame:CGRectMake(0, 0,tableView.frame.size.width, 20)] autorelease];
    [titleView setBackgroundImage:nil];
    [titleView setIcon:nil withText:titles[section]];
    return titleView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *heights =@[@"110",@"90",@"80"];
    return [heights[indexPath.section] floatValue];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;

    if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        [self setText:[self.result objectAtIndex:1] forView:cell withTag:1];
        [self setText:[self.result objectAtIndex:2] forView:cell withTag:2];
        [self setText:[self.result objectAtIndex:4] forView:cell withTag:3];
        [self setText:[self.result objectAtIndex:5] forView:cell withTag:4];
        [self setText:[self.result objectAtIndex:6] forView:cell withTag:5];
        [self setText:[self.result objectAtIndex:7] forView:cell withTag:6];
    }else if (indexPath.section == 1){  //财务信息
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        [self setText:[NSString stringWithFormat:@"%.2f",[[self.result objectAtIndex:8] doubleValue]] forView:cell withTag:7];
        [self setText:[NSString stringWithFormat:@"%.2f",[[self.result objectAtIndex:9] doubleValue]] forView:cell withTag:8];
        [self setText:[NSString stringWithFormat:@"%.2f",[[self.result objectAtIndex:10] doubleValue]] forView:cell withTag:9];
        
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3"];
        [self setText:[self.result objectAtIndex:11] forView:cell withTag:10];
        [self setText:[self.result objectAtIndex:12] forView:cell withTag:11];
        [self setText:[self.result objectAtIndex:13] forView:cell withTag:12];
        [self setText:[self.result objectAtIndex:14] forView:cell withTag:13];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSArray *menus = @[
                           [KxMenuItem menuItem:@"拨打电话" image:[UIImage imageNamed:@"guhua"] target:self action:@selector(basicInfoClick:)],
                           [KxMenuItem menuItem:@"拨打手机" image:[UIImage imageNamed:@"popup_icon_phone"] target:self action:@selector(basicInfoClick:)],
                           [KxMenuItem menuItem:@"发送短信" image:[UIImage imageNamed:@"popup_icon_msg"] target:self action:@selector(basicInfoClick:)],
                           ];
        [KxMenu showMenuInView:self.tableView fromRect:cell.frame menuItems:menus];
    }else if(indexPath.section == 2){
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSArray *menus = @[
                           [KxMenuItem menuItem:@"拨打电话" image:[UIImage imageNamed:@"guhua"] target:self action:@selector(addressInfoClick:)],
                           [KxMenuItem menuItem:@"拨打手机" image:[UIImage imageNamed:@"popup_icon_phone"] target:self action:@selector(addressInfoClick:)],
                           [KxMenuItem menuItem:@"发送短信" image:[UIImage imageNamed:@"popup_icon_msg"] target:self action:@selector(addressInfoClick:)],
                           ];
        [KxMenu showMenuInView:self.tableView fromRect:cell.frame menuItems:menus];
    }
}

-(void)basicInfoClick:(KxMenuItem *)item{
    NSDictionary *info =@{@"拨打电话":@"1",@"拨打手机":@"2",@"发送短信":@"3"};
    switch ([info intForKey:item.title]) {
        case 1:
            [self callANumber:[self.result objectAtIndex:5]];
            break;
        case 2:
            [self callANumber:[self.result objectAtIndex:6]];
            break;
        case 3:
            [self sendToNumber:[self.result objectAtIndex:6]];
            break;
        default:
            break;
    }
}

-(void)shareInfo:(NSString *)content{
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

-(void)addressInfoClick:(KxMenuItem *)item{
    NSDictionary *info =@{@"拨打电话":@"1",@"拨打手机":@"2",@"发送短信":@"3"};
    switch ([info intForKey:item.title]) {
        case 1:
            [self callANumber:[self.result objectAtIndex:13]];
            break;
        case 2:
            [self callANumber:[self.result objectAtIndex:14]];
            break;
        case 3:
            [self sendToNumber:[self.result objectAtIndex:14]];
            break;
        default:
            break;
    }
}

-(void)loadData{
    // add 20150211
    NSString *param = [NSString stringWithFormat:@"'%@'", [self.result objectAtIndex:0]];
    NSString *link = [self GetLinkWithFunction:87 andParam:param];
    __block KHGLDtlViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        NSString *obs = [NSString stringWithFormat:@"%@",obj];
        NSString *os = [NSString stringWithFormat:@"%@",[self encoardStringBeforeJson:obs]];
        NSArray *rs =  [[os objectFromJSONString] objectForKey:@"D_Data"];
        if (rs != nil) {
            NSMutableArray *rs1 = [NSMutableArray arrayWithArray:[rs objectAtIndex:0]];
//            [rs1 removeObjectAtIndex:0];
//            // 修改后的刷新，
//            NSMutableArray *resultArr = [NSMutableArray arrayWithObjects:[tempSelf.result objectAtIndex:0],[tempSelf.result objectAtIndex:24], nil];
//            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
//                                   NSMakeRange(1,[rs1 count])];
//            [resultArr insertObjects:rs1 atIndexes:indexes];
//
//            [rs1 addObject:[tempSelf.result objectAtIndex:24]];
//            [rs1 addObject:[tempSelf.result lastObject]];

//            tempSelf.result = rs1;
//            [self.tableView reloadData];
        }
    } lock:YES];
}


-(void)dealloc{
    self.result = nil;
    [_tableView release];
    [super dealloc];
}

- (IBAction)moreButtonClick:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择需要操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"下单",@"编辑",@"转发",@"关联订单",@"新增往来单位", nil];
    [sheet showInView:self.view];
}
- (IBAction)payClick:(id)sender {
    
    KHGLYSViewController *vc = (KHGLYSViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"KHGLYSViewController"];
    vc.strCode = [self.result objectAtIndex:0];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSMutableDictionary *allInfo =  [NSMutableDictionary dictionary];
        NSMutableArray *arr = nil;
        if ([[self.result objectAtIndex:3] isEqualToString:@"供应商"]) {
            arr = [NSMutableArray arrayWithObjects:@"5",@"进货订单", nil];
        }else{
            arr = [NSMutableArray arrayWithObjects:@"6",@"销售订单", nil];
        }

        [allInfo setObject:arr forKey:@"0"];
        NSMutableArray *arrDate = [NSMutableArray arrayWithObjects:@"0",[self GetCurrentDate], nil];
        [allInfo setObject:arrDate forKey:@"1"];
        
        NSMutableArray *arrC = [NSMutableArray arrayWithObjects:[self.result objectAtIndex:0],[self.result objectAtIndex:2],nil];
//        [allInfo setObject:arrC forKey:@"6"];
        if ([self.setting intForKey:@"ISBS"] == 1) {
            [allInfo setObject:arrC forKey:@"3"];
            NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:[self.result objectAtIndex:18],[self.result objectAtIndex:19],nil];
            NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:[self.result objectAtIndex:24],[self.result objectAtIndex:25],nil];
            [allInfo setObject:arr1 forKey:@"4"];
            [allInfo setObject:arr2 forKey:@"5"];
        }else{
            [allInfo setObject:arrC forKey:@"5"];
        }
        
        XinZenDingDanViewController *vc = (XinZenDingDanViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"XinZenDingDanViewController"];
        vc.headInfo = allInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (buttonIndex == 1){
        KHGLAddViewController *vc = (KHGLAddViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"KHGLAddViewController"];
        vc.cusInfo = self.result;
        vc.parentVC = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (buttonIndex == 2){
//        [self shareContent:@""];
        NSString *content = [NSString stringWithFormat:@"名称:%@\n联系人:%@\n手机:%@",
                             [self.result objectAtIndex:2],
                             [self.result objectAtIndex:4],
                             [self.result objectAtIndex:5]];
        [self performSelector:@selector(shareInfo:) withObject:content afterDelay:0.5];
//        [self shareInfo:content];
    }else if (buttonIndex == 3){
        DDGLViewController *vc = (DDGLViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DDGLViewController"];
        NSString *param = nil;//
        NSDictionary *dic = @{@"客户":@"6",@"供应商":@"5",@"两者皆是":@"0"};
        
        NSString *rs_t = [self.result objectAtIndex:1];
        if (rs_t == nil || [rs_t isEqualToString:@""]) {
            rs_t = @"0";   //by wph 20150313 接口中单据编码为0才能搜索出全部符合类型的数据
        }
        rs_t = @"";//20150317
        param = [NSString stringWithFormat:@"'','',%d,'%@',0,%d,0,2,%d",[[dic strForKey:[self.result objectAtIndex:3]] intValue],rs_t,[[self.result objectAtIndex:0] intValue],[[self GetUserID] intValue]];   //by wph 20150312
        vc.link = [self GetLinkWithFunction:72 andParam:param];
        vc.callFunction = [[dic strForKey:[self.result objectAtIndex:3]] integerValue];
        vc.param = param;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (buttonIndex == 4){
        KHGLAddViewController *vc = (KHGLAddViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"KHGLAddViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//弹出拨打电话，发送短信
- (IBAction)addClick:(id)sender {
//    NSArray *menus = @[
//                       [KxMenuItem menuItem:@"拨打电话" image:[UIImage imageNamed:@"guhua"] target:self action:@selector(telClick:)],
//                       [KxMenuItem menuItem:@"拨打手机" image:[UIImage imageNamed:@"popup_icon_phone"] target:self action:@selector(phoneClick:)],
//                       [KxMenuItem menuItem:@"发送短信" image:[UIImage imageNamed:@"popup_icon_msg"] target:self action:@selector(msgClick:)],
//                       ];
//    [KxMenu showMenuInView:self.view fromRect:CGRectMake(60, 180, 10, 1) menuItems:menus];
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

@end
