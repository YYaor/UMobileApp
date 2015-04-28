//
//  ShangPinXZViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/11/13.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "ShangPinXZViewController.h"

@interface ShangPinXZViewController ()

@end

@implementation ShangPinXZViewController

@synthesize result;
@synthesize products;
@synthesize searchCode;
@synthesize selectDic;

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
    self.curProducts =  [NSMutableArray array];
    self.selectDic =  [NSMutableDictionary dictionary];
    [self setHeaderRefresh:self.tableView];
    [self.tableView headerBeginRefreshing];
    // Do any additional setup after loading the view.
    
    leftView =  [[LeftView alloc]init];
    leftView.delegate = self;
    leftView.link = [self GetLinkWithFunction:76 andParam:@"20,0,1"];
    [leftView setMainView:self.view];
    //    leftView.dataSource =  @[@"所有商品",@"食品饮料",@"厨房用品",@"生活电器",@"运动保障",@"图书杂志",@"进口食品"];
    if (self.searchCode) {
        self.searchBar.text = self.searchCode;
    }
//    if (self.allInfo) {
//        if([self.setting intForKey:@"ISBS"] == 1){   //区分BS帐套
//            self.companyID = [[self.allInfo objectForKey:@"4"] firstObject];
//            self.stockID = [[self.allInfo objectForKey:@"6"] firstObject];
//        }else{
//            self.companyID = [[self.allInfo objectForKey:@"5"] firstObject];
//            self.stockID = [[self.allInfo objectForKey:@"7"] firstObject];
//        }
//    }
    // change 0213
//    if ([[self.allInfo objectForKey:@"4"] count] == 3 || [[self.allInfo objectForKey:@"5"] count] == 3) {
//        if ([[[self.allInfo objectForKey:@"0"] firstObject] intValue] == 5) {
//            self.companyID = [[self.allInfo objectForKey:@"4"] lastObject];
//            self.stockID = [[self.allInfo objectForKey:@"6"] lastObject];
//        }
//        else
//        {
//            self.companyID = [[self.allInfo objectForKey:@"5"] lastObject];
//            self.stockID = [[self.allInfo objectForKey:@"7"] lastObject];
//        }
//    }else
//    {
//        if ([[[self.allInfo objectForKey:@"0"] firstObject] intValue] == 5) {
//            self.companyID = [[self.allInfo objectForKey:@"4"] firstObject];
//            self.stockID = [[self.allInfo objectForKey:@"6"] firstObject];
//        }
//        else
//        {
//            self.companyID = [[self.allInfo objectForKey:@"5"] firstObject];
//            self.stockID = [[self.allInfo objectForKey:@"7"] firstObject];
//        }
//    }
    self.companyID = @"0";
    self.stockID = @"0";
    if ([self.setting intForKey:@"ISBS"] == 1) {
        if ([(NSArray *)[self.allInfo objectForKey:@"3"] count] > 0) self.companyID = [[self.allInfo objectForKey:@"3"] firstObject];
        if ([(NSArray *)[self.allInfo objectForKey:@"6"] count] > 0) self.stockID = [[self.allInfo objectForKey:@"6"] firstObject];
    }else{
        if ([(NSArray *)[self.allInfo objectForKey:@"5"] count] > 0) self.companyID = [[self.allInfo objectForKey:@"5"] firstObject];
        if ([(NSArray *)[self.allInfo objectForKey:@"7"] count] > 0) self.stockID = [[self.allInfo objectForKey:@"7"] firstObject];
    }
    

}

