//
//  ShenHeDtlViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/17.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "ShenHeDtlViewController.h"
#import "pinyin.h"

@interface ShenHeDtlViewController ()

@end

@implementation ShenHeDtlViewController

@synthesize result,keys,style,searchType,strTitle;

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
    
    
    page = 1;
    
    self.result = [NSMutableArray array];
    
    // 添加 callFunction == 61 height：70                  15.1.20
    NSDictionary *heights  = @{@"14":@"65",@"7":@"65",@"8":@"65",@"102":@"65",@"105":@"65",@"61":@"70"};
    rowHeight = [heights floatForKey:[NSString stringWithFormat:@"%d",self.callFunction]];
    if(rowHeight == 0) rowHeight = 50;
    
    [self setHeaderRefresh:self.tableView];
    [self.tableView headerBeginRefreshing];
    
    if ([self.searchType length] > 0) {
        self.searchBar.placeholder = self.searchType;
    }
    
    
    
    self.titleButton.titleLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    self.titleButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    self.titleButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:17.0];
    self.titleButton.titleLabel.textColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self.titleButton setTitle:strTitle forState:UIControlStateNormal];
    
//    [self.dateField setDateField:YES];
//    [self.dateField setShowToolButton:NO];

    
    // Do any additional setup after loading the view.
}

- (IBAction)titleButtonClick:(id)sender {
    NSArray *menus = nil;
    if (self.callFunction == 5 || self.callFunction == 0 || self.callFunction == 3|| self.callFunction == 61) {
        menus = @[
                  [KxMenuItem menuItem:@"按供应商" image:[UIImage imageNamed:@"popup_icon_approve_date"] target:self action:@selector(sortMenuClick:)],
                  [KxMenuItem menuItem:@"按日期" image:[UIImage imageNamed:@"popup_icon_approve_curweek"] target:self action:@selector(sortMenuClick:)]
                  ];
    }else if (self.callFunction == 6 || self.callFunction == 1 || self.callFunction == 4 || self.callFunction == 14 ){
        menus = @[
                  [KxMenuItem menuItem:@"按客户" image:[UIImage imageNamed:@"popup_icon_approve_date"] target:self action:@selector(sortMenuClick:)],
                  [KxMenuItem menuItem:@"按日期" image:[UIImage imageNamed:@"popup_icon_approve_curweek"] target:self action:@selector(sortMenuClick:)]
                  ];
    }else if (self.callFunction == 7 || self.callFunction == 8 || self.callFunction == 102 || self.callFunction == 105 ){
        menus = @[[KxMenuItem menuItem:@"按日期" image:[UIImage imageNamed:@"popup_icon_approve_curweek"] target:self action:@selector(sortMenuClick:)]
                  ];
    }else{
        menus = @[
                  [KxMenuItem menuItem:@"往来单位" image:[UIImage imageNamed:@"popup_icon_approve_date"] target:self action:@selector(sortMenuClick:)],
                  [KxMenuItem menuItem:@"按日期" image:[UIImage imageNamed:@"popup_icon_approve_curweek"] target:self action:@selector(sortMenuClick:)]
                  ];
    }

    [KxMenu showMenuInView:self.view fromRect:CGRectMake(160, 64, 10, 1) menuItems:menus];
}

-(void)sortMenuClick:(KxMenuItem *)item{
    NSUInteger index = 0;
    NSComparator cmptr;
    if ([item.title isEqualToString:@"按供应商"] || [item.title isEqualToString:@"按客户"]) {
        index = 7;//供应商名称
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
            NSString *c1 = @"";
            if ([[obj1 ingoreObjectAtIndex:index] length] > 0) {
                c1 = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([[obj1 ingoreObjectAtIndex:index] characterAtIndex:0])]uppercaseString];
            }
            
            NSString *c2 = @"";
            if ([[obj2 ingoreObjectAtIndex:index] length] > 0) {
                c2 = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([[obj2 ingoreObjectAtIndex:index] characterAtIndex:0])]uppercaseString];
            }
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

-(void)headerRereshing{
    page = 1;
    
    NSString *link = [self GetLinkWithFunction:74 andParam:[NSString stringWithFormat:@"%d,4,'%@',%@",self.callFunction,self.searchBar.text,[[self setting] objectForKey:@"UID"]]];
    NSString *nlink = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __block ShenHeDtlViewController *tempSelf = self;
    [self StartQuery:nlink completeBlock:^(id obj) {
        
        [tempSelf.tableView headerEndRefreshing];
        [tempSelf.result removeAllObjects];
        NSDictionary *info =  [obj objectFromJSONString];
        tempSelf.keys =  [info objectForKey:@"D_Fields"];
        [tempSelf.result addObjectsFromArray:[info objectForKey:@"D_Data"]];
        [tempSelf.tableView reloadData];
        
    } lock:NO];
}

