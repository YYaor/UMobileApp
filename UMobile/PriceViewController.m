//
//  PriceViewController.m
//  UMobile
//
//  Created by Rid on 14/12/11.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "PriceViewController.h"

@interface PriceViewController ()

@end

@implementation PriceViewController

@synthesize keys,result,productInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHeaderRefresh:self.tableView];
    
    self.matchKeys = @{@"价格1":@"商品预设售价1",@"价格2":@"商品预设售价2",@"价格3":@"商品预设售价3",@"价格4":@"商品预设售价4",@"价格5":@"商品预设售价5",
                       @"价格6":@"商品预设售价6",@"价格7":@"商品预设售价7",@"价格8":@"商品预设售价8",@"价格9":@"商品预设售价9",@"价格10":@"商品预设售价10",
                       @"零售价":@"商品零售价",@"最近进价":@"商品最近进价",@"最近售价":@"商品最近售价",@"会员价":@"商品会员价",@"最低售价":@"商品最低售价"};
    
    [self.tableView headerBeginRefreshing];
    // Do any additional setup after loading the view.
}

-(void)headerRereshing{
    NSString *param = [NSString stringWithFormat:@"%@,%@,%@",[self.productInfo strForKey:@"商品ID"],[self.productInfo strForKey:@"单位ID"],[self GetUserID]];
    NSString *link =  [self GetLinkWithFunction:66 andParam:param];
    __block PriceViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        [tempSelf.tableView headerEndRefreshing];
        NSDictionary *info = [obj objectFromJSONString];
        NSArray *rs1 = [info objectForKey:@"D_Data"];
        NSArray *rs2 = [info objectForKey:@"D_Fields"];
        if ([rs1 count] > 0)
            tempSelf.result = [rs1 objectAtIndex:0];
        if ([rs2 count] > 0)
            tempSelf.keys = rs2;
        [tempSelf.tableView reloadData];
    } lock:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSInteger index = indexPath.row + 2;
    [self setText:[self.keys keyObjectAtIndex:index] forView:cell withTag:1];
    
    if ([self checkRight:[self.matchKeys strForKey:[self.keys keyObjectAtIndex:indexPath.row + 2]]])
        [self setText:[self.result objectAtIndex:index] forView:cell withTag:2];
    else
        [self setText:@"***" forView:cell withTag:2];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.result count] - 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    [self.productInfo replaceObjectAtIndex:16 withObject:[self.result objectAtIndex:indexPath.row + 2]];
    
    if ([self checkRight:[self.matchKeys strForKey:[self.keys keyObjectAtIndex:indexPath.row + 2]]])
        [self.productInfo setObject:[self.result objectAtIndex:indexPath.row + 2] forKey:@"单价"];
    
    [self.parentVC performSelector:@selector(loadData) withObject:nil];
    [self dismiss];
    
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)dealloc {
    self.matchKeys = nil;
    self.keys = nil;
    self.result = nil;
    [_tableView release];
    [super dealloc];
}
@end
