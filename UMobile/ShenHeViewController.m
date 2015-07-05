//
//  ShenHeViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/14.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "ShenHeViewController.h"

@interface ShenHeViewController ()

@end

@implementation ShenHeViewController

@synthesize buttons;
@synthesize types;

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
    
    NSArray *array = @[[NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"进货订单",@"Action": @"buttonClick:",@"Image":@"审核_49",@"Type":@"5",@"Style":@"0",@"SearchType":@"输入供应商/制单人查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"销售订单",@"Action": @"buttonClick:",@"Image":@"审核_11",@"Type":@"6",@"Style":@"1",@"SearchType":@"输入客户/制单人查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"进货单",@"Action": @"buttonClick:",@"Image":@"审核_15",@"Type":@"0",@"Style":@"0",@"SearchType":@"输入供应商/制单人查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"进货退货单",@"Action": @"buttonClick:",@"Image":@"审核_17",@"Type":@"3",@"Style":@"0",@"SearchType":@"输入供应商/制单人查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"进货换货单",@"Action": @"buttonClick:",@"Image":@"审核_26",@"Type":@"61",@"Style":@"0",@"SearchType":@"输入供应商/制单人查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"销售单",@"Action": @"buttonClick:",@"Image":@"审核_13",@"Type":@"1",@"Style":@"1",@"SearchType":@"输入客户/制单人查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"销售退货单",@"Action": @"buttonClick:",@"Image":@"审核_25",@"Type":@"4",@"Style":@"1",@"SearchType":@"输入客户/制单人查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"销售换货单",@"Action": @"buttonClick:",@"Image":@"审核_23",@"Type":@"14",@"Style":@"1",@"SearchType":@"输入客户/制单人查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"同价调拨单",@"Action": @"buttonClick:",@"Image":@"审核_32",@"Type":@"7",@"Style":@"999",@"SearchType":@"输入制单人查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"变价调拨单",@"Action": @"buttonClick:",@"Image":@"审核_32",@"Type":@"8",@"Style":@"999",@"SearchType":@"输入制单人查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"收款单",@"Action": @"buttonClick:",@"Image":@"审核_33",@"Type":@"101",@"Style":@"999",@"SearchType":@""}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"付款单",@"Action": @"buttonClick:",@"Image":@"审核_35",@"Type":@"100",@"Style":@"999",@"SearchType":@""}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"现金费用单",@"Action": @"buttonClick:",@"Image":@"审核_40",@"Type":@"102",@"Style":@"999",@"SearchType":@"输入制单人查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"一般费用单",@"Action": @"buttonClick:",@"Image":@"审核_24",@"Type":@"103",@"Style":@"999",@"SearchType":@""}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"预收款单",@"Action": @"buttonClick:",@"Image":@"审核_41",@"Type":@"128",@"Style":@"999",@"SearchType":@""}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"预付款单",@"Action": @"buttonClick:",@"Image":@"审核_42",@"Type":@"129",@"Style":@"999",@"SearchType":@""}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"其它收入单",@"Action": @"buttonClick:",@"Image":@"审核_34",@"Type":@"104",@"Style":@"999",@"SearchType":@""}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"转款单",@"Action": @"buttonClick:",@"Image":@"审核_44",@"Type":@"105",@"Style":@"999",@"SearchType":@"输入制单人查询"}]
                       ];
    
    //Type 为 对应 下级的callFunction 根据 此值取不同的显示内容
    self.buttons  =  [NSMutableArray arrayWithArray:array];
    
    
    [self loadButtons];
    // Do any additional setup after loading the view.
}
- (IBAction)refreshClick:(id)sender {
    [self loadButtons];
}

-(NSArray *)GetShenHeType:(NSString *)name{
    for (NSArray *rs in [self GetOM].shengheArr){
        if ([[rs objectAtIndex:1] isEqualToString:name]) {
            return rs;
        }
    }
    return nil;
}

