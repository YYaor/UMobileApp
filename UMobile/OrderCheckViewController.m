//
//  OrderCheckViewController.m
//  UMobile
//
//  Created by 陈 景云 on 14-10-20.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "OrderCheckViewController.h"

@interface OrderCheckViewController ()

@end

@implementation OrderCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setHeaderRefresh:self.tableView];
    if ([self.setting intForKey:@"ISBS"] == 1) {
        _checkLabel.text = self.noCheck ? @"审核历史为空" : @"已审核";
        if (self.shType > 0) {
            _checkLabel.text = @"审核历史为空";
        }
    }else{
        _checkLabel.text = self.noCheck ? @"未审核" : @"已审核";
    }

    _checkLabel.textColor = self.noCheck ? [UIColor redColor] : [UIColor blackColor];
}

-(void)loadData{
    [self headerRereshing];
}

-(void)headerRereshing{
    OrderHeaderViewController *vc = (OrderHeaderViewController *)self.parentVC;
    if (vc.result) {
        NSString *param = [NSString stringWithFormat:@"%@,%@,%@",
                           [self GetOrderType:[vc.result objectAtIndex:0]],[vc.result objectAtIndex:1],[self GetUserID]];
        
        NSString *link =  [self GetLinkWithFunction:88 andParam:param];
        
        __block OrderCheckViewController *tempSelf = self;
        [self StartQuery:link completeBlock:^(id obj) {
            [tempSelf.tableView headerEndRefreshing];
            
            NSArray *rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
            if ([rs count] > 0){
                tempSelf.result = rs;
                _checkLabel.hidden = YES;
            }else{
                _checkLabel.hidden = NO;
            }
            [tempSelf.tableView reloadData];
        } lock:NO];
    }

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


#pragma mark -
#pragma mark table view

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.result count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray *dic =  [self.result objectAtIndex:indexPath.row];
    [self setText:[dic objectAtIndex:0] forView:cell withTag:1];
    [self setText:[dic objectAtIndex:1] forView:cell withTag:2];
    [self setText:[dic objectAtIndex:2] forView:cell withTag:3];

    return cell;
}




- (void)dealloc {
    self.result = nil;
    [_checkLabel release];
    [_tableView release];
    [super dealloc];
}
@end
