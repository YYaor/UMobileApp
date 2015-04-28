//
//  YuJingDtlViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/10.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "YuJingDtlViewController.h"
#import "MJRefresh.h"

@interface YuJingDtlViewController ()

@end

@implementation YuJingDtlViewController

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
    
    // Do any additional setup after loading the view.
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
//        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,'','',1",page]];
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,'','%@','%@',1",page,[self GetCurrentDate], [[self setting] objectForKey:@"UID"]]];
    }else{
        //link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,'','',1",page]];
        link = [self GetLinkWithFunction:self.callFunction andParam:[NSString stringWithFormat:@"20,%d,'','%@',0",page, [[self setting] objectForKey:@"UID"]]];
    }
    return link;
}

-(void)headerRereshing{
    page = 1;
    
    [self setFooterRefresh:self.tableView];
    
    __block YuJingDtlViewController *tempSelf = self;
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

    __block YuJingDtlViewController *tempSelf = self;
    
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
    if (self.callFunction == 7 || self.callFunction == 8) {
        YuJingSPViewController *vc = (YuJingSPViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"YuJingSPViewController"];
        vc.info = [self.result objectAtIndex:indexPath.row];
        vc.type = self.callFunction;
        vc.yjType = self.yjType;
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
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
//    }
    NSArray *rs =  [self.result objectAtIndex:indexPath.row];
    if (self.callFunction == 1 | self.callFunction == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        [self setText:[rs objectAtIndex:1] forView:cell withTag:1];
        [self setText:[rs objectAtIndex:2] forView:cell withTag:2];
        [self setText:[rs objectAtIndex:3] forView:cell withTag:3];
        [self setText:[rs objectAtIndex:0] forView:cell withTag:4];
        [self setText:[rs objectAtIndex:4] forView:cell withTag:5];
        [self setText:[rs objectAtIndex:5] forView:cell withTag:6];
        [self setText:[rs objectAtIndex:6] forView:cell withTag:7];
    }else if (self.callFunction == 7){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        [self setText:[rs objectAtIndex:1] forView:cell withTag:1];
        [self setText:[rs objectAtIndex:0] forView:cell withTag:2];
        [self setText:[rs objectAtIndex:5] forView:cell withTag:3];
    }else if (self.callFunction == 8){
        // add Cell5 for brithday check
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell5" forIndexPath:indexPath];
        [self setText:[NSString stringWithFormat:@"%@",[rs ingoreObjectAtIndex:0]] forView:cell withTag:1];
        [self setText:[NSString stringWithFormat:@"%@",[rs ingoreObjectAtIndex:1]] forView:cell withTag:2];
        [self setText:[NSString stringWithFormat:@"%@",[rs ingoreObjectAtIndex:2]] forView:cell withTag:3];


//        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell4"];
//        [self setText:[NSString stringWithFormat:@"%@:%@",[self.keys keyObjectAtIndex:1],[rs ingoreObjectAtIndex:1]] forView:cell withTag:1];
//        [self setText:[NSString stringWithFormat:@"%@:%@",[self.keys keyObjectAtIndex:4],[rs ingoreObjectAtIndex:4]] forView:cell withTag:2];
//        [self setText:[NSString stringWithFormat:@"%@:%@",[self.keys keyObjectAtIndex:3],[rs ingoreObjectAtIndex:3]] forView:cell withTag:3];
//        [self setText:[NSString stringWithFormat:@"%@:%@",[self.keys keyObjectAtIndex:2],[rs ingoreObjectAtIndex:2]] forView:cell withTag:4];
    }else if (self.callFunction == 9){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3" forIndexPath:indexPath];
        [self setText:[rs objectAtIndex:0] forView:cell withTag:1];
        [self setText:[rs objectAtIndex:1] forView:cell withTag:2];
        [self setText:[rs objectAtIndex:2] forView:cell withTag:3];
        [self setText:[rs objectAtIndex:3] forView:cell withTag:4];
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell4" forIndexPath:indexPath];
        
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
            [self setText:[NSString stringWithFormat:@"%@:",[self.keys keyObjectAtIndex:10]] forView:cell withTag:5];
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
    [self.tableView headerBeginRefreshing];
}


-(void)dealloc{
    self.result = nil;
    self.keys = nil;
    [_tableView release];
    [_navItem release];
    [_searchBar release];
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
