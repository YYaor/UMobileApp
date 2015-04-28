//
//  YuJingOrderViewController.m
//  UMobile
//
//  Created by Rid on 15/1/6.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "YuJingOrderViewController.h"

@interface YuJingOrderViewController ()

@end

@implementation YuJingOrderViewController

@synthesize result;
@synthesize callFunction;
@synthesize keys;

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
    
    self.result =  [NSMutableArray array];
    [self setupRefresh:self.tableView];
    [self.tableView headerBeginRefreshing];
    if (self.callFunction == 5) {
        [self.titleButton setTitle:@"进货订单" forState:UIControlStateNormal];
    }else{
        [self.titleButton setTitle:@"销售订单" forState:UIControlStateNormal];
    }
    
    self.titleButton.titleLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    self.titleButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    self.titleButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:17.0];
    self.titleButton.titleLabel.textColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self.titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

-(void)sortMenuClick:(KxMenuItem *)item{
    NSUInteger index = 0;
    NSComparator cmptr;
    if ([item.title isEqualToString:@"按进货商"]) {
        index = 0;//供应商名称
        bNameAsc = !bNameAsc;
    }else{
        index = 5;//日期 index
        bDateAsc = !bDateAsc;
    }
    cmptr = ^(id obj1, id obj2){
        if (index == 5){
            if (bDateAsc)
                return [[obj1 objectAtIndex:index] compare:[obj2 objectAtIndex:index] options:NSDiacriticInsensitiveSearch];//去除-比较
            else
                return [[obj2 objectAtIndex:index] compare:[obj1 objectAtIndex:index] options:NSDiacriticInsensitiveSearch];
        }else{
            NSString *c1 = [self phonetic:[obj1 objectAtIndex:index]];
            NSString *c2 = [self phonetic:[obj2 objectAtIndex:index]];
            if (bNameAsc)
                return [c1 compare:c2 options:NSLiteralSearch];
            else
                return [c2 compare:c1 options:NSLiteralSearch];
        }

    };

    [self.result sortUsingComparator:cmptr];

    [self.tableView reloadData];
}

- (NSString *) phonetic:(NSString*)sourceString {
    //转换成拼音
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;
}


