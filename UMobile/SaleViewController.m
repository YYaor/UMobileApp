//
//  SaleViewController.m
//  UMobile
//
//  Created by Rid on 14/12/30.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "SaleViewController.h"

@implementation SaleViewController

@synthesize result;
@synthesize selectId;
@synthesize delegate;

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setupRefresh:self.tableView];
    [self.tableView headerBeginRefreshing];
    
    self.selectId = @"0";
    self.result = [NSMutableArray array];
    leftView =  [[LeftView alloc]init];
    leftView.delegate = self;
    leftView.width = 150;
    leftView.link = [self GetLinkWithFunction:63 andParam:[NSString stringWithFormat:@"'',2,0,1,%@",[self GetUserID]]];
    [leftView setMainView:self.view];
}
- (IBAction)leftClick:(id)sender {
    [leftView layoutLeftView];
}


-(void)leftViewClickWithInfo:(NSArray *)info{
    if([[info objectAtIndex:0] isEqualToString:@"0"])
        self.selectId = @"0";
    else
        self.selectId = [info objectAtIndex:2];
    [self.tableView headerBeginRefreshing];
}

-(void)headerRereshing{
    page = 1 ;
    NSString *link = [self GetLinkWithFunction:63 andParam:[NSString stringWithFormat:@"'%@',0,%@,1,%@,20,%d",[self.searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.selectId,[self GetUserID],page]] ;
    [self setFooterRefresh:self.tableView];
    
    __block SaleViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [tempSelf.result removeAllObjects];
        [tempSelf.result addObjectsFromArray:rs];
        
        [tempSelf.tableView reloadData];
        [tempSelf.tableView headerEndRefreshing];
    } lock:NO];
}

-(void)footerRereshing{
    page ++ ;
    NSString *link =  [self GetLinkWithFunction:63 andParam:[NSString stringWithFormat:@"'%@',0,%@,1,%@,20,%d",[self.searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.selectId,[self GetUserID],page]] ;
    __block SaleViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
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

#pragma mark searchBar
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
#pragma mark table view

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.result count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray *rs = [self.result objectAtIndex:indexPath.row];
    [self setText:[rs objectAtIndex:0] forView:cell withTag:1];
    [self setText:[rs objectAtIndex:1] forView:cell withTag:2];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *rs = [self.result objectAtIndex:indexPath.row];
    [self.info removeAllObjects];
    [self.info addObjectsFromArray:@[[rs objectAtIndex:2],[rs objectAtIndex:1],[rs ingoreObjectAtIndex:2]]];
    
    [self.departMentInfo removeAllObjects];
    [self.departMentInfo addObjectsFromArray:@[[rs objectAtIndex:4],[rs objectAtIndex:5],[rs objectAtIndex:4]]];
    
    [self.parentVC performSelector:@selector(loadData) withObject:nil];
    if (delegate && [delegate respondsToSelector:@selector(salesmanSelectedWithSalesId:salesName:)]){
        [delegate salesmanSelectedWithSalesId:[[rs objectAtIndex:0] integerValue]  salesName:[rs objectAtIndex:1]];
    }
    [self dismiss];
}

- (void)dealloc {
    self.selectId = nil;
    self.result = nil;
    [_tableView release];
    [_searchBar release];
    [_info release];
    [_departMentInfo release];
    [super dealloc];
}


@end
