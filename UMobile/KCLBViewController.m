//
//  KCLBViewController.m
//  UMobile
//
//  Created by mocha on 15/5/6.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "KCLBViewController.h"

@interface KCLBViewController ()
{
    NSMutableArray *array;
}

@end

@implementation KCLBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh:self.tableView];
    [self.tableView headerBeginRefreshing];
    
    // Do any additional setup after loading the view.
}

-(void)headerRereshing{
    [array removeAllObjects];
    NSString *link = [self GetLinkWithFunction:91 andParam:[NSString stringWithFormat:@"%lu,'%@',20,-1",(unsigned long)self.shID,[self GetUserID]]];
    
    __block KCLBViewController *tempSelf = self;
    [self setFooterRefresh:self.tableView];
    [self StartQuery:link completeBlock:^(id obj) {
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [array addObjectsFromArray:rs];
        [tempSelf.tableView reloadData];
        [tempSelf.tableView headerEndRefreshing];
    } lock:NO];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identify = @"cellList";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    
    NSArray *rs = [array objectAtIndex:indexPath.row];
    [self setText:[rs objectAtIndex:1] forView:cell withTag:1];
    [self setText:[rs objectAtIndex:2] forView:cell withTag:2];
    [self setText:[rs objectAtIndex:3] forView:cell withTag:3];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vc = [[UIView alloc]init];
    NSArray *titleArray = @[@"仓库",@"可用量",@"现存量"];
    for (int i = 0; i<3; i++) {
      CGFloat  width = self.view.frame.size.width/3;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*width, 0, width, 44)];
        label.text = titleArray[i];
        label.backgroundColor = [UIColor colorWithWhite:0x8b/255.9 alpha:1];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [vc addSubview:label];
    }
    return vc;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
