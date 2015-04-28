//
//  OrderHeaderViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/10/20.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "OrderHeaderViewController.h"

@interface OrderHeaderViewController ()
{
    NSArray *keys2;
    NSArray *keys3;
}

@end

@implementation OrderHeaderViewController

@synthesize info,result;
@synthesize keyIndex;
@synthesize types;
@synthesize footKeys;

- (void)viewDidLoad {
    [super viewDidLoad];
    callFunction = [[self.types ingoreObjectAtIndex:2] integerValue];
    //单据类型,单据ID,单据日期,单据编号,往来单位编号,往来单位名称,联系人,电话,金额,数量,经手人,经手人电话,制单人,库房1,库房2,摘要,附加说明,到货/取货日期,整单折让,出库金额,出库数量,入库金额,入库数量,收/付款账户id,收/付款账户,收/付款金额,往来单位手机,经手人手机,成交金额
    if (callFunction == 61 || callFunction == 14) {
        self.keys = @[@"3",@"2",@"22",@"21",@"13",@"19",@"20",@"14",@"24",@"25",@"18",@"12"];
    }else if (callFunction ==  7 || callFunction == 8){
        self.keys = @[@"3",@"2",@"9",@"8",@"13",@"14",@"0",@"2"];
        // fix  add     20150125
    }else if (callFunction == 5 || callFunction == 6){
        self.keys = @[@"3", @"2", @"17", @"13", @"10", @"8", @"24",@"25",@"12",@"18"];
        keys2 = @[@"5", @"6", @"7", @"7"];
    }else{
        self.keys = @[@"3",@"2",@"8",@"13",@"24",@"25",@"12",@"17",@"18",@"15"];
        

    }
    self.footKeys = @[@"5",@"4",@"6",@"7",@"26",@"10",@"11",@"27",@"15"];
    [self setHeaderRefresh:self.tableView];
    // Do any additional setup after loading the view.
    

}

