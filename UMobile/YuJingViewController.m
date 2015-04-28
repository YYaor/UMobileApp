//
//  YuJingViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/9.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "YuJingViewController.h"

@interface YuJingViewController ()

@end

@implementation YuJingViewController

@synthesize buttons;

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
    
    // [NSString stringWithFormat:@"%@?UID=%@&Call=0&Param=1",MainUrl,@"119"];
    [self loadButtons];
    [self initializeButtons];
    
    //    [self SetContextButtons];
    // Do any additional setup after loading the view.
}

// add methods  20150129
- (void)initializeButtons
{
    NSArray *array = @[[NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"商品保质期报警",@"Action": @"buttonClick:",@"Image":@"warn0",@"Function":@"7",@"RightName":@"商品保质期报警"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"库存上限报警",@"Action": @"buttonClick:",@"Image":@"warn1",@"Function":@"1",@"RightName":@"库存上限报警"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"库存下限报警",@"Action": @"buttonClick:",@"Image":@"warn2",@"Function":@"2",@"RightName":@"库存下限报警"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"负库存报警",@"Action": @"buttonClick:",@"Image":@"warn3",@"Function":@"9",@"RightName":@"负库存报警"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"超期应付款",@"Action": @"buttonClick:",@"Image":@"warn4",@"Function":@"3",@"RightName":@"超期应付款查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"超期应收款",@"Action": @"buttonClick:",@"Image":@"warn5",@"Function":@"4",@"RightName":@"超期应收款查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"过生日会员查询",@"Action": @"buttonClick:",@"Image":@"warn6",@"Function":@"8",@"RightName":@"过生日会员查询"}],
                       
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"进货订单",@"Action": @"buttonClick:",@"Image":@"warn7",@"Function":@"5",@"RightName":@"订单报警"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"销售订单",@"Action": @"buttonClick:",@"Image":@"warn8",@"Function":@"6",@"RightName":@"订单报警"}]
                     ];
    
    if([@"1" isEqual:[[self setting] objectForKey:@"ISBS"]]){   //区分BS帐套
        array = @[[NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"商品保质期报警",@"Action": @"buttonClick:",@"Image":@"warn0",@"Function":@"7",@"RightName":@"商品保质期报警"}],
                           [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"库存上限报警",@"Action": @"buttonClick:",@"Image":@"warn1",@"Function":@"1",@"RightName":@"库存上限报警"}],
                           [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"库存下限报警",@"Action": @"buttonClick:",@"Image":@"warn2",@"Function":@"2",@"RightName":@"库存下限报警"}],
                           [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"负库存预警",@"Action": @"buttonClick:",@"Image":@"warn3",@"Function":@"9",@"RightName":@"负库存报警"}],
                           [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"超期应付款",@"Action": @"buttonClick:",@"Image":@"warn4",@"Function":@"3",@"RightName":@"超期应付款查询"}],
                           [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"超期应收款",@"Action": @"buttonClick:",@"Image":@"warn5",@"Function":@"4",@"RightName":@"超期应收款查询"}],
                           [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"过生日会员查询",@"Action": @"buttonClick:",@"Image":@"warn6",@"Function":@"8",@"RightName":@"过生日会员查询"}],
                  
                           [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"进货订单",@"Action": @"buttonClick:",@"Image":@"warn7",@"Function":@"5",@"RightName":@"进货订单报警"}],
                           [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"销售订单",@"Action": @"buttonClick:",@"Image":@"warn8",@"Function":@"6",@"RightName":@"销售订单报警"}]
                           
                           ];
        
    }
    
    
    self.buttons  =  [NSMutableArray arrayWithArray:array];
//    [self SetContextButtons];
    // Do any additional setup after loading the view.
}

-(void)loadButtons{
    __block YuJingViewController *tempSelf = self;
    //NSString *link = [self GetLinkWithFunction:0 andParam:[NSString stringWithFormat:@"1,'%@'",[self GetSystemDate]]];
    NSString *link = [self GetLinkWithFunction:0 andParam:[NSString stringWithFormat:@"'%@','%@'",[[self setting] objectForKey:@"UID"],[self GetCurrentDate]]];
    
    [self StartQuery:link completeBlock:^(id obj) {
        NSDictionary *dic =  [obj objectFromJSONString];
        NSArray *result = [dic objectForKey:@"D_Data"];
        
        for (NSArray *rs in result){
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@" Name = %@", [rs objectAtIndex:0]];
            NSArray *filterArr = [self.buttons filteredArrayUsingPredicate:predicate];
            if([filterArr count] > 0){
                NSMutableDictionary *resultDic = [filterArr objectAtIndex:0];
                [resultDic setObject:[rs objectAtIndex:1] forKey:@"Number"];
            }
        }
        [tempSelf SetContextButtons];
    } lock:YES];
}

-(void)buttonClick:(UIButton *)sender{

    NSDictionary *buttonInfo =  [self.buttons objectAtIndex:sender.tag - 1];
    
    if (![self checkRight:[buttonInfo strForKey:@"RightName"]]) {
        [self.view makeToast:@"没有权限"];
        return;
    }
    
    if ([buttonInfo intForKey:@"Function"] == 5 || [buttonInfo intForKey:@"Function"] == 6) {
        YuJingOrderViewController *vc = (YuJingOrderViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"YuJingOrderViewController"];
        vc.navItem.title = [buttonInfo strForKey:@"Name"];
        vc.callFunction = [[buttonInfo strForKey:@"Function"] integerValue];
        vc.yjType = vc.callFunction;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        YuJingDtlViewController *vc = (YuJingDtlViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"YuJingDtlViewController"];
        vc.navItem.title = [buttonInfo strForKey:@"Name"];
        vc.callFunction = [[buttonInfo strForKey:@"Function"] integerValue];
        vc.yjType = vc.callFunction;
        [self.navigationController pushViewController:vc animated:YES];
    }

}


-(void)SetContextButtons{
    CGSize cSize = CGSizeMake(85, 95);
    CGFloat offset = 12 ;
    
    NSUInteger col = 1;
    NSUInteger row = 1;
    for (int  i = 1 ; i < [self.buttons count] +1 ; i ++){
        NSDictionary *dic = self.buttons[i - 1];
        
        
        SEL action = NSSelectorFromString([dic strForKey:@"Action"]);
        NSString *img = [dic strForKey:@"Image"];
        NSString *name = [dic strForKey:@"Name"];
        NSString *num = [dic strForKey:@"Number"];
        

        CGFloat x = 20 + (85 + offset) * (col - 1) ;
        CGFloat y = ((95 + offset) * (row - 1)) ;
        
        RCImageButton *button = (RCImageButton *)[self.view viewWithTag:i];
        if (!button){
            button = [[RCImageButton alloc]initWithFrame:CGRectMake(x , (y + 66), cSize.width, cSize.height)];
            [self.view addSubview:button];
            if ([self canPerformAction:action withSender:self]) {
                [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        
        if (++ col > 3) {
            row ++;
            col = 1;
        }
        if (row > 7) {
            row = 1;
            col = 1;
        }
        
        //        [button setTitle:[dic strForKey:@"Name"] forState:UIControlStateNormal];
        button.tag = i;
        [button setButtonTag:i];
        [button setImgName:img];
        [button setName:name];
        [button setNum:num];
        
//        [self.view addSubview:button];
//        if ([self canPerformAction:action withSender:self]) {
//            [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//        }
    }
    
}
- (IBAction)refreshClick:(id)sender {
    [self.buttons removeAllObjects];
    [self initializeButtons];
    [self loadButtons];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setNavigationShow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.buttons = nil;
    [super dealloc];
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
