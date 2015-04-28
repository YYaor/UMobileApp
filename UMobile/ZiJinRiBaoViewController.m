//
//  ZiJinRiBaoViewController.m
//  UMobile
//
//  资金日报
//
//  Created by  APPLE on 2014/9/19.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "ZiJinRiBaoViewController.h"

@interface ZiJinRiBaoViewController ()

@end

@implementation ZiJinRiBaoViewController

@synthesize result;

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
    self.result  = [NSMutableArray array];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)loadData{
    NSString * param=[NSString stringWithFormat:@"'%@',%@",[self GetCurrentDate],[self GetUserID]];
    NSString *link = [self GetLinkWithFunction:15 andParam:param];
    __block ZiJinRiBaoViewController *tempSelf = self;
    
    [self StartQuery:link completeBlock:^(id obj) {
        NSArray * rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [tempSelf.result removeAllObjects];
        [tempSelf.tableView headerEndRefreshing];
        [tempSelf.result addObjectsFromArray:rs];
        [tempSelf.tableView reloadData];
    } lock:NO];
}


-(NSMutableArray *)explainToPercent:(NSArray *)arr toIndex:(NSInteger)index{
    NSMutableArray *rs =  [NSMutableArray array];
    CGFloat total = 0;
    for (int i = 0 ; i < index + 1 ; i ++){
        total += [[arr objectAtIndex:i] floatValue];
    }
    
    NSArray *titles = @[@"现金",@"银行存款",@"库存金额"];
    for (int i =0 ; i < index + 1 ; i ++){
        // change fabs(number)  20150126
        NSDictionary *item = @{@"Title": [titles objectAtIndex:i],
                               @"Value": [NSString stringWithFormat:@"%0.02f",[[arr objectAtIndex:i] floatValue]]};
        
        [rs addObject:item];
    }
    
    return rs;
}

-(void)setPieChart:(PCPieChart *)pieChart withArray:(NSArray *)Rs{

    [pieChart setSameColorLabel:YES];
    
    NSMutableArray *components =  [NSMutableArray array];
    for (int i=0; i<[Rs count]; i++)
    {
        NSDictionary *item = [Rs objectAtIndex:i];
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:[item strForKey:@"Title"] value:[[item strForKey:@"Value"] floatValue]];
        
        [components addObject:component];
        
        if (i==0)
        {
            [component setColour:PCColorYellow];
        }
        else if (i==1)
        {
            [component setColour:PCColorGreen];
        }
        else if (i==2)
        {
            [component setColour:PCColorOrange];
        }
        else if (i==3)
        {
            [component setColour:PCColorRed];
        }
        else if (i==4)
        {
            [component setColour:PCColorBlue];
        }
    }
    [pieChart setComponents:components];
}


#pragma mark -
#pragma mark table view

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.result count] > 0?3:0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.result count] > 0?1:0;;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *rs1 =  [self.result objectAtIndex:0];
    NSMutableArray *rs = [NSMutableArray array];
    
    for (int i = 0; i < rs1.count; i ++) {
        NSString *str = [rs1 objectAtIndex:i];
        double str1 = [str doubleValue];
        str = [NSString stringWithFormat:@"%0.02f", str1];
        [rs addObject:str];
    }
    NSLog(@"%@", rs);
    
    if (indexPath.row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        
        [self setText:[rs objectAtIndex:0] forView:cell withTag:1];
        [self setText:[rs objectAtIndex:1] forView:cell withTag:2];
        [self setText:[rs objectAtIndex:2] forView:cell withTag:3];
        
        
        PCPieChart *pieChart = (PCPieChart *)[cell viewWithTag:4];
        
        [self setPieChart:pieChart withArray:[self explainToPercent:rs toIndex:2]];
        
        return cell;
    }else if (indexPath.row == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        [self setText:[rs objectAtIndex:3] forView:cell withTag:1];
        [self setText:[rs objectAtIndex:4] forView:cell withTag:2];
        RCColumnView *columnView = (RCColumnView *)[cell viewWithTag:3];
        if ([[rs objectAtIndex:3] floatValue] > [[rs objectAtIndex:4] floatValue]){
            columnView.maxValue = [[rs objectAtIndex:3] floatValue] + 10;
            columnView.minValue = [[rs objectAtIndex:4] floatValue] ;
        }else{
            columnView.maxValue = [[rs objectAtIndex:4] floatValue] + 10;
            columnView.minValue = [[rs objectAtIndex:3] floatValue];
        }
        columnView.widthOfColumn = 60;
        columnView.xLabels =@[@"今日收款",@"今日付款"];
        columnView.values = @[[rs objectAtIndex:3],[rs objectAtIndex:4]];
        [columnView reloadInView];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3"];
        [self setText:[rs objectAtIndex:5] forView:cell withTag:1];
        [self setText:[rs objectAtIndex:6] forView:cell withTag:2];
        RCColumnView *columnView = (RCColumnView *)[cell viewWithTag:3];
        if ([[rs objectAtIndex:5] floatValue] > [[rs objectAtIndex:6] floatValue]){
            columnView.maxValue = [[rs objectAtIndex:5] floatValue] + 10;
            columnView.minValue = [[rs objectAtIndex:6]floatValue] ;
        }else{
            columnView.maxValue = [[rs objectAtIndex:6] floatValue] + 10;
            columnView.minValue = [[rs objectAtIndex:5] floatValue];
        }
        columnView.numYIntervals = 2;
        columnView.widthOfColumn = 60;
        columnView.xLabels =@[@"今日销售总额",@"今日采购总额"];
        columnView.values = @[[rs objectAtIndex:5],[rs objectAtIndex:6]];
        [columnView reloadInView];
        return cell;
    }
    
    

    
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

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (IBAction)buttonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = [self GetSuperCell:sender];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSString *tag = [NSString stringWithFormat:@"%d",indexPath.row * 10 + button.tag];//1001,1002,1003,1011,1012,1021,1022;
    NSDictionary *function = @{@"1001":@"16",@"1002":@"17",@"1003":@"18",@"1011":@"19",@"1012":@"20",@"1021":@"21",@"1022":@"22"};
    //NSDictionary *names = @{@"1001":@"现金银行余额表",@"1002":@"现金银行余额表",@"1003":@"库存金额汇总",@"1011":@"收款单统计表",@"1012":@"付款单统计表",@"1021":@"今日销售列表",@"1022":@"进货单统计表"};
    NSDictionary *names = @{@"1001":@"现金银行余额表",@"1002":@"现金银行余额表",@"1003":@"库存金额汇总",@"1011":@"今日收款",@"1012":@"今日付款",@"1021":@"今日销售列表",@"1022":@"今日采购列表"};
    
    if ([function intForKey:tag] == 18){
        RiBaoDtlViewController *vc =(RiBaoDtlViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"RiBaoDtlViewController"];
        vc.callFunction = [function intForKey:tag];
        vc.navTitle = [names strForKey:tag];
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }else{
        
        ZiJinRiBaoDtlViewController *vc =(ZiJinRiBaoDtlViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"ZiJinRiBaoDtlViewController"];
        vc.callFunction = [function intForKey:tag];
        vc.navTitle = [names strForKey:tag];
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }
}
@end
