//
//  OrderDetailController.m
//  UMobile
//
//  Created by  APPLE on 2014/10/17.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "OrderDetailController.h"

@interface OrderDetailController ()

@end

@implementation OrderDetailController

@synthesize info;
@synthesize keyIndex;
@synthesize callFunction;
@synthesize types;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.info);
    _cpoyButton.hidden = _isHidden;
    _printButton.hidden = _isHidden;
    _checkButton.hidden = !_isHidden;
    
    [_checkButton addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setViewControllers];
    
    // Do any additional setup after loading the view.
}

-(void)checkButtonClick:(id)sender{
    NSString *param = [NSString stringWithFormat:@"%@,%@,%@,0,'','',%@,0",[self.info objectAtIndex:2],[self.info objectAtIndex:0],[self.info objectAtIndex:4],[self GetUserID]];
    NSString *link = [self GetLinkWithFunction:56 andParam:param];
    __block OrderDetailController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        NSArray *rs =  [[[obj objectFromJSONString] objectForKey:@"D_Data"] objectAtIndex:0];
        if ([[rs objectAtIndex:0] integerValue] == 0){
            [tempSelf makeToastInWindow:@"审核成功"];
            [tempSelf.parentVC performSelector:@selector(loadData) withObject:nil];
            [tempSelf dismiss];
        }else{
            [tempSelf makeToastInWindow:[rs objectAtIndex:1]];
        }
    } lock:YES];
}

-(void)setViewControllers{
    OrderProductsViewController *vc1 = (OrderProductsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"OrderProductsViewController"];
    OrderHeaderViewController *vc2 = (OrderHeaderViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHeaderViewController"];
    OrderCheckViewController *vc3 = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderCheckViewController"];
    
    vc1.info = self.info;
    vc1.keyIndex = self.keyIndex;
    vc1.types = self.types;
    vc1.parentVC = self;
    vc2.info = self.info;
    vc2.keyIndex = self.keyIndex;
    vc2.types = self.types;
    vc2.parentVC = self;
    vc2.bInDDGL = !_isHidden;//订单底部显示摘要，因callFunction 与其他一样，只能如此判断
    vc2.bClean = self.bClean;
    // fix
    vc3.noCheck = self.noCheck;
    
    //判断 由 哪里进入的订单,与下面可能有重复，之前需求不清晰，此项先添加的
    vc1.fromType = self.fromType;
    vc2.fromType = self.fromType;
    
    
    //审核类型
    
    vc1.shType = self.shType;
    vc2.shType = self.shType;
    vc3.shType = self.shType;
    
    //预警类型
    vc1.yjType = self.yjType;
    vc2.yjType = self.yjType;
    vc3.yjType = self.yjType;
    vc3.parentVC = vc2;

    
    NSString *name = @"商品明细";
    if (self.callFunction == 7 || self.callFunction == 8) {
        name = @"调拨明细";
    }else if (self.callFunction == 128){
        name = @"预收明细";
    }
    // fix   ghd     0125
    if (!self.fromCheck){
        self.mutileView.viewControllers = @[vc1,vc2,vc3];
        self.mutileView.titles = @[name,@"主单据",@"审核历史"];
        [self setRightButton];
    }else if (self.shType > -1 && [self.setting intForKey:@"ISBS"] == 1){
        vc3.noCheck = (self.shType > -1  && [self.setting intForKey:@"ISBS"] == 1);
        self.mutileView.viewControllers = @[vc1,vc2,vc3];
        self.mutileView.titles = @[name,@"主单据",@"审核历史"];
        [self setRightButton];
    }else{
        self.mutileView.viewControllers = @[vc1,vc2];
        self.mutileView.titles = @[name,@"主单据"];
        
    }
    self.mutileView.bloadAll = YES;
    self.mutileView.selectIndex = 1;
}

-(void)setRightButton{
    if (self.noCheck) {
        UIBarButtonItem *button = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"edit_press"] style:UIBarButtonItemStylePlain target:self action:@selector(editClick:)] autorelease];
        self.navigationItem.rightBarButtonItem = button;
    }
}

