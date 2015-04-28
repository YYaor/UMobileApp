//
//  KHGLViewController.m
//  UMobile
//
//  往来单位管理
//
//  Created by  APPLE on 2014/9/11.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "KHGLViewController.h"

@interface KHGLViewController ()

@end

@implementation KHGLViewController
@synthesize result,bSelect;

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
    [self setNavigationShow];
    self.result = [NSMutableArray array];
    [self setupRefresh:self.tableView];
    [self.tableView headerBeginRefreshing];
    
    leftView =  [[LeftView alloc]init];
    leftView.delegate = self;
    leftView.width = 250;
    leftView.link = [self GetLinkWithFunction:77 andParam:[NSString stringWithFormat:@"20,0,%@",[self GetUserID]]];
    [leftView setMainView:self.view];
//    leftView.dataSource =  @[@"所有客户",@"供应商",@"大客户",@"日常客户"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftViewClickAtIndex:(NSInteger)index{
    [self.tableView headerBeginRefreshing];
}
- (IBAction)categoryClick:(id)sender {
    [leftView layoutLeftView];
    [self.view endEditing:YES];
}
- (IBAction)addButtonClick:(id)sender {
    KHGLAddViewController *vc =  (KHGLAddViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"KHGLAddViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)phoneClick:(id)sender {
    UITableViewCell *cell = [self GetSuperCell:sender];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    index = indexPath.row;
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"拨号致" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手机",@"电话", nil] autorelease];
    [sheet showInView:self.view];

}

//发短信 或 拨打电话
- (IBAction)buttonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = [self GetSuperCell:sender];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSArray *info = [self.result objectAtIndex:indexPath.row];
    index = indexPath.row;
    if (button.tag == 1) {
        [self sendToNumber:[info objectAtIndex:6]];
    }else if (button.tag == 2){
        UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"拨号致" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手机",@"电话", nil] autorelease];
        [sheet showInView:self.view];
    }else{
        NSString *content = [NSString stringWithFormat:@"客户:%@\n电话:%@\n手机:%@",
                             [info objectAtIndex:2],
                             [info objectAtIndex:3],
                             [info objectAtIndex:7]];
        [self shareContent:content];

    }
}

//拨打电话
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        NSArray *rs =  [self.result objectAtIndex:index];
        [self callANumber:[rs objectAtIndex:6]];
    }else if(buttonIndex == 1){
        NSArray *rs =  [self.result objectAtIndex:index];
        [self callANumber:[rs objectAtIndex:5]];
    }
}

#pragma mark -
#pragma mark refresh

-(void)headerRereshing{
    page = 1 ;
    //'超',0,0,0,1,1,20,1

    NSString *link = [self GetLinkWithFunction:10 andParam:[NSString stringWithFormat:@"20,%d,%@,'%@',%d",page,leftView.selectID,[self.searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[self GetUserID] intValue]]] ;
    [self setFooterRefresh:self.tableView];
    
    __block KHGLViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {

        NSString *obs = [NSString stringWithFormat:@"%@",obj];
        NSString *os = [NSString stringWithFormat:@"%@",[self encoardStringBeforeJson:obs]];
        NSArray *rs =  [[os objectFromJSONString] objectForKey:@"D_Data"];
        [tempSelf.result removeAllObjects];
        [tempSelf.result addObjectsFromArray:rs];
        
        [tempSelf.tableView reloadData];
        [tempSelf.tableView headerEndRefreshing];
    } lock:NO];
}

-(void)footerRereshing{
    page ++ ;

    NSString *link = [self GetLinkWithFunction:10 andParam:[NSString stringWithFormat:@"20,%d,%@,'%@',%@",page,leftView.selectID,[self.searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self GetUserID]]] ;
    
    [self StartQuery:link completeBlock:^(id obj) {
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        
        if ([rs count] > 0) {

            [self.result addObjectsFromArray:rs];
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
        }else{
            [self.tableView footerEndRefreshing];
            [self.tableView  removeFooter];
            if (page > 1) page --;
        }
        
                             
    } lock:NO];
}




#pragma mark -
#pragma mark table view

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.bSelect){
        
        [self.customerInfo removeAllObjects];
        NSArray *rs =  [self.result objectAtIndex:indexPath.row];
        NSArray *rsf = @[[rs objectAtIndex:0],[rs objectAtIndex:2]];
        [self.customerInfo addObjectsFromArray:rsf];
        [self.parentVC performSelector:@selector(loadData) withObject:nil];
        [self dismiss];
    }else{
        KHGLDtlViewController *vc =  (KHGLDtlViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"KHGLDtlViewController"];
        vc.result = [self.result objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.result count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
    }
    NSArray *rs =  [self.result objectAtIndex:indexPath.row];
//    [self setText:[rs objectAtIndex:1] forView:cell withTag:1];
//    [self setText:[rs objectAtIndex:2] forView:cell withTag:2];
//    [self setText:[rs objectAtIndex:3] forView:cell withTag:3];
//    [self setText:[rs objectAtIndex:7] forView:cell withTag:4];
//    [self setText:[rs objectAtIndex:6] forView:cell withTag:5];
    [self setText:[rs objectAtIndex:2] forView:cell withTag:1];
    [self setText:[rs objectAtIndex:4] forView:cell withTag:2];
    [self setText:[rs objectAtIndex:5] forView:cell withTag:3];
    [self setText:[rs objectAtIndex:6] forView:cell withTag:4];
    [self setText:[rs objectAtIndex:3] forView:cell withTag:5];
    return cell;
    
}



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
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    self.result = nil;
    [leftView release];
    leftView = nil;
    [_tableView release];
    _tableView = nil;
    [_searchBar release];
    _searchBar = nil;
    [super dealloc];
}
@end