-(void)headerRereshing{
    NSString *param;
//    if ([[self.keyIndex objectAtIndex:0] intValue] == 0) {
//        param = [NSString stringWithFormat:@"6,%@,%@,1",
//                 [self.keyIndex objectAtIndex:1],
//                 [self.keyIndex objectAtIndex:2]];
//    }else{
        param = [NSString stringWithFormat:@"%@,%@,%@,%@",
                 [self.keyIndex objectAtIndex:0],
                 [self.keyIndex objectAtIndex:1],
                 [self.keyIndex objectAtIndex:2],
                 [self GetUserID]];
//    }//hgg 20150312 当单据类型为0是查询结果错误，由于没找到单据类型出处，所以手动改为6
    
    NSString *link =  [self GetLinkWithFunction:57 andParam:param];
    __block OrderHeaderViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        [tempSelf.tableView headerEndRefreshing];
        NSArray *rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        if (rs == nil && [obj rangeOfString:@"系统繁忙"].location != NSNotFound){
            [tempSelf headerRereshing];
            return ;
        }
            
        if ([rs count]>0)
            tempSelf.result = [rs objectAtIndex:0];
        [tempSelf.tableView reloadData];
    } lock:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    if (self.result) return;
    [self.tableView headerBeginRefreshing];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark table view

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    if (indexPath.row == 0){
        // fixBug   ghd     0123
        if (callFunction == 6 || callFunction == 1 || callFunction == 5) {
            return 180;
        }else if (callFunction == 0 || callFunction == 3 || callFunction == 4){
            return 160;
        }else if (callFunction == 7 || callFunction == 8){
            return 150;
        }else if(callFunction == 61 || callFunction == 14 ){
            return 215;
        }else if (callFunction == 128){
            return 115;
        }else{
            return 160;
        }
    }else{
        return [@[@"xxx",@"120",@"100"][indexPath.row] floatValue];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(callFunction == 7 || callFunction == 8)
        return self.result?2:0;
    else
        return self.result?3:0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
} 


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 0){
        // change   || callFunction == 1
        // change   20150125
        
        //根据不同进入 方式取不同的Cell,因当前需求不清晰，调用相同接口获取的数据，在不同地方显示出来的结果需要不同，所以后来如此判断
        if (callFunction == 1) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell4"];
            if (self.shType == 1) {//销售单
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell12"];
            }
        }else if (callFunction == 0 || callFunction == 3 || callFunction == 4){
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell5"];
        }else if(callFunction == 61 || callFunction == 14){
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell6"];
        }else if (callFunction == 7 || callFunction == 8){
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell7"];
            // add
        }else if (callFunction == 5 || callFunction == 6){
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell8"];
            if (self.shType == 5 ) {//进货订单，销售订单
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell18"];
            }else if(self.shType == 6){
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell15"];
            }else if (self.yjType == 6){
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell17"];
            }else if (self.yjType == 5){
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell14"];
            }
        }else if (callFunction == 128){//预收
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell16"];
        }else{
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        }
        
        [self setText:[NSString stringWithFormat:@"%@信息",[self.types objectAtIndex:0]] forView:cell withTag:999];
        if ([[self.types objectAtIndex:2] integerValue] == 6) {
            [self setText:@"取货日期:" forView:cell withTag:888];
            [self setText:@"收款帐户:" forView:cell withTag:777];
            [self setText:@"收款金额:" forView:cell withTag:666];
        }
        
        for (int i = 1; i < [self.keys count] + 1 ; i ++){
            [self setText:[self.result ingoreObjectAtIndex:[[self.keys objectAtIndex:i - 1] integerValue]] forView:cell withTag:i];
        }
    }else{
        if (callFunction ==  7 || callFunction == 8) {
            cell =  [self.tableView dequeueReusableCellWithIdentifier:@"Cell3"];
        }else{
            
            NSString *identify = [NSString stringWithFormat:@"Cell%d",indexPath.row + 1];
            if (self.bInDDGL && indexPath.row == 2) identify = @"Cell11";
            cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
            if ((self.shType == 1 || self.shType == 5 || self.shType ==6 || self.shType == 128 || self.yjType == 5 || self.yjType == 6) && indexPath.row == 1){//销售单,进货订单，销售订单,预收
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell13"];
            }
            NSString *name = nil;
            NSString *name1 = nil;
            NSString *name2 = nil;
            switch ([[self.types ingoreObjectAtIndex:2] integerValue]) {
                case 0:
                case 3:
                case 5:
                case 61:
                    name = @"供应商信息";
                    name1 = @"供应商名称:";
                    name2 = @"供应商编号:";
                    break;
                case 128:
                case 118:
                    name = @"往来单位信息";
                    name1 = @"名称:";
                    name2 = @"编号:";
                    break;
                default:
                    name = @"客户信息";
                    name1 = @"客户名称:";
                    name2 = @"客户编号:";
                    break;
            }
            [self setText:name forView:cell withTag:999];
            [self setText:name1 forView:cell withTag:11];
            [self setText:name2 forView:cell withTag:12];
        }
        for (int i = 1; i < [self.footKeys count] + 1 ; i ++){
            [self setText:[self.result ingoreObjectAtIndex:[[self.footKeys objectAtIndex:i - 1] integerValue]] forView:cell withTag:i];
        }
    }


    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSArray *menus = @[
                           [KxMenuItem menuItem:@"拨打电话" image:[UIImage imageNamed:@"guhua"] target:self action:@selector(basicInfoClick:)],
                           [KxMenuItem menuItem:@"拨打手机" image:[UIImage imageNamed:@"popup_icon_phone"] target:self action:@selector(basicInfoClick:)],
                           [KxMenuItem menuItem:@"发送短信" image:[UIImage imageNamed:@"popup_icon_msg"] target:self action:@selector(basicInfoClick:)],
                           ];
        [KxMenu showMenuInView:self.view fromRect:cell.frame menuItems:menus];
    }else if(indexPath.row == 2 && self.bInDDGL == NO){
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSArray *menus = @[
                           [KxMenuItem menuItem:@"拨打电话" image:[UIImage imageNamed:@"guhua"] target:self action:@selector(addressInfoClick:)],
                           [KxMenuItem menuItem:@"拨打手机" image:[UIImage imageNamed:@"popup_icon_phone"] target:self action:@selector(addressInfoClick:)],
                           [KxMenuItem menuItem:@"发送短信" image:[UIImage imageNamed:@"popup_icon_msg"] target:self action:@selector(addressInfoClick:)],
                           ];
        [KxMenu showMenuInView:self.view fromRect:cell.frame menuItems:menus];
    }
}

-(void)basicInfoClick:(KxMenuItem *)item{
    NSDictionary *dic =@{@"拨打电话":@"1",@"拨打手机":@"2",@"发送短信":@"3"};
    switch ([dic intForKey:item.title]) {
        case 1:
            [self.parentVC callANumber:[self.result objectAtIndex:7]];
            break;
        case 2:
            [self.parentVC callANumber:[self.result objectAtIndex:26]];
            break;
        case 3:
            [self.parentVC sendToNumber:[self.result objectAtIndex:26]];
            break;
        default:
            break;
    }
}

-(void)addressInfoClick:(KxMenuItem *)item{
    NSDictionary *dic =@{@"拨打电话":@"1",@"拨打手机":@"2",@"发送短信":@"3"};
    switch ([dic intForKey:item.title]) {
        case 1:
            [self.parentVC callANumber:[self.result objectAtIndex:11]];
            break;
        case 2:
            [self.parentVC callANumber:[self.result objectAtIndex:27]];
            break;
        case 3:
            [self.parentVC sendToNumber:[self.result objectAtIndex:27]];
            break;
        default:
            break;
    }
}


-(void)dealloc{
    self.strID = nil;
    self.footKeys = nil;
    self.types = nil;
    self.info = nil;
    self.result = nil;
    [_tableView release];
    [super dealloc];
}

@end