-(void)editClick:(id)sender{
    [self copyBtnAction:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if(b) return;
    b = YES;
    [self.mutileView layoutSubviews];
//    [self performSelectorOnMainThread:@selector(setViewControllers) withObject:nil waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// fixBug       ghd         20150122
- (IBAction)copyBtnAction:(id)sender {

    
    bEdit =  sender == nil;
    self.hInfo = [NSMutableDictionary dictionary];

    
//    [self searchSalesman];
    [self searchResultInOperation];//查询所有资料

    self.bloadInfo = YES;
    while (self.bloadInfo) {//获取客户，经手人，仓库信息 前阻塞
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    
    OrderProductsViewController *vc1 = (OrderProductsViewController *) [self.mutileView.viewControllers objectAtIndex:0];
    OrderHeaderViewController *vc2 = (OrderHeaderViewController *)[self.mutileView.viewControllers objectAtIndex:1];

    
    XinZenDingDanViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"XinZenDingDanViewController"];
    
    vc.bEdit = bEdit;//由编辑按钮点入
    vc.products = [self exchangeArray:vc1.result];
    
    if (bEdit) {
        vc.InvId = self.strID; //[vc2.result objectAtIndex:1];//编辑传单号,strID 由上级列表传送过来
        if ([vc.products count] > 0) {
            NSDictionary *info = [vc.products firstObject];
            vc.AccID = [info strForKey:@"ListID"];
        }
    }else {
        vc.bClean = YES;// 复制点入，可清除
    }
    

    
    
    if ([self.setting intForKey:@"ISBS"] == 1) {
        vc.headInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       [NSMutableArray arrayWithObjects:[self GetOrderType:[vc2.result objectAtIndex:0]],[vc2.result objectAtIndex:0], nil],@"0",
                       [NSMutableArray arrayWithObjects:@"0",[vc2.result objectAtIndex:2], nil],@"1",
                       [NSMutableArray arrayWithObjects:@"0",[vc2.result objectAtIndex:3], nil],@"2",
                       [NSMutableArray arrayWithArray:[self.hInfo objectForKey:@"Salesman"]],@"4",
                       [NSMutableArray arrayWithArray:[self.hInfo objectForKey:@"Department"]],@"5",//部门
                       [NSMutableArray arrayWithArray:[self.hInfo objectForKey:@"Customer"]],@"3",
                       [NSMutableArray arrayWithObjects:@"0",[vc2.result objectAtIndex:17], nil],@"7",//取货日期
                       [NSMutableArray arrayWithArray:[self.hInfo objectForKey:@"Stock"]],@"6",//仓库
                       [NSMutableArray arrayWithObjects:@"0",[vc2.result objectAtIndex:15], nil],@"8",//摘要
                       [NSMutableArray arrayWithObjects:[vc2.result objectAtIndex:23],[vc2.result objectAtIndex:24], nil],@"9",
                       [NSMutableArray arrayWithObjects:@"0",[vc2.result objectAtIndex:25], nil],@"10"
                       , nil];
    }else{
        vc.headInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       [NSMutableArray arrayWithObjects:[self GetOrderType:[vc2.result objectAtIndex:0]],[vc2.result objectAtIndex:0], nil],@"0",
                       [NSMutableArray arrayWithObjects:@"0",[vc2.result objectAtIndex:2], nil],@"1",
                       [NSMutableArray arrayWithObjects:@"0",[vc2.result objectAtIndex:3], nil],@"2",
                       [NSMutableArray arrayWithArray:[self.hInfo objectForKey:@"Salesman"]],@"3",
                       [NSMutableArray arrayWithArray:[self.hInfo objectForKey:@"Department"]],@"4",//部门
                       [NSMutableArray arrayWithArray:[self.hInfo objectForKey:@"Customer"]],@"5",
                       [NSMutableArray arrayWithObjects:@"0",[vc2.result objectAtIndex:17], nil],@"6",//取货日期
                       [NSMutableArray arrayWithArray:[self.hInfo objectForKey:@"Stock"]],@"7",//仓库
                       [NSMutableArray arrayWithObjects:@"0",[vc2.result objectAtIndex:15], nil],@"8",//摘要
                       [NSMutableArray arrayWithObjects:[vc2.result objectAtIndex:23],[vc2.result objectAtIndex:24], nil],@"9",
                       [NSMutableArray arrayWithObjects:@"0",[vc2.result objectAtIndex:25], nil],@"10"
                       , nil];
    }

    
    [self.navigationController pushViewController:vc animated:YES];

}