-(void)titleButtonClick:(id)sender{
    NSArray *menus = @[
                       [KxMenuItem menuItem:@"按进货商" image:[UIImage imageNamed:@"popup_icon_approve_date"] target:self action:@selector(sortMenuClick:)],
                       [KxMenuItem menuItem:@"按日期" image:[UIImage imageNamed:@"popup_icon_approve_curweek"] target:self action:@selector(sortMenuClick:)]
                       ];
    [KxMenu showMenuInView:self.view fromRect:CGRectMake(160, 64, 10, 1) menuItems:menus];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark refresh

-(NSString *)GetUrlLink{
    NSString *link = nil;
    if (self.callFunction == 3 | self.callFunction == 4) {
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,'','',1",page]];
    }else{
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,'%@','%@',1",page,[self GetSystemDate],[self.searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    return link;
}

-(void)headerRereshing{
    page = 1;
    
    [self setFooterRefresh:self.tableView];
    
    __block YuJingOrderViewController *tempSelf = self;
    [self StartQuery:[self GetUrlLink] completeBlock:^(id obj) {
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        tempSelf.keys =  [[obj objectFromJSONString] objectForKey:@"D_Fields"];
        [tempSelf.result removeAllObjects];
        [tempSelf.result addObjectsFromArray:rs];
        
        [tempSelf.tableView reloadData];
        [tempSelf.tableView headerEndRefreshing];
    } lock:NO];
}

-(void)footerRereshing{
    page ++ ;
    
    __block YuJingOrderViewController *tempSelf = self;
    
    [self StartQuery:[self GetUrlLink] completeBlock:^(id obj) {
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        
        if ([rs count] > 0) {
            
            [tempSelf.result addObjectsFromArray:rs];
            [tempSelf.tableView reloadData];
            [tempSelf.tableView footerEndRefreshing];
        }else{
            [tempSelf.tableView footerEndRefreshing];
            [tempSelf.tableView  removeFooter];
        }
        
        
    } lock:NO];
}

#pragma mark -
#pragma mark table view

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.callFunction == 7) {
        YuJingSPViewController *vc = (YuJingSPViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"YuJingSPViewController"];
        vc.info = [self.result objectAtIndex:indexPath.row];

        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.callFunction == 3 || self.callFunction == 4){
        YuJingDDViewController *vc = (YuJingDDViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"YuJingDDViewController"];
        vc.info = [self.result objectAtIndex:indexPath.row];
        vc.type = self.callFunction;
        vc.yjType = self.yjType;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.callFunction == 5 || self.callFunction == 6){
        NSArray *info = [self.result objectAtIndex:indexPath.row];
        OrderDetailNoCheckViewController *vc = (OrderDetailNoCheckViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailNoCheckViewController"];
        vc.info = info;// [self.result objectAtIndex:indexPath.row];
        vc.keyIndex = @[[info objectAtIndex:3],@"2",[info objectAtIndex:2]];
        vc.callFunction = self.callFunction;
        vc.yjType = self.yjType;
        vc.types = @[self.navigationItem.title,[NSString stringWithFormat:@"%d",1],[NSString stringWithFormat:@"%d",self.callFunction]];
        vc.navigationItem.title =  [NSString stringWithFormat:@"%@详情",self.navigationItem.title];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [@[@"80",@"80",@"90",@"90",@"90",@"90",@"65",@"80",@"80"][self.callFunction - 1] floatValue];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.result count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    //    }
    NSArray *rs =  [self.result objectAtIndex:indexPath.row];
    if (self.callFunction == 1 | self.callFunction == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        [self setText:[rs objectAtIndex:1] forView:cell withTag:1];
        [self setText:[rs objectAtIndex:2] forView:cell withTag:2];
        [self setText:[rs objectAtIndex:3] forView:cell withTag:3];
        [self setText:[rs objectAtIndex:0] forView:cell withTag:4];
        [self setText:[rs objectAtIndex:4] forView:cell withTag:5];
        [self setText:[rs objectAtIndex:5] forView:cell withTag:6];
        [self setText:[rs objectAtIndex:6] forView:cell withTag:7];
    }else if (self.callFunction == 7){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        [self setText:[rs objectAtIndex:1] forView:cell withTag:1];
        [self setText:[rs objectAtIndex:0] forView:cell withTag:2];
        [self setText:[rs objectAtIndex:5] forView:cell withTag:3];
    }else if (self.callFunction == 8){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell4"];
        [self setText:[NSString stringWithFormat:@"%@:%@",[self.keys keyObjectAtIndex:1],[rs ingoreObjectAtIndex:1]] forView:cell withTag:1];
        [self setText:[NSString stringWithFormat:@"%@:%@",[self.keys keyObjectAtIndex:4],[rs ingoreObjectAtIndex:4]] forView:cell withTag:2];
        [self setText:[NSString stringWithFormat:@"%@:%@",[self.keys keyObjectAtIndex:3],[rs ingoreObjectAtIndex:3]] forView:cell withTag:3];
        [self setText:[NSString stringWithFormat:@"%@:%@",[self.keys keyObjectAtIndex:2],[rs ingoreObjectAtIndex:2]] forView:cell withTag:4];
    }else if (self.callFunction == 9){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3"];
        [self setText:[rs objectAtIndex:0] forView:cell withTag:1];
        [self setText:[rs objectAtIndex:1] forView:cell withTag:2];
        [self setText:[rs objectAtIndex:2] forView:cell withTag:3];
        [self setText:[rs objectAtIndex:3] forView:cell withTag:4];
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell4"];
        
        if (self.callFunction == 5 || self.callFunction == 6) {
            [self setText:[rs ingoreObjectAtIndex:0] forView:cell withTag:1];
            NSString *lb =  [NSString stringWithFormat:@"%@:%@",[self.keys keyObjectAtIndex:1],[rs objectAtIndex:1]];
            [self setText:lb forView:cell withTag:2];
            [self setText:[rs ingoreObjectAtIndex:5] forView:cell withTag:3];
            [self setText:[rs ingoreObjectAtIndex:6] forView:cell withTag:6];
            
        }else{
            [self setText:[rs ingoreObjectAtIndex:0] forView:cell withTag:1];
            [self setText:[rs ingoreObjectAtIndex:6] forView:cell withTag:2];
            [self setText:[rs ingoreObjectAtIndex:5] forView:cell withTag:3];
            
            [self setText:[rs ingoreObjectAtIndex:10] forView:cell withTag:4];
            [self setText:[self.keys keyObjectAtIndex:10] forView:cell withTag:5];
        }
    }
    return cell;
}

#pragma mark -
#pragma mark searchbar

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.tableView headerBeginRefreshing];
}


-(void)dealloc{
    self.result = nil;
    self.keys = nil;
    [_tableView release];
    [_navItem release];
    [_searchBar release];
    [_titleButton release];
    [super dealloc];
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

@end