-(void)footerRereshing{
    page ++;

    
    NSString *link = [self GetLinkWithFunction:74 andParam:[NSString stringWithFormat:@"%d,4,'%@',1",self.callFunction,self.searchBar.text]];
    NSString *nlink = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __block ShenHeDtlViewController *tempSelf = self;
    [self StartQuery:nlink completeBlock:^(id obj) {
        
        [tempSelf.tableView headerEndRefreshing];
        NSDictionary *info =  [obj objectFromJSONString];

        [tempSelf.result addObjectsFromArray:[info objectForKey:@"D_Data"]];
        [tempSelf.tableView reloadData];
        
    } lock:NO];
}

-(void)loadData{
    [self.tableView headerBeginRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark table view


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *info = [self.result objectAtIndex:indexPath.row];
    if (self.callFunction ==  101 || self.callFunction == 100 || self.callFunction == 102 || self.callFunction == 103 || self.callFunction == 128 || self.callFunction == 129 || self.callFunction == 104 || self.callFunction == 105 || self.callFunction == 118 || self.callFunction == 119){
        OrderDetail2ViewController *vc = (OrderDetail2ViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetail2ViewController"];
        vc.info = info;
        vc.keyIndex = @[[info objectAtIndex:2],[info objectAtIndex:0],[info objectAtIndex:4]];
        vc.callFunction = self.callFunction;
        vc.types = @[self.strTitle,[NSString stringWithFormat:@"%d",style],[NSString stringWithFormat:@"%d",self.callFunction]];//名称，类型，订单ID
        vc.shType = self.shType;
        vc.parentVC = self;
        vc.navigationItem.title =  [NSString stringWithFormat:@"%@详情",self.strTitle];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        OrderDetailController *vc = (OrderDetailController *)[self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailController"];
        vc.info = info;
        vc.fromType = FromType_ShenHe;
        vc.keyIndex = @[[info objectAtIndex:2],[info objectAtIndex:0],[info objectAtIndex:4]];//名称，ID
        vc.callFunction = self.callFunction;
        vc.types = @[self.strTitle,[NSString stringWithFormat:@"%d",style],[NSString stringWithFormat:@"%d",self.callFunction]];//名称，类型，订单ID
        vc.parentVC = self;
        vc.navigationItem.title =  [NSString stringWithFormat:@"%@详情",self.strTitle];
        vc.isHidden = YES;//fix ghd add
        vc.fromCheck = YES;
        vc.shType = self.shType;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return rowHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.result count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    NSArray *RsD =  [self.result objectAtIndex:indexPath.row];
    if (self.callFunction == 14 || self.callFunction == 61){
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        [self setText:[RsD ingoreObjectAtIndex:7] forView:cell withTag:1];
        [self setText:[RsD ingoreObjectAtIndex:5] forView:cell withTag:2];
        [self setText:[RsD ingoreObjectAtIndex:6] forView:cell withTag:4];
        [self setText:[NSString numberFromString:[RsD ingoreObjectAtIndex:16]] forView:cell withTag:3];
        [self setText:[NSString numberFromString:[RsD ingoreObjectAtIndex:15]] forView:cell withTag:5];
    }else if (self.callFunction == 7 || self.callFunction == 8){
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell3"];
        [self setText:[RsD ingoreObjectAtIndex:11] forView:cell withTag:1];
        [self setText:[RsD ingoreObjectAtIndex:10] forView:cell withTag:2];
        [self setText:[NSString numberFromString:[RsD ingoreObjectAtIndex:12]] forView:cell withTag:3];
        [self setText:[RsD ingoreObjectAtIndex:6] forView:cell withTag:4];
        [self setText:[RsD ingoreObjectAtIndex:5] forView:cell withTag:5];
    }else if (self.callFunction == 102 || self.callFunction == 105){
        NSString *name = self.callFunction == 102?@"费用金额:":@"转款金额:";
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell4"];
        [self setText:name forView:cell withTag:99];
        [self setText:[NSString numberFromString:[RsD ingoreObjectAtIndex:12]] forView:cell withTag:1];
        [self setText:[RsD ingoreObjectAtIndex:5] forView:cell withTag:2];
        [self setText:[RsD ingoreObjectAtIndex:6] forView:cell withTag:3];
        
    }else if (self.callFunction == 1030000){//不用
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell5"];
        [self setText:[NSString numberFromString:[RsD ingoreObjectAtIndex:12]] forView:cell withTag:1];
        [self setText:[RsD ingoreObjectAtIndex:5] forView:cell withTag:2];
        [self setText:[RsD ingoreObjectAtIndex:6] forView:cell withTag:3];
        
    }else{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
        [self setText:[RsD ingoreObjectAtIndex:7] forView:cell withTag:1];
        [self setText:[RsD ingoreObjectAtIndex:5] forView:cell withTag:2];
        [self setText:[RsD ingoreObjectAtIndex:6] forView:cell withTag:4];
        [self setText:[NSString numberFromString:[RsD ingoreObjectAtIndex:12]] forView:cell withTag:3];
    }

    
    return cell;
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
    self.strTitle = nil;
    self.searchType = nil;
    self.keys = nil;
    self.result = nil;
    [_dateField release];
    [_tableView release];
    [_navItem release];
    [_searchBar release];
    [_titleButton release];
    [super dealloc];
}
@end
