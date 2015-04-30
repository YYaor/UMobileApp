//
//  YeWuDanJuViewController.m
//  UMobile
//
//  Created by mocha on 15/4/30.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "YeWuDanJuViewController.h"

@interface YeWuDanJuViewController ()

@end

@implementation YeWuDanJuViewController

@synthesize buttons;
@synthesize types;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[[NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"进货单",@"Action": @"buttonClick:",@"Image":@"审核_15",@"Type":@"0",@"Style":@"0",@"SearchType":@"输入供应商/制单人查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"进货退货单",@"Action": @"buttonClick:",@"Image":@"审核_17",@"Type":@"3",@"Style":@"0",@"SearchType":@"输入供应商/制单人查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"销售单",@"Action": @"buttonClick:",@"Image":@"审核_13",@"Type":@"1",@"Style":@"1",@"SearchType":@"输入客户/制单人查询"}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"Name":@"销售退货单",@"Action": @"buttonClick:",@"Image":@"审核_25",@"Type":@"4",@"Style":@"1",@"SearchType":@"输入客户/制单人查询"}],
                       ];
    
    //Type 为 对应 下级的callFunction 根据 此值取不同的显示内容
    self.buttons  =  [NSMutableArray arrayWithArray:array];
    
    
    [self loadButtons];

    // Do any additional setup after loading the view.
}

- (IBAction)refreshClick:(id)sender {
    [self loadButtons];
}

-(void)loadButtons{
    __block YeWuDanJuViewController *tempSelf = self;
    
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
            button = [[[RCImageButton alloc]initWithFrame:CGRectMake(x , (y + 5)+64, cSize.width, cSize.height)] autorelease];
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
        
        
        [self.view addSubview:button];
        if ([self canPerformAction:action withSender:self]) {
            [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
//    self.scView.contentSize = CGSizeMake(1, height);
    
}

-(NSArray *)GetShenHeType:(NSString *)name{
    for (NSArray *rs in [self GetOM].shengheArr){
        if ([[rs objectAtIndex:1] isEqualToString:name]) {
            return rs;
        }
    }
    return nil;
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

@end
