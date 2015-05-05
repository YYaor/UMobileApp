//
//  MainViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/2.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self setNavigationShow];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(1, 800);
    

}

- (IBAction)settingClick:(id)sender {
    
    UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    CATransition *animation = [CATransition animation];
    
    [animation setDuration:0.3];
    
    [animation setType: kCATransitionMoveIn];
    
    [animation setSubtype: kCATransitionFromTop];
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    
    [self.navigationController pushViewController:vc animated:NO];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    __block MainViewController *tempSelf = self;
    
    //获取业务权限
    if ([self.setting intForKey:@"Demo"] == 0) {    //非演示
        [self StartQuery:[self GetLinkWithFunction:81 andParam:[self GetUserID]] completeBlock:^(id obj) {
            [tempSelf GetOM].rights = [[obj objectFromJSONString] objectForKey:@"D_Data"];
            
            /*
            for (NSArray * arr in [tempSelf GetOM].rights){
                if ([@"允许选择价格类型" isEqualToString:[arr objectAtIndex:3]]){
                    NSLog(@"%@",[arr objectAtIndex:3]);
                }
                
            }
            */
            
            //获取用户模块操作权限，调整功能模块布局
            [tempSelf setPageMode:nil];
            [tempSelf GetTime];
        } lock:YES];
    }

    self.buttons = @[@{@"Name": @"审核",@"Image":@"shenpi",@"Action":@"shClick:",@"Type":@"0"},
                     @{@"Name": @"预警",@"Image":@"yujing",@"Action":@"yjClick:",@"Type":@"0"},
                     @{@"Name": @"排行榜",@"Image":@"paihangbang",@"Action":@"phbClick:",@"Type":@"0"},
                     @{@"Name": @"报表中心",@"Image":@"baobiaozhongxin",@"Action":@"bbzxClick:",@"Type":@"0"},
                     @{@"Name": @"往来单位管理",@"Image":@"kehuguanli",@"Action":@"khglClick:",@"Type":@"0"},
                     @{@"Name": @"商品管理",@"Image":@"shangpinguanli",@"Action":@"spglClick:",@"Type":@"0"},
                     @{@"Name": @"订单管理",@"Image":@"dingdanguanli",@"Action":@"ddglClick:",@"Type":@"0"},
                     @{@"Name": @"日报",@"Image":@"ribao",@"Action":@"ribaoClick:",@"Type":@"1"},
                     @{@"Name": @"实时库存查询",@"Image":@"shishikucunchaxun",@"Action":@"sskcClick:",@"Type":@"0"},
                     @{@"Name": @"销售明细查询",@"Image":@"xiaoshoumingxichaxun",@"Action":@"xsmxClick:",@"Type":@"1"},
                     @{@"Name": @"业务单据查询",@"Image":@"yewudanjuchaxun",@"Action":@"ywdjClick:",@"Type":@"0"}
                     ];
    [self setButtonActions];
    
}

-(void)GetTime{
    __block MainViewController *tempSelf = self;
    if ([self.setting intForKey:@"Demo"] == 0) {    //非演示
        [self StartQuery:[self GetLinkWithFunction:777 andParam:@""] completeBlock:^(id obj) {
            NSDictionary *dic = [obj objectFromJSONString];
            tempSelf.navigationItem.title = [NSString stringWithFormat:@"到期时间:%@",[dic strForKey:@"LastTime"]];
        } lock:NO];
    }
}

-(void)setButtonActions{
    for (int i =  1 ;  i < [self.buttons count]+1 ; i ++){
        NSDictionary *info = [self.buttons objectAtIndex:i - 1];
        NSString *strAction = [info strForKey:@"Action"];
        UIImageView *imageView = (UIImageView *) [self.scrollView viewWithTag:i];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc]initWithTarget:self action:NSSelectorFromString(strAction)] autorelease];
        recognizer.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:recognizer];
    }
}