-(void)loadData{
    self.searchBar.text = self.searchCode;
    [self headerRereshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark refresh

-(void)headerRereshing{
    page = 1;
    //'',0,0,0,0,0,0,1,1
//        NSString *link = [self GetLinkWithFunction:60 andParam:[NSString stringWithFormat:@"20,%d,%@,'%@',1",page,leftView.selectID,[self.searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSString *param = [NSString stringWithFormat:@"'%@',%d,%d,1,1,0,%@,1,1,20,%d",[self.searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.companyID intValue],[self.stockID integerValue],leftView.selectID,page];
    NSString *link =  [self GetLinkWithFunction:60 andParam:param];
    
    //选择商品类型之后这个类型的id是没有传到给link，所以导致下面的数据解析没变
    __block ShangPinXZViewController *tempSelf = self;
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
    NSString *param = [NSString stringWithFormat:@"'%@',%d,%d,1,1,0,%@,1,1,20,%d",[self.searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.companyID intValue],[self.stockID integerValue],leftView.selectID,page];
    NSString *link =  [self GetLinkWithFunction:60 andParam:param];
    
    __block ShangPinXZViewController *tempSelf = self;
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
        [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (IBAction)moreClick:(id)sender {
    [self.products addObjectsFromArray:self.curProducts];
    [self.parentVC performSelector:@selector(loadData) withObject:nil];
    [self dismiss];
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
    NSString *identify = [self.setting intForKey:@"Classics"] == 1?@"Cell":@"Cell2";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    NSArray *rs =  [self.result objectAtIndex:indexPath.row];
    [self setText:[rs objectAtIndex:4] forView:cell withTag:1];
    [self setText:[rs objectAtIndex:3] forView:cell withTag:2];
    [self setText:[rs objectAtIndex:16] forView:cell withTag:3];
    [self setText:[rs objectAtIndex:5] forView:cell withTag:4];
    [self setText:[rs objectAtIndex:6] forView:cell withTag:5];
    [self setText:[rs objectAtIndex:2] forView:cell withTag:6];
    [self setText:[rs objectAtIndex:1] forView:cell withTag:7];
    
    
    if([self.setting intForKey:@"Stock"] == 0){
        [self setHiden:cell withTag:16];
        [self setHiden:cell withTag:6];
    }
    
    if ([self.setting intForKey:@"Usable"] == 0 && self.canShow == NO){
        [self setHiden:cell withTag:17];
        [self setHiden:cell withTag:7];
    }
    
    if (!self.bMutileSelect) {
        [self setHiden:cell withTag:9];
    }
    
    NSString *key = [rs objectAtIndex:0];//[NSString stringWithFormat:@"%d",indexPath.row];

    RCCheckButton *button = [self buttonInCell:cell withTag:9];
    button.choose = [self.selectDic objectForKey:key] != nil;
    button.userInteractionEnabled = NO;
    
    
    [self setProductImage:[rs objectAtIndex:0] inImageView:[cell viewWithTag:8]];
    
    
    return cell;
}

-(void)setHiden:(UIView *)view withTag:(NSUInteger)tag{
    UIView *subView = [view viewWithTag:tag];
    subView.hidden = YES;
}

-(RCCheckButton *)buttonInCell:(UITableViewCell *)cell withTag:(NSUInteger )tag{
    RCCheckButton *cb = (RCCheckButton *)[cell viewWithTag:tag];
    return cb;
}

-(NSMutableDictionary *)setProduct:(NSArray *)arr{
    NSMutableDictionary *P = [NSMutableDictionary dictionary];
    
    NSArray *keys = @[@"商品ID",@"可用数量",@"库存数量",@"商品编码",
                      @"名称",@"规格",@"型号",@"最近进价",@"单位ID",
                      @"单位名称",@"儿子数",@"条码",@"预设入库售价",
                      @"预设出库售价",@"预设入库售价比率",@"预设出库售价比率",@"最近售价"];
    
    for (int i = 0 ; i < [keys count] ; i ++){
        [P setObject:[arr objectAtIndex:i] forKey:[keys objectAtIndex:i]];
    }
    
    BOOL bSelectCompany = NO;//判断 是否选择了 往来单位
    if([self.setting intForKey:@"ISBS"] == 1){   //区分BS帐套
        bSelectCompany = [[self.allInfo objectForKey:@"4"] firstObject] != nil;
    }else{
        bSelectCompany = [[self.allInfo objectForKey:@"5"] firstObject] != nil;
    }
    
    NSString *type = @"";
    if (bSelectCompany) {//选择了往来单位才取 出库或入库价
        if ([[[self.allInfo  objectForKey:@"0"] firstObject] integerValue] == 5) {
            type = @"预设入库售价";
        }else{
            type = @"预设出库售价";
        }
    }

    NSString *price = [P strForKey:type];//未选择往来 单位时 type =@"",则没有价钱
    
    [P setObject:@"" forKey:@"明细ID"];
    [P setObject:@"" forKey:@"单据ID"];
    [P setObject:@"" forKey:@"仓库ID"];
//    [P setObject:[arr objectAtIndex:0] forKey:@"商品ID"];
//    [P setObject:[arr objectAtIndex:8] forKey:@"商品单位ID"];
    [P setObject:@"" forKey:@"批号"];
    [P setObject:@"" forKey:@"出厂日期"];
    [P setObject:@"1" forKey:@"数量"];
    [P setObject:price forKey:@"单价"];
    [P setObject:price forKey:@"金额"];
    [P setObject:@"1" forKey:@"单位换算率"];
    [P setObject:@"1" forKey:@"基本单位数量"];
    
    [P setObject:@"100" forKey:@"折扣"];
    [P setObject:price forKey:@"折后单价"];
    [P setObject:price forKey:@"折后金额"];
    [P setObject:@"0" forKey:@"折扣金额"];
    
    [P setObject:@"0" forKey:@"税率"];
    [P setObject:price forKey:@"含税单价"];
    
    [P setObject:price forKey:@"含税金额"];
    [P setObject:@"0" forKey:@"税额"];
    [P setObject:@"0" forKey:@"赠品"];
    [P setObject:@"" forKey:@"备注"];
    
    
//    [np addObject:@"1"];//数量
//    [np addObject:@"100"];//折扣
//    [np addObject:[arr objectAtIndex:16]];
//    [np addObject:[arr objectAtIndex:16]];
//    [np addObject:@""];
//    [np addObject:@"0"];//赠品
    return P;
}

-(void)removeProductAtKey:(NSString *)key{
    for(NSDictionary *dic in self.curProducts){
        if ([[dic strForKey:@"商品ID"] isEqualToString:key]) {
            [self.curProducts removeObject:dic];
            break;
        }
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.bMutileSelect){
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        RCCheckButton *button = [self buttonInCell:cell withTag:9];
        NSArray *rs =  [self.result objectAtIndex:indexPath.row];
        
        NSString *key = [rs objectAtIndex:0];
        if ([self.selectDic objectForKey:key]){
            [self removeProductAtKey:key];//从数组移除
            [self.selectDic removeObjectForKey:key];//去除标记
            button.choose = NO;
        }else{

            NSMutableDictionary *array = [self setProduct:rs];//  [NSMutableArray arrayWithArray:rs];
            [self.curProducts addObject:array];//添加到数组
            [self.selectDic setObject:key forKey:key];//添加标记
            button.choose = YES;
        }

    }else{
        NSArray *rs =  [self.result objectAtIndex:indexPath.row];
        [self.products addObject:[self setProduct:rs]];
        [self.parentVC performSelector:@selector(loadData) withObject:nil];
        [self.navigationController popViewControllerAnimated:YES];
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
    self.curProducts = nil;
    self.companyID = nil;
    self.stockID = nil;
    self.selectDic = nil;
    self.searchCode = nil;
    self.products = nil;
    [leftView release];
    self.result = nil;
    [_tableView release];
    _tableView = nil;
    [_searchBar release];
    
    
    [super dealloc];
}


@end