-(void)loadButtons{
    __block ShenHeViewController *tempSelf = self;

    NSString *link = [self GetLinkWithFunction:74 andParam:
                      [NSString stringWithFormat:@"-1,4,'',%@,1",[[self setting] objectForKey:@"UID"]]];
    
    [self StartQuery:link completeBlock:^(id obj) {
        tempSelf.types =  [NSMutableDictionary dictionary];
        NSDictionary *dic =  [obj objectFromJSONString];
        NSArray *result = [dic objectForKey:@"D_Data"];
        [tempSelf GetOM].shengheArr = [NSMutableArray arrayWithArray:result];
        for (NSArray *rs in result){
            [tempSelf.types setObject:[rs objectAtIndex:2] forKey:[rs objectAtIndex:0]];
            //保存取得的订单名和订单ID
        }
        [tempSelf SetContextButtons];
    } lock:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setNavigationShow];
}

-(void)buttonClick:(UIButton *)sender{
    
    NSDictionary *buttonInfo =  [self.buttons objectAtIndex:sender.tag - 1];
    ShenHeDtlViewController *vc = (ShenHeDtlViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ShenHeDtlViewController"];
    vc.strTitle =  [buttonInfo strForKey:@"Name"];
    
    NSArray *rs = [self GetShenHeType:[buttonInfo strForKey:@"Name"]];//根据名称取得缓存的订单名和订单ID，因有见过订单名一样，但是ID不一样的帐套
    
    NSString *str = [buttonInfo strForKey:@"Type"] ;//已知数据的订单ID
    int tp = [str intValue] ;
    vc.style = [buttonInfo intForKey:@"Style"];
    
    if (rs ) {//若网上有取得 数据，则以网上ID为准
        //网上取得的内容 对应的 订单ID
        tp = [[rs objectAtIndex:0] intValue];
    }
    vc.callFunction = tp;// [buttonInfo intForKey:@"Type"];
    vc.shType = tp;// [buttonInfo intForKey:@"Type"];

    vc.searchType = [buttonInfo strForKey:@"SearchType"];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)SetContextButtons{
    CGSize cSize = CGSizeMake(85, 95);
    CGFloat offset = 12 ;
    CGFloat height = 1;
    NSUInteger col = 1;
    NSUInteger row = 1;
    for (int  i = 0 ; i < [self.buttons count] ; i ++){
        NSDictionary *dic = self.buttons[i];
        
        
        SEL action = NSSelectorFromString([dic strForKey:@"Action"]);
        NSString *img = [dic strForKey:@"Image"];
        NSString *name = [dic strForKey:@"Name"];
        NSString *type = [dic strForKey:@"Type"];
        
        NSLog(@"name %@",name);
//        NSString *num = [dic strForKey:@"Number"];
        
        
        CGFloat x = 20 + (85 + offset) * (col - 1) ;
        CGFloat y = ((95 + offset) * (row - 1)) ;
        
        height = y + cSize.height + 10;
        
        RCImageButton *button = (RCImageButton *)[self.view viewWithTag:i + 1];
        if (button == nil) {
            button = [[[RCImageButton alloc]initWithFrame:CGRectMake(x , (y + 5), cSize.width, cSize.height)] autorelease];
        }
        [button setButtonTag:i];
        if (++ col > 3) {
            row ++;
            col = 1;
        }
        
        //        [button setTitle:[dic strForKey:@"Name"] forState:UIControlStateNormal];
        NSArray *rs = [self GetShenHeType:name];
        
        [button setImgName:img];
        [button setName:name];
//        [button setNum:[self.types strForKey:type]];
        [button setNum:[rs objectAtIndex:2]];
        button.tag = i + 1;
        [button setButtonTag:i + 1];

        
        [self.scView addSubview:button];
        if ([self canPerformAction:action withSender:self]) {
            [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.scView.contentSize = CGSizeMake(1, height);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.types = nil;
    self.buttons = nil;
    [_scView release];
    [super dealloc];
}


@end
