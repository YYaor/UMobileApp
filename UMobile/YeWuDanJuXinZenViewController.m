//
//  YeWuDanJuXinZenViewController.m
//  UMobile
//
//  Created by mocha on 15/5/5.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//
#define NUMBERS @"1234567890."

#import "YeWuDanJuXinZenViewController.h"
#import "USettingModel.h"

@interface YeWuDanJuXinZenViewController ()

@end

@implementation YeWuDanJuXinZenViewController

@synthesize allInfo=_allInfo,titles,titles_in,titles_out;
@synthesize copiedDataArray;

-(NSMutableDictionary *)allInfo{
    if(_allInfo == nil){
        
        _allInfo =  [[NSMutableDictionary alloc] init];
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"6",@"销售订单", nil];  //默认：单据类型
        [_allInfo setObject:arr forKey:@"0"];
        NSMutableArray *arrDate = [NSMutableArray arrayWithObjects:@"0",[self GetCurrentDate], nil];
        [_allInfo setObject:arrDate forKey:@"1"];
        
        NSDictionary *hInfo = [[self GetOM] getOrder:[self.setting strForKey:@"Identy"]];
        if ([self.setting intForKey:@"ISBS"] == 1) {
            if (self.copiedDataArray && copiedDataArray.count > 25){
                //--往来单位
                [_allInfo setObject:[NSMutableArray arrayWithObjects:[copiedDataArray objectAtIndex:6],[copiedDataArray objectAtIndex:8], nil] forKey:@"3"];
                //--经手人
                [_allInfo setObject:[NSMutableArray arrayWithObjects:[copiedDataArray objectAtIndex:14],[copiedDataArray objectAtIndex:15], nil] forKey:@"4"];
                //--部门
                //[_allInfo setObject:[NSArray arrayWithObjects:[copiedDataArray objectAtIndex:0],[copiedDataArray objectAtIndex:0], nil] forKey:@"5"];
                //--仓库
                [_allInfo setObject:[NSMutableArray arrayWithObjects:[copiedDataArray objectAtIndex:12],[copiedDataArray objectAtIndex:13], nil] forKey:@"6"];
                //--摘要
                [_allInfo setObject:[NSMutableArray arrayWithObjects:@"0",[copiedDataArray objectAtIndex:18], nil] forKey:@"7"];
                //--付款帐户
                [_allInfo setObject:[NSMutableArray arrayWithObjects:[copiedDataArray objectAtIndex:20],[copiedDataArray objectAtIndex:21], nil] forKey:@"8"];
                //--付款金额
                [_allInfo setObject:[NSMutableArray arrayWithObjects:@"0",[copiedDataArray objectAtIndex:22], nil] forKey:@"9"];
                //--附加说明
                [_allInfo setObject:[NSMutableArray arrayWithObjects:@"0",[copiedDataArray objectAtIndex:19], nil] forKey:@"10"];
                //--审核人
                [_allInfo setObject:[NSMutableArray arrayWithObjects:[copiedDataArray objectAtIndex:24],[copiedDataArray objectAtIndex:25], nil] forKey:@"11"];
                
            }else{
                [_allInfo setObj:[NSMutableArray arrayWithArray:[hInfo objectForKey:@"4"]] forKey:@"4"];
                [_allInfo setObj:[NSMutableArray arrayWithArray:[hInfo objectForKey:@"5"]] forKey:@"5"];
                [_allInfo setObj:[NSMutableArray arrayWithArray:[hInfo objectForKey:@"6"]] forKey:@"6"];
                NSMutableArray *peopleArr = [NSMutableArray arrayWithObjects:@"4",[USettingModel getSetting].JSRName, nil];
                [_allInfo setObject:peopleArr forKey:@"4"];
                
                NSMutableArray *bumenArr = [NSMutableArray arrayWithObjects:@"5",[USettingModel getSetting].BMName, nil];
                [_allInfo setObject:bumenArr forKey:@"5"];
                
                NSMutableArray *CKArr = [NSMutableArray arrayWithObjects:@"6",[USettingModel getSetting].FHCKName, nil];
                [_allInfo setObject:CKArr forKey:@"6"];
                
                NSMutableArray *SKArr = [NSMutableArray arrayWithObjects:@"8",[USettingModel getSetting].SKZHName, nil];
                [_allInfo setObject:SKArr forKey:@"8"];
            }
        }else{
            if (copiedDataArray && copiedDataArray.count > 25){
                //--经手人
                [_allInfo setObject:[NSMutableArray arrayWithObjects:[copiedDataArray objectAtIndex:14],[copiedDataArray objectAtIndex:15], nil] forKey:@"3"];
                //--部门
                //[_allInfo setObject:[NSArray arrayWithObjects:[copiedDataArray objectAtIndex:0],[copiedDataArray objectAtIndex:0], nil] forKey:@"4"];
                //--往来单位
                [_allInfo setObject:[NSMutableArray arrayWithObjects:[copiedDataArray objectAtIndex:6],[copiedDataArray objectAtIndex:8], nil] forKey:@"5"];
                //--入库仓库
                [_allInfo setObject:[NSMutableArray arrayWithObjects:[copiedDataArray objectAtIndex:12],[copiedDataArray objectAtIndex:13], nil] forKey:@"6"];
                //--摘要
                [_allInfo setObject:[NSMutableArray arrayWithObjects:@"0",[copiedDataArray objectAtIndex:18], nil] forKey:@"7"];
                //--付款帐户
                [_allInfo setObject:[NSMutableArray arrayWithObjects:[copiedDataArray objectAtIndex:20],[copiedDataArray objectAtIndex:21], nil] forKey:@"8"];
                //--付款金额
                [_allInfo setObject:[NSMutableArray arrayWithObjects:@"0",[copiedDataArray objectAtIndex:22], nil] forKey:@"9"];
                //--附加说明
                [_allInfo setObject:[NSArray arrayWithObjects:@"0",[copiedDataArray objectAtIndex:19], nil] forKey:@"10"];
                //--审核人
                [_allInfo setObject:[NSMutableArray arrayWithObjects:[copiedDataArray objectAtIndex:24],[copiedDataArray objectAtIndex:25], nil] forKey:@"11"];

            }else{
                [_allInfo setObj:[NSMutableArray arrayWithArray:[hInfo objectForKey:@"3"]] forKey:@"3"];
                [_allInfo setObj:[NSMutableArray arrayWithArray:[hInfo objectForKey:@"4"]] forKey:@"4"];
                [_allInfo setObj:[NSMutableArray arrayWithArray:[hInfo objectForKey:@"7"]] forKey:@"7"];
                NSMutableArray *peopleArr = [NSMutableArray arrayWithObjects:@"4",[USettingModel getSetting].JSRName, nil];
                [_allInfo setObject:peopleArr forKey:@"4"];
                
                NSMutableArray *bumenArr = [NSMutableArray arrayWithObjects:@"5",[USettingModel getSetting].BMName, nil];
                [_allInfo setObject:bumenArr forKey:@"5"];
                
                NSMutableArray *CKArr = [NSMutableArray arrayWithObjects:@"6",[USettingModel getSetting].FHCKName, nil];
                [_allInfo setObject:CKArr forKey:@"6"];
                
                NSMutableArray *SKArr = [NSMutableArray arrayWithObjects:@"9",[USettingModel getSetting].SKZHName, nil];
                [_allInfo setObject:SKArr forKey:@"9"];
            }
        }
        
        
        
        
        
        for(int i = 0 ; i < 12 ; i ++){
            NSString *key = [NSString stringWithFormat:@"%d",i];
            if (![_allInfo objectForKey:key])
                [_allInfo setObject:[NSMutableArray array] forKey:key];
        }
        
    }
    
    return _allInfo;
}