-(NSMutableArray *)exchangeArray:(NSArray *)arr{
    NSArray *rs = @[@"ListID",@"商品ID",@"商品编码",@"名称",@"单位ID",@"单位名称",@"单位换算率",@"规格",@"型号",@"数量",@"单价",@"发生金额",@"折后单价",@"折后金额",@"赠品",@"可用数量",@"库存数量",@"核销单据编号",@"核销单据类型",@"核销单据日期",@"未结算金额",@"本次结算金额",@"货单号",@"显示类型",@"条码",@"折扣",@"已结算金额"];
    NSMutableArray *newArr = [NSMutableArray array];
    
    for(int i = 0 ; i < [arr count] ; i ++){//循环产品
        NSArray *rsd = [arr objectAtIndex:i];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        for (int j = 0 ; j < [rsd count] ; j ++){//将产品对应键值
            [dic setObject:[rsd objectAtIndex:j] forKey:[rs objectAtIndex:j]];
        }

        if ([[dic strForKey:@"赠品"] isEqualToString:@"是"]) {
            [dic setObject:@"1" forKey:@"赠品"];
        }
        [newArr addObject:dic];
    }
    
    return newArr;
}

- (IBAction)printBtnAction:(id)sender {
    OrderProductsViewController *vc1 = (OrderProductsViewController *) [self.mutileView.viewControllers objectAtIndex:0];
    OrderHeaderViewController *vc2 = (OrderHeaderViewController *)[self.mutileView.viewControllers objectAtIndex:1];
    
    NSArray *hInfo = vc2.result;
    NSArray *dInfo = [self exchangeArray:vc1.result];
    
    NSMutableArray *dataSource=[NSMutableArray array];
    
    [dataSource addObject:[NSString stringWithFormat:@"%@",[hInfo ingoreObjectAtIndex:5]]];//往来单位
    [dataSource addObject:[NSString stringWithFormat:@"单据编号:%@",[hInfo ingoreObjectAtIndex:3]]];
    [dataSource addObject:[NSString stringWithFormat:@"单据时间:%@",[hInfo ingoreObjectAtIndex:2]]];
    [dataSource addObject:[NSString stringWithFormat:@"经手人:%@",[hInfo ingoreObjectAtIndex:10]]];
    [dataSource addObject:@"========================="];
    [dataSource addObject:@"商品    数量   单价    金额"];
    [dataSource addObject:@"-------------------------"];

    float total=0;
    int cnt = 0;
    for (NSDictionary *rs in dInfo) {
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@ %@",[rs strForKey:@"名称"],[rs strForKey:@"数量"],[rs strForKey:@"单价"],[rs strForKey:@"折后金额"]];
        total+=[[rs strForKey:@"折后金额"] floatValue];
        cnt += [[rs strForKey:@"数量"] integerValue];
        [dataSource addObject:str];
    }
    
    [dataSource addObject:@"-------------------------"];
    [dataSource addObject:[NSString stringWithFormat:@"总数量:%d",cnt]];
    [dataSource addObject:[NSString stringWithFormat:@"总金额:%.2f",[[hInfo objectAtIndex:28] doubleValue]]];
    [dataSource addObject:[NSString stringWithFormat:@"打印日期:%@",[self GetCurrentDateTime]]];
    [dataSource addObject:[NSString stringWithFormat:@"客户签名:"]];
    
    [self printText:dataSource];
}

-(void)searchResultInOperation{
    [ProgressHUD show:nil];
    NSOperationQueue *queue = [[[NSOperationQueue alloc]init] autorelease];
    [queue setMaxConcurrentOperationCount:1];//服务器单线程？？ 多个同时查询会返回 服务器繁忙
    NSInvocationOperation *op1  = [[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(searchSalesman) object:nil] autorelease];
    NSInvocationOperation *op2  = [[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(searchCustomer) object:nil] autorelease];
    NSInvocationOperation *op3  = [[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(searchStock) object:nil] autorelease];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];

}

-(void)searchSalesman{

    OrderHeaderViewController *vc = (OrderHeaderViewController *)[self.mutileView.viewControllers objectAtIndex:1];
    NSString *param = [NSString stringWithFormat:@"'%@',0,0,1,%@,20,0",[[vc.result objectAtIndex:10] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self GetUserID]];//经手人名称查询
    NSString *link = [self GetLinkWithFunction:63 andParam:param];
    
    NSDictionary *dic = [self StartQuery:link];
    
    NSArray *result = [dic objectForKey:@"D_Data"];
    if ([result count] > 0) {
        NSArray *rs = [result objectAtIndex:0];
        NSArray *rsd = @[[rs objectAtIndex:2],[rs objectAtIndex:1]];//ID，名称
        [self.hInfo setObject:rsd forKey:@"Salesman"];
        NSArray *dpd = @[[rs objectAtIndex:4],[rs objectAtIndex:5]];//ID，名称，部门
        [self.hInfo setObject:dpd forKey:@"Department"];
    }
}

