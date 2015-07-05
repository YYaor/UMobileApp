//
//  OrderProductsViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/10/20.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "OrderProductsViewController.h"

@interface OrderProductsViewController ()

@end

@implementation OrderProductsViewController

@synthesize info,result;
@synthesize keyIndex;
@synthesize types;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHeaderRefresh:self.tableView];
    if ([self.setting intForKey:@"ISBS"] == 0) {

    }else{
        hStock = [self.setting intForKey:@"Stock"] == 0;
        hUsable = [self.setting intForKey:@"Usable"] == 0;
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    if (self.result) return;
    [self.tableView headerBeginRefreshing];
}


-(void)headerRereshing{
    NSString *param = [NSString stringWithFormat:@"%@,%@,%@,1",
                       [self.keyIndex objectAtIndex:0],
                       [self.keyIndex objectAtIndex:1],
                       [self.keyIndex objectAtIndex:2]];
    
    NSString *link =  [self GetLinkWithFunction:58 andParam:param];
    
    __block OrderProductsViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        [tempSelf.tableView headerEndRefreshing];
        
        NSArray *rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        if ([rs count] > 0)
            tempSelf.result = rs;
        [tempSelf.tableView reloadData];
    } lock:NO];
}


#pragma mark -
#pragma mark table view

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.yjType == 5 || self.yjType == 6) {
        return 95;
    }else if (self.fromType == FromType_ShenHe || (hStock & hUsable)) {
        if ([self.setting intForKey:@"ISBS"] == 0) {
            return 175;
        }else{
            return 115;
        }
    }else{
        return 210;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.result count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identify = @"";
    
    //根据不同进入 方式取不同的Cell
    if (self.yjType == 5 || self.yjType == 6) {
        identify  = @"Cell3";
    }else if (self.fromType == FromType_ShenHe || (hStock & hUsable)) {
        if ([self.setting intForKey:@"ISBS"] == 0) {
            identify = @"Cell4";
        }else{
            identify  = @"Cell2";
        }
    }else{
        identify = @"Cell";
    }

    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
    NSArray *dic =  [self.result objectAtIndex:indexPath.row];
    if (hStock) {
        [self setHiden:cell withTag:111];
        [self setHiden:cell withTag:11];
    }
    
    if (hUsable) {
        [self setHiden:cell withTag:112];
        [self setHiden:cell withTag:12];
    }
    
    NSArray *keys = @[@"3",@"2",@"7",@"8",@"5",@"9",@"10",@"12",@"14",@"13",@"16",@"15"];
    for (int i = 0 ; i < [keys count] ; i ++){
        [self setText:[dic objectAtIndex:[[keys objectAtIndex:i] integerValue]] forView:cell withTag:i + 1];
    }
    
    if (self.shType == 61 || self.shType == 14) {
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        if (label) {
            [self setName:[dic objectAtIndex:3] andType:[dic objectAtIndex:23] inLabel:label];
        }
        
    }

    
    return cell;
}

-(void)setName:(NSString *)name andType:(NSString *)strType inLabel:(UILabel *)attrLabel{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@(%@)",name,strType]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([name length] ,[strType length] + 2)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:9.0] range:NSMakeRange([name length],[strType length] + 2)];
    attrLabel.attributedText = str;
}

-(void)setHiden:(UIView *)view withTag:(NSUInteger)tag{
    UIView *subView = [view viewWithTag:tag];
    subView.hidden = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dealloc{
    self.types = nil;
    self.info = nil;
    self.result = nil;
    [_tableView release];
    [super dealloc];
}


@end