-(void)setButtonEnable{
    if ([[self GetOM].rightsMode count] == 0) {
        return;
    }
    for (int i =  1 ;  i < 9 ; i ++){
        UIImageView *imageView = (UIImageView *) [self.scrollView viewWithTag:i];
        if (![[[self GetOM].rightsMode objectAtIndex:i] isEqualToString:@"True"]) {
            //不接受点击
            imageView.userInteractionEnabled = NO;
            //添加覆盖层
            CGRect rect = CGRectZero;
            rect.size = imageView.frame.size;
            UIView *v = [[[UIView alloc]initWithFrame:rect] autorelease];
            v.backgroundColor = [UIColor grayColor];
            v.alpha = 0.8;
            v.tag = 999;
            [imageView addSubview:v];
        }else{
            imageView.userInteractionEnabled = YES;
            [[imageView viewWithTag:999] removeFromSuperview];//移除覆盖层
        }

    }
    //设置按钮
    if (![[[self GetOM].rightsMode objectAtIndex:0] isEqualToString:@"True"]) {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }else{
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    }
}

-(void)SetContextButtons{
    CGSize cSize = CGSizeMake(155, 95);
    CGSize headSize = CGSizeMake(310, 95);
    CGFloat offset = 2 ;
    
    NSUInteger col = 1;
    NSUInteger row = 1;
    NSUInteger page = 1;
    
    CGFloat height = 0;
    
    for (int  i = 0 ; i < [self.buttons count] ; i ++){
        NSDictionary *dic = self.buttons[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        SEL action = NSSelectorFromString([dic strForKey:@"Action"]);
        UIImage *img = [UIImage imageNamed:[dic strForKey:@"Image"]];
        NSUInteger type = [[dic strForKey:@"Type"] integerValue];
        
        
        if (type == 1){
            button.frame = CGRectMake(4 , 0, headSize.width, headSize.height);
            row = 2;
        }else{
            CGFloat x = 4 + (155 + offset) * (col - 1) + ((page - 1) * 320 );
            CGFloat y = ((95 + offset) * (row - 1)) ;

            height = y + cSize.height;
            button.frame = CGRectMake(x , y, cSize.width, cSize.height);

            if (++ col > 2) {
                row ++;
                col = 1;
            }
            
            
        }
//        [button setTitle:[dic strForKey:@"Name"] forState:UIControlStateNormal];
        [button setImage:img forState:UIControlStateNormal];
        
//        [self.scView addSubview:button];
        if ([self canPerformAction:action withSender:self]) {
            [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
//    self.scView.contentSize = CGSizeMake(1, height);
}

- (IBAction)addClick:(id)sender {
    NSArray *menus = @[
                       [KxMenuItem menuItem:@"新建客户" image:[UIImage imageNamed:@"xjkh_image"] target:self action:@selector(xinjiankehuClick:)],
                       [KxMenuItem menuItem:@"新建订单" image:[UIImage imageNamed:@"xjdd_image"] target:self action:@selector(xinjiandingdanClick:)],
                       [KxMenuItem menuItem:@"条码查询" image:[UIImage imageNamed:@"tmcx_image"] target:self action:@selector(chaxunClick:)],
                       [KxMenuItem menuItem:@"业务单据" image:[UIImage imageNamed:@"tmcx_image"] target:self action:@selector(yewudanjuClick:)],
                       ];
    [KxMenu showMenuInView:self.view fromRect:CGRectMake(280, 64, 10, 1) menuItems:menus];
}



-(void)menuButtonClick:(UIButton *)sender{

}

#pragma mark -
#pragma mark menu action


-(void)chaxunClick:(id)sender{
    if ([[[self GetOM].rightsMode objectAtIndex:6] isEqualToString: @"False"]) {
        [self ShowMessage:@"该功能已禁用"];
    }else
    {
        UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"ScanViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)xinjiankehuClick:(id)sender{
    if ([[[self GetOM].rightsMode objectAtIndex:5] isEqualToString: @"False"]) {
        [self ShowMessage:@"该功能已禁用"];
    }else
    {
        UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"KHGLAddViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)xinjiandingdanClick:(id)sender{
    if ([[[self GetOM].rightsMode objectAtIndex:7] isEqualToString: @"False"]) {
        [self ShowMessage:@"该功能已禁用"];
    }else
    {
        UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"XinZenDingDanViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)yewudanjuClick:(id)sender{
    UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"YeWuDanJuViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark -
#pragma mark Action


-(void)yjClick:(id)sender{
    UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"YuJingViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)khglClick:(id)sender{
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"KHGLViewController"];
    
    // add 商品管理和往来单位的查看权限   0213
    NSString *str = @"往来单位";
    NSString *param = [NSString stringWithFormat:@"%d, '%@', 1",[[self GetUserID] intValue], str];
    NSString *link = [self GetLinkWithFunction:83 andParam:param];
    NSString *newLink = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self StartQuery:newLink completeBlock:^(id obj) {
        if (obj != nil) {
            NSString *string = [[[[obj objectFromJSONString] objectForKey:@"D_Data"] objectAtIndex:0] objectAtIndex:0];
            if ([string intValue] == 1) {
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                [self ShowMessage:@"没有查看权限"];
            }
        }else
        {
        }
    } lock:YES];
}

-(void)shClick:(id)sender{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShenHeViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)spglClick:(id)sender{
//    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SPGLViewController"];
//    [self.navigationController pushViewController:vc animated:YES];
    
    // wph 20150304
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SPGLViewController"];
    
    // add 商品管理和往来单位的查看权限   0213
    NSString *str = @"商品信息";
    NSString *param = [NSString stringWithFormat:@"%d, '%@', 1",[[self GetUserID] intValue], str];
    NSString *link = [self GetLinkWithFunction:83 andParam:param];
    NSString *newLink = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self StartQuery:newLink completeBlock:^(id obj) {
        if (obj != nil) {
            NSString *string = [[[[obj objectFromJSONString] objectForKey:@"D_Data"] firstObject] firstObject];
            NSLog(@"%@",[obj objectFromJSONString]);
            if ([string intValue] == 1) {
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                [self ShowMessage:@"没有查看权限"];
            }
        }else
        {
        }
        
    } lock:NO];
    
    
}

-(void)ribaoClick:(id)sender{
    UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"RBViewController"];
    [self.navigationController presentViewController:vc animated:YES completion:NULL];
}

-(void)phbClick:(id)sender{
    UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"PaiHangViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)bbzxClick:(id)sender{
    UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"BBZXViewController"];
    [self.navigationController presentViewController:vc animated:YES completion:NULL];
}

-(void)ddglClick:(id)sender{
    UIViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"DDCXViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)sskcClick:(id)sender{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SSKCViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)ywdjClick:(id)sender{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YWDJViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)xsmxClick:(id)sender{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"XSMXViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取用户权限，调整功能模块布局
-(void)setPageMode:(RCViewController *)vc{
    
    __block MainViewController *tempSelf = self;
    NSString *param = [NSString stringWithFormat:@"%@",[self GetUserID]];
    [self StartQuery:[self GetLinkWithFunction:85 andParam:param] completeBlock:^(id obj) {
        
        NSMutableArray *mode = [[[obj objectFromJSONString] objectForKey:@"D_Data"] firstObject];
        [tempSelf GetOM].rightsMode =  mode;//@[@"False",@"False",@"True",@"False",@"True",@"False",@"False",@"False",@"False"];
        
        //0业务设置,1审核,2预警,3排行榜,4报表中心,5客户管理,6商品管理,7订单查询,8日报,9移动禁用 True False
        if([[mode objectAtIndex:9] isEqualToString: @"True"]){//9移动禁用，退出
            [tempSelf makeToastInWindow:@"移动化应用已禁用"];
            [tempSelf.navigationController popToRootViewControllerAnimated:YES];
        }
        [tempSelf setButtonEnable];
        //设置按钮
        
    } lock:YES];
}

//- (NSString *)setScanMode:(NSString *)funString
//{
//    // add 商品管理和往来单位的查看权限   0213
//    NSString *param = [NSString stringWithFormat:@"%d, '%@', 1",[[self GetUserID] intValue], funString];
//    NSString *link = [self GetLinkWithFunction:83 andParam:param];
//    [self StartQuery:link completeBlock:^(id obj) {
//        NSDictionary *dic = [obj objectFromJSONString];
//        if ([[dic objectForKey:@"D_Data"] intValue] == 0) {
//        }
//    } lock:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_menu release];
    [_scrollView release];
    [super dealloc];
}

@end