-(void)searchCustomer{

    OrderHeaderViewController *vc = (OrderHeaderViewController *)[self.mutileView.viewControllers objectAtIndex:1];
    NSString *param = [NSString stringWithFormat:@"'%@',0,0,0,1,%@,20,0",[[vc.result objectAtIndex:5] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self GetUserID]];//用往来单位编号查询
    NSString *link = [self GetLinkWithFunction:61 andParam:param];
    NSDictionary *dic = [self StartQuery:link];
    NSArray *result = [dic objectForKey:@"D_Data"];
    
    if ([result count] > 0) {
        NSArray *rs = [result objectAtIndex:0];
        NSArray *rsd = @[[rs objectAtIndex:4],[rs objectAtIndex:1]];//ID，名称
        [self.hInfo setObject:rsd forKey:@"Customer"];
    }
}

-(void)searchStock{

    OrderHeaderViewController *vc = (OrderHeaderViewController *)[self.mutileView.viewControllers objectAtIndex:1];
    
    if ([[vc.result objectAtIndex:13] length] == 0) {
        [ProgressHUD dismiss];
        self.bloadInfo = NO;
        return;
    }
    NSString *param = [NSString stringWithFormat:@"'%@',0,0,1,%@,20,0",[[vc.result objectAtIndex:13] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self GetUserID]];
    NSString *link = [self GetLinkWithFunction:62 andParam:param];
    NSDictionary *dic = [self StartQuery:link];
    NSArray *result = [dic objectForKey:@"D_Data"];
    if ([result count] > 0) {
        NSArray *rs = [result objectAtIndex:0];
        NSArray *rsd = @[[rs objectAtIndex:2],[rs objectAtIndex:1]];//ID，名称
        [self.hInfo setObject:rsd forKey:@"Stock"];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD dismiss];
    });
    
    self.bloadInfo = NO;

}

-(void)printText:(NSArray *)array{
    NSMutableString *stringToPrint = [[NSMutableString alloc] initWithString:@""];
    for(int i = 0;i<[array count];i++)
    {
        [stringToPrint appendFormat:@"%@",[array objectAtIndex:i]];
        [stringToPrint appendFormat:@"\n"];
    }
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"新增订单";
    pic.printInfo = printInfo;
    
    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc]
                                                 initWithText:stringToPrint];
    textFormatter.startPage = 0;
    textFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
    textFormatter.maximumContentWidth = 6 * 72.0;
    pic.printFormatter = textFormatter;
    pic.showsPageRange = YES;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error)
    {
        if (!completed && error)
        {
            NSLog(@"Printing could not complete because of error: %@", error);
        }
    };
    
    [pic presentAnimated:YES completionHandler:completionHandler];
    
}

//- (IBAction)shenheClick:(id)sender {
//    NSString *param = [NSString stringWithFormat:@"%@,%@,%@,0,'','',1,0",[self.info objectAtIndex:2],[self.info objectAtIndex:0],[self.info objectAtIndex:4]];
//    NSString *link = [self GetLinkWithFunction:56 andParam:param];
//    __block OrderDetailController *tempSelf = self;
//    [self StartQuery:link completeBlock:^(id obj) {
//        NSArray *rs =  [[[obj objectFromJSONString] objectForKey:@"D_Data"] objectAtIndex:0];
//        if ([[rs objectAtIndex:0] integerValue] == 0){
//            [tempSelf makeToastInWindow:@"审核成功"];
//            [tempSelf.parentVC performSelector:@selector(loadData) withObject:nil];
//            [tempSelf dismiss];
//        }else{
//            [tempSelf makeToastInWindow:[rs objectAtIndex:1]];
//        }
//    } lock:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    self.headInfo = nil;
    self.hInfo = nil;
    self.types = nil;
    self.keyIndex = nil;
    self.info = nil;
    [_mutileView release];
    [_printButton release];
    [_checkButton release];
    [_cpoyButton release];
    [super dealloc];
}
@end
