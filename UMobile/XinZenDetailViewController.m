//
//  XinZenDetailViewController.m
//  UMobile
//
//  Created by 陈 景云 on 14-10-28.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "XinZenDetailViewController.h"

#define kSendCompanyMessageNotifi   @"companyMessage"

@interface XinZenDetailViewController ()

@end

@implementation XinZenDetailViewController
@synthesize products;

@synthesize total,count;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.count = @"0";
    self.total = @"0";
    if (self.products == nil)
        self.products = [NSMutableArray array];
    else
        [self computeTotal];
    self.orderType = @"预设出库售价";
    self.delProducts = [NSMutableArray array];
    
    // add notifi
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendCompanyMessage:) name:@"sendCompanyMessage" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendOrderMessage:) name:@"sendOrderMessage" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
}

-(NSMutableDictionary *)GetHeaderInfo{
    XinZenDingDanViewController *vc = (XinZenDingDanViewController *)self.parentVC;
    XinZenHeaderViewController *vh = [vc.mutileView.viewControllers firstObject];
    if (vh) {
        return vh.allInfo;
    }
    return nil;
}

//- (void)sendCompanyMessage:(NSNotification *)notifi
//{
//    NSLog(@"%@", notifi.userInfo[@"message"]);
//    self.companyID = [notifi.userInfo[@"message"] objectAtIndex:0];
//    
//}
//- (void)sendOrderMessage:(NSNotification *)notifi
//{
//    NSLog(@"%@", notifi.userInfo[@"message"]);
//    if ([[notifi.userInfo[@"message"] objectAtIndex:0] intValue] == 5) {
//        self.orderType = @"预设入库售价";
//    }else
//    {
//        self.orderType = @"预设出库售价";
//    }
//}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGRect rect = self.totalView.frame;
    rect.origin.y -=236;
    self.totalView.frame = rect;
    return YES;
}

-(void)keyboardWillShow:(id)info{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 280, 0);
}

-(void)keyboardWillHide:(id)info{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}

-(void)loadData{
    [self.tableView reloadData];
    [self computeTotal];
}

-(void)searchProductWithBarcode:(NSString *)barCode{
//    NSString *param = [NSString stringWithFormat:@"'%@',0,0,0,0,0,0,1,1",[barCode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *param = [NSString stringWithFormat:@"'%@',0,0,0,0,%d",[barCode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[[self setting] objectForKey:@"UID"] intValue]];
    NSString *link =  [self GetLinkWithFunction:80 andParam:param];
    __block XinZenDetailViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        if ([rs count] > 0) {
            NSMutableArray *arr = [[rs objectAtIndex:0] mutableCopy];
            [arr removeObjectAtIndex:0];
            [tempSelf.products addObject:[self setProduct:arr]];
            [tempSelf.tableView reloadData];
        }else{
            [tempSelf.view makeToast:@"当前没有可显示数据"];
        }

    } lock:YES];
}

-(NSMutableDictionary *)setProduct:(NSArray *)arr{
//    NSMutableArray *np = [NSMutableArray arrayWithArray:arr];
//    [np addObject:@"1"];
//    [np addObject:@"100"];
//    [np addObject:[arr objectAtIndex:16]];
//    [np addObject:[arr objectAtIndex:16]];
//    [np addObject:@""];
//    [np addObject:@"0"];
//    return np;
    
    NSMutableDictionary *P = [NSMutableDictionary dictionary];
    
    NSArray *keys = @[@"商品ID",@"可用数量",@"库存数量",@"商品编码",
                      @"名称",@"规格",@"型号",@"最近进价",@"单位ID",
                      @"单位名称",@"儿子数",@"条码",@"预设入库售价",
                      @"预设出库售价",@"预设入库售价比率",@"预设出库售价比率"];
    
    
    
    for (int i = 0 ; i < [keys count] ; i ++){
        [P setObject:[arr objectAtIndex:i] forKey:[keys objectAtIndex:i]];
    }
    
    NSString *type = @"";
    //判断 是否选择了 往来单位
    BOOL bSelectCompany = NO;
    if([self.setting intForKey:@"ISBS"] == 1){   //区分BS帐套
        bSelectCompany = [[[self GetHeaderInfo] objectForKey:@"4"] firstObject] != nil;
    }else{
        bSelectCompany = [[[self GetHeaderInfo] objectForKey:@"5"] firstObject] != nil;
    }
    
    if (bSelectCompany) {//选择了往来单位才取 出库或入库价
        if ([[[[self GetHeaderInfo] objectForKey:@"0"] firstObject] integerValue] == 5) {
            type = @"预设入库售价";
        }else{
            type = @"预设出库售价";
        }
    }

    NSString *price = [P strForKey:type];//未选择往来 单位时 type =@"",则没有价钱
    
    
    [P setObject:@"" forKey:@"明细ID"];
    [P setObject:@"" forKey:@"单据ID"];
    [P setObject:@"" forKey:@"仓库ID"];
    //    [P setObject:[arr objectAtIndex:0] forKey:@"商品ID"];
    //    [P setObject:[arr objectAtIndex:8] forKey:@"商品单位ID"];
    [P setObject:@"" forKey:@"批号"];
    [P setObject:@"" forKey:@"出厂日期"];
    [P setObject:@"1" forKey:@"数量"];
    [P setObject:price forKey:@"单价"];
    [P setObject:price forKey:@"金额"];
    [P setObject:@"1" forKey:@"单位换算率"];
    [P setObject:@"1" forKey:@"基本单位数量"];
    
    [P setObject:@"100" forKey:@"折扣"];
    [P setObject:price forKey:@"折后单价"];
    [P setObject:price forKey:@"折后金额"];
    [P setObject:@"0" forKey:@"折扣金额"];
    
    [P setObject:@"0" forKey:@"税率"];
    [P setObject:price forKey:@"含税单价"];
    
    [P setObject:price forKey:@"含税金额"];
    [P setObject:@"0" forKey:@"税额"];
    [P setObject:@"0" forKey:@"赠品"];
    [P setObject:@"" forKey:@"备注"];
    
    
    //    [np addObject:@"1"];//数量 17
    //    [np addObject:@"100"];//折扣 18
    //    [np addObject:[arr objectAtIndex:16]]; 19
    //    [np addObject:[arr objectAtIndex:16]]; 20
    //    [np addObject:@""]; 21
    //    [np addObject:@"0"];//赠品 22
    return P;
}

