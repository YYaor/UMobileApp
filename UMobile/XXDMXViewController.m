//
//  XXDMXViewController.m
//  UMobile
//
//  Created by Rid on 15/1/25.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "XXDMXViewController.h"

@implementation XXDMXViewController

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView initContent];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    page = 1;
    self.tableView.bCountTotal = YES;

    self.tableView.titles = @[@"商品名称",@"规格",@"型号",@"单位",@"数量",@"单价",@"折后金额"];
    self.tableView.titleWidths = @[@"150",@"100",@"100",@"100",@"100",@"100",@"100"];
    self.tableView.countColumns = @[@"0",@"0",@"0",@"0",@"1",@"0",@"1"];
    
    self.tableView.rDelegate = self;
    
    self.result = [NSMutableArray array];
    
    bNoID = [self.strID length] == 0;
    if (bNoID) {
        self.tableView.keys = @[@"3",@"7",@"8",@"5",@"9",@"10",@"13"];
        [self searchInvoice];
    }else{
        self.tableView.keys = @[@"7",@"11",@"12",@"9",@"8",@"10",@"15"];
        [self loadData];
    }
    self.tableView.bFooterRefreshing = !bNoID; //没有ID，用另一参数查询产品明细时，会直接查询所有，不需要加载更多

}

-(void)loadData{
    NSString *param = [NSString stringWithFormat:@"20,%d,0,'','%@',3,2,%@,'%@',%@",page,[self GetCurrentDate],self.strID,self.invNo,[self GetUserID]];
    NSString *link = [self GetLinkWithFunction:31 andParam:param];
    
    __block XXDMXViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        [tempSelf.tableView footerEndRefreshing];
        NSDictionary *info = [obj objectFromJSONString];
        if (!info) {
            [tempSelf ShowMessage:@"获取数据失败，请检查网络"];
            [tempSelf.navigationController popViewControllerAnimated:YES];
        }else{
            NSArray *rs = [info objectForKey:@"D_Data"];
            
            if ([rs count] > 0) {
                NSArray *rsd = [rs objectAtIndex:0];
                [tempSelf setText:[rsd objectAtIndex:0] forView:tempSelf.view withTag:1];
                [tempSelf setText:self.strDate forView:tempSelf.view withTag:2];
                [tempSelf setText:[rsd objectAtIndex:1] forView:tempSelf.view withTag:3];
                [tempSelf setText:[rsd objectAtIndex:3] forView:tempSelf.view withTag:4];
                [tempSelf.result addObjectsFromArray:rs];
            }else{
                page -- ;
            }
            tempSelf.tableView.result = self.result;
        }
    } lock:YES];
}

-(void)searchInvoice{
    
    __block XXDMXViewController *tempSelf = self;
    
    NSString *param = [NSString stringWithFormat:@"'','',6,'%@',0,0,0,0,%@,'',20,1",self.invNo,[self GetUserID]];
    NSString *link = [self GetLinkWithFunction:72 andParam:param];
    [self StartQuery:link completeBlock:^(id obj) {
        NSDictionary *info = [obj objectFromJSONString];
        if (!info) {
            [tempSelf ShowMessage:@"获取数据失败，请检查网络"];
            [tempSelf.navigationController popViewControllerAnimated:YES];
        }else{
            NSArray *rs = [info objectForKey:@"D_Data"];
            if ([rs count] == 0) {
                [tempSelf ShowMessage:@"获取单据ID失败"];
                [tempSelf.navigationController popViewControllerAnimated:YES];
            }else{
                NSArray *rsd = [rs objectAtIndex:0];
                tempSelf.strID = [rsd objectAtIndex:1];
                
                [tempSelf setText:[rsd objectAtIndex:3] forView:self.view withTag:1];
                [tempSelf setText:[rsd objectAtIndex:2] forView:self.view withTag:2];
                [tempSelf setText:[rsd objectAtIndex:0] forView:self.view withTag:3];
                [tempSelf setText:[rsd objectAtIndex:5] forView:self.view withTag:4];
                [tempSelf loadResult];
            }
        }
    } lock:YES];
}

-(void)loadResult{
    NSString *param = [NSString stringWithFormat:@"6,2,%@,%@",self.strID,[self GetUserID]];
    NSString *link = [self GetLinkWithFunction:58 andParam:param];
    
    __block XXDMXViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        [tempSelf.tableView footerEndRefreshing];
        NSDictionary *info = [obj objectFromJSONString];
        if (!info) {
            [tempSelf ShowMessage:@"获取数据失败，请检查网络"];
            [tempSelf.navigationController popViewControllerAnimated:YES];
        }else{
            NSArray *rs = [info objectForKey:@"D_Data"];
            
            if ([rs count] > 0) {
                [tempSelf.result addObjectsFromArray:rs];
            }else{
                page -- ;
            }
            tempSelf.tableView.result = self.result;

        }
    } lock:YES];
}

-(void)tableFooterRefreshing{
    page ++;
    if (bNoID)
        [self loadResult];
    else
        [self loadData];
}


- (void)dealloc {
    self.invNo = nil;
    self.strID = nil;
    self.strDate = nil;
    self.result = nil;
    [_tableView release];
    [super dealloc];
}
@end
