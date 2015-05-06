//
//  KCCXViewController.m
//  UMobile
//
//  Created by mocha on 15/5/6.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "KCCXViewController.h"
#import "KCLBViewController.h"

@interface KCCXViewController ()

@end

@implementation KCCXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationShow];
    self.result = [NSMutableArray array];
    [self setupRefresh:self.tableView];
    [self.tableView headerBeginRefreshing];
    // Do any additional setup after loading the view.
    
    leftView =  [[LeftView alloc]init];
    leftView.delegate = self;
    leftView.link = [self GetLinkWithFunction:76 andParam:@"20,0,1"];
    
    // fixBug   ghd     20150123
    [self StartQuery:leftView.link completeBlock:^(id obj) {
        NSLog(@"%@", obj);
        NSLog(@"%@", [[obj objectFromJSONString] objectForKey:@"D_Data"]);
    } lock:YES];
    
    [leftView setMainView:self.view];
    //    leftView.dataSource =  @[@"所有商品",@"食品饮料",@"厨房用品",@"生活电器",@"运动保障",@"图书杂志",@"进口食品"];
    if (self.searchCode) {
        self.searchBar.text = self.searchCode;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    self.searchBar.text = self.searchCode;
    [self headerRereshing];
}

-(void)headerRereshing{
    page = 1;
    NSString *link = [self GetLinkWithFunction:12 andParam:[NSString stringWithFormat:@"20,%d,%@,'%@',1",page,leftView.selectID,[self.searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    __block SPGLViewController *tempSelf = self;
    [self setFooterRefresh:self.tableView];
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
    NSString *link = [self GetLinkWithFunction:12 andParam:[NSString stringWithFormat:@"20,%d,%@,'%@',1",page,leftView.selectID,[self.searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    __block SPGLViewController *tempSelf = self;
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        if ([self.setting intForKey:@"Classics"] == 0) {
            [self.setting setObject:@"1" forKey:@"Classics"];
            [self.setting setObject:@"0" forKey:@"Simple"];
        }else{
            [self.setting setObject:@"0" forKey:@"Classics"];
            [self.setting setObject:@"1" forKey:@"Simple"];
        }
        [USER_DEFAULT setObject:self.setting forKey:@"Setting"];
        [self.tableView reloadData];
    }else if (buttonIndex == 1){
        ScanViewController *vc = (ScanViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"ScanViewController"];
        vc.parentVC = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //清除缓存，可重新下载图片
        [self clearPictureCache];
        [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (IBAction)moreClick:(id)sender {
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"刷新图片",@"扫描",@"模式切换", nil] autorelease];
    [sheet showInView:self.view];
}


- (IBAction)categoryClick:(id)sender {
    [leftView layoutLeftView];
    [self.view endEditing:YES];
}

-(void)leftViewClickAtIndex:(NSInteger)index{
    [self.tableView headerBeginRefreshing];
}

#pragma mark -
#pragma mark table view

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.result count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identify = @"Cell2";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    NSArray *rs =  [self.result objectAtIndex:indexPath.row];
    [self setText:[rs objectAtIndex:2] forView:cell withTag:1];
    [self setText:[rs objectAtIndex:4] forView:cell withTag:2];
    [self setText:[rs objectAtIndex:7] forView:cell withTag:3];
    [self setText:[rs objectAtIndex:5] forView:cell withTag:4];
    [self setText:[rs objectAtIndex:6] forView:cell withTag:5];
    [self setText:[NSString stringWithFormat:@"%.2f",[[rs objectAtIndex:8] doubleValue]] forView:cell withTag:6];
    [self setText:[NSString stringWithFormat:@"%.2f",[[rs objectAtIndex:9] doubleValue]] forView:cell withTag:7];
    
    if([self.setting intForKey:@"Stock"] == 0){
//        [self setHiden:cell withTag:16];
        [self setHiden:cell withTag:6];
    }
    
    if ([self.setting intForKey:@"Usable"] == 0){
//        [self setHiden:cell withTag:17];
        [self setHiden:cell withTag:7];
    }
    
    
    [self setProductImage:[rs objectAtIndex:0] inImageView:[cell viewWithTag:8]];
    
    
    return cell;
}

-(void)setHiden:(UIView *)view withTag:(NSUInteger)tag{
    UIView *subView = [view viewWithTag:tag];
    subView.hidden = YES;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.bSelect){
        NSArray *rs =  [self.result objectAtIndex:indexPath.row];
        NSMutableArray *array =  [NSMutableArray arrayWithArray:rs];
        [self.products addObject:array];
        [self.parentVC performSelector:@selector(loadData) withObject:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        NSArray *rs =  [self.result objectAtIndex:indexPath.row];
        UIStoryboard *sd = [UIStoryboard storyboardWithName:@"SecondaryStoryboard" bundle:nil];
        KCLBViewController *vc =  (KCLBViewController *)[sd instantiateViewControllerWithIdentifier:@"KCLBViewController"];
        vc.shID = [[rs objectAtIndex:0] integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
#pragma mark search bar


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
    self.searchCode = nil;
    self.products = nil;
    [leftView release];
    self.result = nil;
    [_tableView release];
    _tableView = nil;
    [_searchBar release];
    
    
    [super dealloc];
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