-(void)computeTotal{
    double ct = 0;
    double tot = 0;
    double disTotal = 0;
    for (NSDictionary *arr  in self.products){
        ct += [arr floatForKey:@"数量"];
        
        if ([arr intForKey:@"赠品"] == 0)
        {
            disTotal += [arr floatForKey:@"折后金额"];
            tot += [arr floatForKey:@"金额"];
        }
    }

        
//        if ([arr intForKey:@"赠品"] == 0)
//            tot += [arr floatForKey:@"折后金额"];;
//    }
    
    self.count = [NSString stringWithFormat:@"%f",ct];
    self.total = [NSString stringWithFormat:@"%f",tot];
    self.disTotal = [NSString stringWithFormat:@"%f",disTotal];
    
    [self setText:self.count forView:self.totalView withTag:1];
    [self setText:self.disTotal forView:self.totalView withTag:2];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.products count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *rs = [self.products objectAtIndex:indexPath.row];
    [self setText:[rs strForKey:@"名称"] forView:cell withTag:1];
    [self setText:[rs strForKey:@"数量"] forView:cell withTag:2];
    // change
    NSLog(@"%@",[rs strForKey:@"预设出库售价"]);
    NSLog(@"%@",[rs strForKey:@"预设入库售价"]);
    [self setText:[rs strForKey:@"折后金额"] forView:cell withTag:3];

    
//    [self setText:[rs strForKey:@"折后金额"] forView:cell withTag:3];
    UITextField *textField =(UITextField *)[cell viewWithTag:4];
    textField.hidden = [[rs strForKey:@"赠品"] isEqualToString:@"1"]?NO:YES;

//    [self setText:[rs ingoreObjectAtIndex:1] forView:cell withTag:2];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.products objectAtIndex:indexPath.row]];
        NSString *listid = [dic strForKey:@"ListID"];
        if ([listid intValue] > 0) {
            [dic setObject:[NSString stringWithFormat:@"-%@",listid] forKey:@"ListID"];
            [self.delProducts addObject:dic];
        }
        
        [self.products removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self computeTotal];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XinZenShangPingViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"XinZenShangPingViewController"];
    NSMutableDictionary *product = [self.products objectAtIndex:indexPath.row];
    vc.productInfo = product;
    vc.result = self.products;
    vc.selectIndex = indexPath.row;
    vc.parentVC = self;
    vc.orderType = self.orderType;
    vc.headInfo = [self GetHeaderInfo];

    [self.parentVC.navigationController pushViewController:vc animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)addButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1 || button.tag == 2) {
        ScanViewController *sc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScanViewController"];
        sc.parentVC = self;
        sc.products = self.products;
        sc.headerInfo = [self GetHeaderInfo];
        sc.scanType = button.tag == 1?ScanView_Type_SingleScan:ScanView_Type_MutileScan;
        [self.parentVC.navigationController pushViewController:sc animated:YES];
    }else{
        ShangPinXZViewController *vc = (ShangPinXZViewController *)  [self.storyboard instantiateViewControllerWithIdentifier:@"ShangPinXZViewController"];
        vc.bMutileSelect = button.tag == 3;
        vc.parentVC = self;
        vc.products = self.products;
//        vc.companyID = self.companyID;
        vc.allInfo = [self GetHeaderInfo];
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }

}

- (IBAction)deleteClick:(id)sender {
    UITableViewCell *cell =  [self GetSuperCell:sender];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.products objectAtIndex:indexPath.row]];
    NSString *listid = [dic strForKey:@"ListID"];
    if ([listid intValue] > 0) {
        [dic setObject:[NSString stringWithFormat:@"-%@",listid] forKey:@"ListID"];
        [self.delProducts addObject:dic];
    }
    
    [self.products removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    // 删除时刷新统计数据                            15.1.20
    [self computeTotal];
}


- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.delProducts = nil;
    self.total =  nil;
    self.count = nil;
    self.disTotal = nil;
    self.products = nil;
    [_tableView release];
    [_totalView release];
    [super dealloc];
}
@end
