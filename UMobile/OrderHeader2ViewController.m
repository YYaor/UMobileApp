//
//  OrderHeader2ViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/12/1.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "OrderHeader2ViewController.h"

@interface OrderHeader2ViewController ()

@end

@implementation OrderHeader2ViewController

@synthesize info,result;
@synthesize keyIndex;
@synthesize types;
@synthesize footKeys;

- (void)viewDidLoad {
    [super viewDidLoad];
    callFunction = [[self.types ingoreObjectAtIndex:2] integerValue];
    if (callFunction == 118 || callFunction == 119 || callFunction == 102  || callFunction == 128 || callFunction == 129) {
        self.keys = @[@"3",@"2",@"8",@"12"];
    }else if (callFunction == 103){
        if([self.setting intForKey:@"ISBS"] == 1)
            self.keys = @[@"3",@"2",@"8",@"12"];
        else
            self.keys = @[@"3",@"2",@"8",@"24",@"25",@"12"];
    }else if (callFunction == 104 || callFunction == 105){
        self.keys = @[@"3",@"2",@"8",@"24",@"25",@"12"];
    }
    else{
        self.keys = @[@"3",@"2",@"8",@"18",@"12"];
    }
    self.footKeys = @[@"5",@"4",@"6",@"7",@"26",@"10",@"11",@"27"];
    [self setHeaderRefresh:self.tableView];
    // Do any additional setup after loading the view.
}

-(void)headerRereshing{
    NSString *param = [NSString stringWithFormat:@"%@,%@,%@,1",
                       [self.keyIndex objectAtIndex:0],
                       [self.keyIndex objectAtIndex:1],
                       [self.keyIndex objectAtIndex:2]];
    
    NSString *link =  [self GetLinkWithFunction:57 andParam:param];
    
    __block OrderHeader2ViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        [tempSelf.tableView headerEndRefreshing];
        NSArray *rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
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
        
        if (callFunction == 6) {
            return 160;
        }else if(callFunction == 118 || callFunction == 119 || callFunction == 128 || callFunction == 129 || callFunction == 102 || callFunction == 103){
            return 100;
        }else if (callFunction == 104 || callFunction == 105){
            return 135;
        }else{
            return 125;
        }
    }else{
        
        return [@[@"120",@"120",@"100"][indexPath.row] floatValue];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (callFunction == 102 || callFunction == 105)
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
        
        if(callFunction == 118 || callFunction == 119 || callFunction == 128 || callFunction == 129 || callFunction == 102  || callFunction == 128 || callFunction == 129)
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell4"];
        else if (callFunction == 103)
            if ([self.setting intForKey:@"ISBS"] == 1)
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell4"];
            else
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell6"];
        else if (callFunction == 104)
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell5"];
        else if (callFunction == 105)
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell6"];
        else
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        
        if (self.yjType == 5 || self.yjType == 6) {
            if (self.yjType == 5) {
                [self setText:@"进货商信息" forView:cell withTag:999];
            }else{
                [self setText:@"销售商信息" forView:cell withTag:999];
            }
            
        }else {
            [self setText:[NSString stringWithFormat:@"%@信息",[self.types objectAtIndex:0]] forView:cell withTag:999];
        }
        for (int i = 1; i < [self.keys count] + 1; i ++){
            NSString *value = [self.result objectAtIndex:[[self.keys objectAtIndex:i - 1] integerValue]];
            [self setText:value forView:cell withTag:i];
            
        }
        
    }else{
        if (callFunction == 102 || callFunction == 105){
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell3"];
        }else{
            NSString *identify = [NSString stringWithFormat:@"Cell%d",indexPath.row + 1];
            cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
            NSString *name = [[self.types ingoreObjectAtIndex:1] integerValue] == 0?@"供应商信息":@"往来单位信息";
            [self setText:name forView:cell withTag:999];
        }

        
        for (int i = 1; i < [self.footKeys count] + 1; i ++){
            [self setText:[self.result objectAtIndex:[[self.footKeys objectAtIndex:i - 1] integerValue]] forView:cell withTag:i];
        }
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self.tableView rectForRowAtIndexPath:indexPath];
        NSArray *menus = @[
                           [KxMenuItem menuItem:@"拨打电话" image:[UIImage imageNamed:@"guhua"] target:self action:@selector(basicInfoClick:)],
                           [KxMenuItem menuItem:@"拨打手机" image:[UIImage imageNamed:@"popup_icon_phone"] target:self action:@selector(basicInfoClick:)],
                           [KxMenuItem menuItem:@"发送短信" image:[UIImage imageNamed:@"popup_icon_msg"] target:self action:@selector(basicInfoClick:)],
                           ];
        [KxMenu showMenuInView:self.view fromRect:[self.tableView rectForRowAtIndexPath:indexPath] menuItems:menus];
    }else if(indexPath.row == 2){
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSArray *menus = @[
                           [KxMenuItem menuItem:@"拨打电话" image:[UIImage imageNamed:@"guhua"] target:self action:@selector(addressInfoClick:)],
                           [KxMenuItem menuItem:@"拨打手机" image:[UIImage imageNamed:@"popup_icon_phone"] target:self action:@selector(addressInfoClick:)],
                           [KxMenuItem menuItem:@"发送短信" image:[UIImage imageNamed:@"popup_icon_msg"] target:self action:@selector(addressInfoClick:)],
                           ];
        [KxMenu showMenuInView:self.view fromRect:[self.tableView rectForRowAtIndexPath:indexPath] menuItems:menus];
    }
}

-(void)basicInfoClick:(KxMenuItem *)item{
    NSDictionary *dic =@{@"拨打电话":@"1",@"拨打手机":@"2",@"发送短信":@"3"};
    switch ([dic intForKey:item.title]) {
        case 1:
            [self callANumber:[self.result objectAtIndex:7]];
            break;
        case 2:
            [self callANumber:[self.result objectAtIndex:26]];
            break;
        case 3:
            [self sendToNumber:[self.result objectAtIndex:26]];
            break;
        default:
            break;
    }
}

-(void)addressInfoClick:(KxMenuItem *)item{
    NSDictionary *dic =@{@"拨打电话":@"1",@"拨打手机":@"2",@"发送短信":@"3"};
    switch ([dic intForKey:item.title]) {
        case 1:
            [self callANumber:[self.result objectAtIndex:11]];
            break;
        case 2:
            [self callANumber:[self.result objectAtIndex:27]];
            break;
        case 3:
            [self sendToNumber:[self.result objectAtIndex:27]];
            break;
        default:
            break;
    }
}

-(void)dealloc{
    self.footKeys = nil;
    self.types = nil;
    self.info = nil;
    self.result = nil;
    [_tableView release];
    [super dealloc];
}


@end
