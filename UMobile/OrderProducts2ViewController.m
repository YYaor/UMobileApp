//
//  OrderProducts2ViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/12/1.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "OrderProducts2ViewController.h"

@interface OrderProducts2ViewController ()

@end

@implementation OrderProducts2ViewController

@synthesize info,result;
@synthesize keyIndex;
@synthesize types;

- (void)viewDidLoad {
    [super viewDidLoad];
    callFunction = [[self.types ingoreObjectAtIndex:2] integerValue];
    [self setHeaderRefresh:self.tableView];
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
    
    __block OrderProducts2ViewController *tempSelf = self;
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
    NSArray *dic =  [self.result objectAtIndex:indexPath.row];

    if([[dic objectAtIndex:1] integerValue] != -1 )
        return 55;
    else
        return 85;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.result count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *dic =  [self.result objectAtIndex:indexPath.row];
    UITableViewCell *cell = nil;
    if([[dic objectAtIndex:1] integerValue] != -1){
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
        [self setText:[dic ingoreObjectAtIndex:3] forView:cell withTag:1];
        [self setText:[dic ingoreObjectAtIndex:13] forView:cell withTag:2];
        if (callFunction == 102 || callFunction == 103) {
            [self setText:@"费用名称:" forView:cell withTag:88];
            [self setText:@"费用金额:" forView:cell withTag:99];
        }
    }else{
        if ([self.setting intForKey:@"ISBS"]==1) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        }else{
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        }
        

        [self setText:[dic ingoreObjectAtIndex:17] forView:cell withTag:1];
        [self setText:[dic ingoreObjectAtIndex:18] forView:cell withTag:2];
        [self setText:[dic ingoreObjectAtIndex:19] forView:cell withTag:3];
        [self setText:[dic ingoreObjectAtIndex:13] forView:cell withTag:4];
        [self setText:[dic ingoreObjectAtIndex:21] forView:cell withTag:5];
        [self setText:[dic ingoreObjectAtIndex:20] forView:cell withTag:6];
        if ([self.setting intForKey:@"ISBS"] == 1) {
            [self setText:[dic ingoreObjectAtIndex:26] forView:cell withTag:7];
        }else {
            [self setText:[dic ingoreObjectAtIndex:22] forView:cell withTag:7];
            if (self.shType == 100) {
                [cell viewWithTag:70].hidden = YES;
                [cell viewWithTag:7].hidden = YES;
            }
        }
        
        
        
        UIView *view = [cell viewWithTag:99];
        view.hidden = ![[dic objectAtIndex:14] isEqualToString:@"是"];
    }
    
    
    
    
    return cell;
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