-(void)setAllInfo:(NSMutableDictionary *)allInfo{
    if (_allInfo) [_allInfo release];
    _allInfo = [allInfo retain];
    
    for(int i = 0 ; i < 12 ; i ++){
        NSString *key = [NSString stringWithFormat:@"%d",i];
        if (![_allInfo objectForKey:key])
            [_allInfo setObject:[NSMutableArray array] forKey:key];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    loadNo = NO;//复制或编辑或新增进入时，若为编辑第一次不加载单号
    
    if ([self.allInfo objectForKey:@"0"]) {
        invType = [[[self.allInfo objectForKey:@"0"] firstObject] integerValue];
    }
    [ProgressHUD dismiss];
    if (!self.bEdit) {
        loadNo = YES;
        [self loadInvoiceNo];
    }
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if([@"1" isEqual:[[self setting] objectForKey:@"ISBS"]]){   //区分BS帐套
        self.titles_in = @[@{@"Name":@"单据类型",@"Type":@"0"},
                           @{@"Name":@"单据日期",@"Type":@"1"},
                           @{@"Name":@"单据编号*",@"Type":@"0"},
                           @{@"Name":@"往来单位*",@"Type":@"0"},
                           @{@"Name":@"经手人*",@"Type":@"0"},
                           @{@"Name":@"部门*",@"Type":@"0"},
                           @{@"Name":@"入库仓库",@"Type":@"0"},
                           @{@"Name":@"摘要",@"Type":@"0"},
                           @{@"Name":@"付款帐户",@"Type":@"0"},
                           @{@"Name":@"付款金额",@"Type":@"0"},
                           @{@"Name":@"附加说明",@"Type":@"0"},
                           @{@"Name":@"审核人",@"Type":@"0"},
                           ];
        self.titles_out = @[@{@"Name":@"单据类型",@"Type":@"0"},
                            @{@"Name":@"单据日期",@"Type":@"1"},
                            @{@"Name":@"单据编号*",@"Type":@"0"},
                            @{@"Name":@"往来单位*",@"Type":@"0"},
                            @{@"Name":@"经手人*",@"Type":@"0"},
                            @{@"Name":@"部门*",@"Type":@"0"},
                            @{@"Name":@"发货仓库",@"Type":@"0"},
                            @{@"Name":@"摘要",@"Type":@"0"},
                            @{@"Name":@"收款帐户",@"Type":@"0"},
                            @{@"Name":@"收款金额",@"Type":@"0"},
                            @{@"Name":@"附加说明",@"Type":@"0"},
                            @{@"Name":@"审核人",@"Type":@"0"},
                            ];
    }else{
        self.titles_in = @[@{@"Name":@"单据类型",@"Type":@"0"},
                           @{@"Name":@"单据日期",@"Type":@"1"},
                           @{@"Name":@"单据编号*",@"Type":@"0"},
                           @{@"Name":@"经手人*",@"Type":@"0"},
                           @{@"Name":@"部门",@"Type":@"0"},
                           @{@"Name":@"往来单位*",@"Type":@"0"},
                           @{@"Name":@"入库仓库",@"Type":@"0"},
                           @{@"Name":@"摘要",@"Type":@"0"},
                           @{@"Name":@"付款帐户",@"Type":@"0"},
                           @{@"Name":@"付款金额",@"Type":@"0"},
                           @{@"Name":@"附加说明",@"Type":@"0"},
                           @{@"Name":@"审核人",@"Type":@"0"},
                           ];
        self.titles_out = @[@{@"Name":@"单据类型",@"Type":@"0"},
                            @{@"Name":@"单据日期",@"Type":@"1"},
                            @{@"Name":@"单据编号*",@"Type":@"0"},
                            @{@"Name":@"经手人*",@"Type":@"0"},
                            @{@"Name":@"部门",@"Type":@"0"},
                            @{@"Name":@"往来单位*",@"Type":@"0"},
                            @{@"Name":@"发货仓库",@"Type":@"0"},
                            @{@"Name":@"摘要",@"Type":@"0"},
                            @{@"Name":@"收款帐户",@"Type":@"0"},
                            @{@"Name":@"收款金额",@"Type":@"0"},
                            @{@"Name":@"附加说明",@"Type":@"0"},
                            @{@"Name":@"审核人",@"Type":@"0"}
                            ];
    }
    
    
    // Do any additional setup after loading the view.
}

-(void)CleanData{
    //复制-订单录入界面 在更换 单据类型的时候，会清空往来单位、到货日期、摘要、付款账户、付款金额等信息
    if ([self.setting intForKey:@"ISBS"] == 1){
        for (NSString *key in @[@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11"]){
            [self.allInfo setObject:[NSMutableArray array] forKey:key];
        }
    }else{
        for (NSString *key in @[@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11"]){
            [self.allInfo setObject:[NSMutableArray array] forKey:key];
        }
    }
}

-(void)loadData{
    NSArray *rs =  [self.allInfo objectForKey:@"0"];
    NSUInteger curType = [[rs ingoreObjectAtIndex:0] integerValue];
    if(curType == 5) {
        //进货订单
        self.titles = self.titles_in;
    }else {
        //销售订单
        self.titles = self.titles_out;
    }
    
    if ([self.setting intForKey:@"ISBS"] == 1) {
        //BS 时选择往来单位  有经手人，部门信息
        
        NSArray *cus = [self.allInfo objectForKey:@"3"];
        if ([cus count] > 2) {
            NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:[cus objectAtIndex:2],[cus objectAtIndex:3], nil];//经手人
            NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:[cus objectAtIndex:4],[cus objectAtIndex:5], nil];//部门
            NSMutableArray *arr3 = [NSMutableArray arrayWithObjects:[cus objectAtIndex:0],[cus objectAtIndex:1], nil];//往来单位
            [self.allInfo setObject:arr1 forKey:@"4"];
            [self.allInfo setObject:arr2 forKey:@"5"];
            [self.allInfo setObject:arr3 forKey:@"3"];//重置往来单位
        }
    }
    
    [self.tableView reloadData];
    
    if (curType != invType && loadNo) {
        if (self.bClean) {
            [self CleanData];
            [self.tableView reloadData];
            self.bClean = NO;
        }
        [self loadInvoiceNo];
        invType = curType;
    }
    
}

-(void)loadInvoiceNo{
    NSArray *arr1 = [self.allInfo objectForKey:@"0"];
    NSArray *arr2 = [self.allInfo objectForKey:@"1"];
    NSUInteger function = [[arr1 ingoreObjectAtIndex:0] intValue] == 5?67:68;
    NSString *param = [NSString  stringWithFormat:@"'%@',1",[arr2 ingoreObjectAtIndex:1]];
    NSString *link=  [self GetLinkWithFunction:function andParam:param];
    __block XinZenHeaderViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        NSArray *rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        if ([rs count]>0){
            NSArray *arr = @[@"0",[[rs objectAtIndex:0] objectAtIndex:0]];
            [tempSelf.allInfo setObject:arr forKey:@"2"];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    } lock:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.titles count]+1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [self.titles count]) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        NSDictionary *dic =  [self.titles objectAtIndex:indexPath.row];
        NSArray *rs =  [self.allInfo objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        NSLog(@"rs = %@",rs);
        [self setText:[dic strForKey:@"Name"] forView:cell withTag:1];
        MHTextField *textField = (MHTextField *)[cell viewWithTag:2];
        textField.text =  [rs ingoreObjectAtIndex:1];
        if ([dic intForKey:@"Type"] == 1)
            textField.isDateField = YES;
        else
            textField.isDateField = NO;
        return cell;
    }else{
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        UIButton * reSet=(UIButton *)[cell viewWithTag:1];
        [reSet addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        UIButton * print=(UIButton *)[cell viewWithTag:2];
        [print addTarget:self action:@selector(print) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 12) {
        return 60;
    }
    return 44;
}
-(void)reset{
    for(int i = 0 ; i < 12 ; i ++){
        NSString *key = [NSString stringWithFormat:@"%d",i];
        if (i>2)
            [_allInfo setObject:[NSMutableArray array] forKey:key];
    }
    [self.tableView reloadData];
}

-(void)print{
    //    [self.delegate print];
    [self.parentVC performSelectorOnMainThread:@selector(print) withObject:nil waitUntilDone:YES];
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UITableViewCell *cell = [self GetSuperCell:textField];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if(indexPath.row == 2) return NO;
    NSString *key = [NSString stringWithFormat:@"%d",indexPath.row];
    
    int jsr = 3;//经手人
    int bm = 4;//部门
    int wldw = 5;//往来单位
    int rq = 6;//日期
    int cq = 7;//仓库
    if([@"1" isEqual:[[self setting] objectForKey:@"ISBS"]]){   //区分BS帐套
        wldw = 3;//往来单位
        jsr = 4;//经手人
        bm = 5;//部门
        cq = 6;//仓库
//        rq = 7;//日期
    }
    
    
    if (indexPath.row == cq ){
        StockViewController *vc = (StockViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"StockViewController"];
        NSMutableArray *dic = [self.allInfo objectForKey:key];
        if (!dic){
            dic = [NSMutableArray array];
            [self.allInfo setObject:dic forKey:key];
        }
        vc.info = dic;
        vc.parentVC = self;
        [self.parentVC.navigationController pushViewController:vc animated:YES];
        return NO;
    }else if (indexPath.row == 0){
        if (self.bEdit) return NO;
        CangKuViewController *vc = (CangKuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CangKuViewController"];
        NSMutableArray *dic = [self.allInfo objectForKey:key];
        if (!dic){
            dic = [NSMutableArray array];
            [self.allInfo setObject:dic forKey:key];
        }
        self.bClean = YES;
        vc.info = dic;
        vc.title = @"选择单据类型";
        vc.result = @[@[@"5",@"进货订单"],@[@"6",@"销售订单"]];
        vc.parentVC = self;
        
        [self.parentVC.navigationController pushViewController:vc animated:YES];
        return NO;
    }else if (indexPath.row == 2){
        //        NSArray *arr1 = [self.allInfo objectForKey:@"0"];
        //        NSArray *arr2 = [self.allInfo objectForKey:@"1"];
        //        NSUInteger function = [[arr1 ingoreObjectAtIndex:0] intValue] == 5?67:68;
        //        NSString *param = [NSString  stringWithFormat:@"'%@',1",[arr2 ingoreObjectAtIndex:1]];
        //        NSString *link=  [self GetLinkWithFunction:function andParam:param];
        //        __block XinZenHeaderViewController *tempSelf = self;
        //        [self StartQuery:link completeBlock:^(id obj) {
        //            NSArray *rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        //            if ([rs count]>0){
        //                NSArray *arr = @[@"0",[[rs objectAtIndex:0] objectAtIndex:0]];
        //                [tempSelf.allInfo setObject:arr forKey:key];
        //                [tempSelf.tableView reloadData];
        //            }
        //        } lock:YES];
        return YES;
    }else if (indexPath.row == jsr){
        SaleViewController *vc = (SaleViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SaleViewController"];
        NSMutableArray *dic = [self.allInfo objectForKey:key];
        if (!dic){
            dic = [NSMutableArray array];
            [self.allInfo setObject:dic forKey:key];
        }
        
        if ([self.setting intForKey:@"ISBS"] == 1 ) {//BS 带出部门信息
            NSMutableArray *dpInfo = [self.allInfo objectForKey:@"5"];
            if (!dic){
                dpInfo = [NSMutableArray array];
                [self.allInfo setObject:dpInfo forKey:@"5"];
            }
            vc.departMentInfo = dpInfo;
        }
        
        vc.info = dic;
        vc.parentVC = self;
        [self.parentVC.navigationController pushViewController:vc animated:YES];
        return NO;
    }else if (indexPath.row == bm){
        DepartmentViewController *vc = (DepartmentViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DepartmentViewController"];
        NSMutableArray *dic = [self.allInfo objectForKey:key];
        if (!dic){
            dic = [NSMutableArray array];
            [self.allInfo setObject:dic forKey:key];
        }
        vc.info = dic;
        vc.parentVC = self;
        [self.parentVC.navigationController pushViewController:vc animated:YES];
        return NO;
    }else if (indexPath.row == wldw){
        NSMutableArray *dic = [self.allInfo objectForKey:key];
        if (!dic){
            dic = [NSMutableArray array];
            [self.allInfo setObject:dic forKey:key];
        }
        CustomerListViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"CustomerListViewController"];
        NSArray *orderType = [self.allInfo objectForKey:@"0"];
        if ([[orderType objectAtIndex:0] integerValue] == 5)
            vc.CustomerType = 4;
        else
            vc.CustomerType = 3;
        vc.customerInfo = dic;
        vc.bSelect = YES;
        vc.parentVC = self;
        [self.parentVC.navigationController pushViewController:vc animated:YES];
        
        return NO;
    }else if (indexPath.row == 8){
        AccountViewController *vc = (AccountViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
        NSMutableArray *dic = [self.allInfo objectForKey:key];
        if (!dic){
            dic = [NSMutableArray array];
            [self.allInfo setObject:dic forKey:key];
        }
        
        NSArray *arr2 = [self.allInfo objectForKey:@"5"];
        if(arr2){
            vc.info = dic;
            vc.showIndex = 2;
            vc.title = @"帐户选择";
            
            NSString *unitID = [arr2 ingoreObjectAtIndex:2];    //往来单位ID
            if( nil == unitID || [@"" isEqual:unitID] ){
                unitID = @"0";
            }
            
            NSString *param = [NSString  stringWithFormat:@"1,0,%@,1",unitID];
            vc.link = [self GetLinkWithFunction:75 andParam:param];
            vc.parentVC = self;
            [self.parentVC.navigationController pushViewController:vc animated:YES];
        }else{
            [self.view makeToast:@"请选择往来单位"];
        }
        return NO;
    }else if(indexPath.row == 11){
        SaleViewController *vc = (SaleViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SaleViewController"];
        NSMutableArray *dic = [self.allInfo objectForKey:key];
        if (!dic){
            dic = [NSMutableArray array];
            [self.allInfo setObject:dic forKey:key];
        }
        
        vc.info = dic;
        vc.parentVC = self;
        [self.parentVC.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    
    else if(indexPath.row == 1 || indexPath.row == rq){//单据日期，取货日期
        RCDateView *dateView =  [[[RCDateView alloc]init] autorelease];
        [dateView ShowViewInObject:self.view withMsg:nil];
        while(dateView.isVisiable) {
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        }
        if (dateView.isOk){
            //判断单据日期 是否小于 取货日期-------------------
            NSString *msg = @"取货日期不能小于单据日期";
            NSArray *arr1 = [self.allInfo objectForKey:@"1"];//单据日期
            NSString *dj = [arr1 objectAtIndex:1];
            
            NSArray *arr2 = [self.allInfo objectForKey:[NSString stringWithFormat:@"%d",rq]];//取货日期
            NSString *qh = @"";
            if ([arr2 count] != 0) {
                qh = [arr2 objectAtIndex:1];
            }
            
            if(indexPath.row == 1){
                dj = dateView.strDate;
                
                if ([arr2 count] != 0) {
                    if([qh compare:dj] == -1){
                        [self ShowMessage:msg];
                        return NO;
                    }
                }
            }else{
                qh = dateView.strDate;
                
                if([qh compare:dj] == -1){
                    [self ShowMessage:msg];
                    return NO;
                }
            }
            //判断单据日期 是否小于 取货日期-------------------
            
            
            //            loadNo = indexPath.row == 1;
            textField.text = dateView.strDate;
            NSString *key = [NSString stringWithFormat:@"%d",indexPath.row];
            NSArray *arr = @[@"0",textField.text];
            [self.allInfo setObject:arr forKey:key];
            if (indexPath.row == 1){
                loadNo = YES;
                [self loadInvoiceNo];
            }
        }
        return NO;
    }
    //    else if (indexPath.row == 10)
    //    {
    //        textField.keyboardType = UIKeyboardTypeNumberPad;
    //    }
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 280, 0);
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    UITableViewCell *cell = [self GetSuperCell:textField];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // fixBug 输入判断
    //得到输入框的内容
    if (indexPath.row == 10) {
        // add 判断条件
        NSString *str = [NSString stringWithString:textField.text];
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
        if ([textField.text doubleValue] >= 1000000000) {
            [self ShowMessage:@"整数位数不能超过9位"];
            return;
        }
    }
    
    NSString *key = [NSString stringWithFormat:@"%d",indexPath.row];
    NSArray *arr = @[@"0",textField.text];
    [self.allInfo setObject:arr forKey:key];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    UITableViewCell *cell = [self GetSuperCell:textField];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // fixBug 输入判断
    
    //得到输入框的内容
    if (indexPath.row == 10) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        
        if (![string isEqualToString:filtered]) {
            [self ShowMessage:@"请输入正确数字"];
            return NO;
        }
    }
    return YES;
    
}


-(void)dealloc{
    self.allInfo =  nil;
    [_tableView release];
    [super dealloc];
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
