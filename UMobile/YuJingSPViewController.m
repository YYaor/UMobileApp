//
//  YuJingSPViewController.m
//  UMobile
//
//  Created by 陈 景云 on 14-11-9.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "YuJingSPViewController.h"

@interface YuJingSPViewController ()

@end

@implementation YuJingSPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.info);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview reloadData];
    if (self.type == 7) {
        self.navigationItem.title = @"预警商品信息";
    }else if (self.type == 8)
    {
        self.navigationItem.title = @"会员信息详情";
    }
    
    // Do any additional setup after loading the view.
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return [@[@"95",@"95",@"195"][indexPath.section] floatValue];//调节cell高度
    if (self.type == 8 && indexPath.row == 1) {
        return 200;
    }else
    {
        return 150;
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == 7) {
        return 1;
    }else
    {
        return 2;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    if (self.type == 8) {
        if (indexPath.row == 0) {
            cell = [self.tableview dequeueReusableCellWithIdentifier:@"Cell1"];
            [self setText:[self.info objectAtIndex:1] forView:cell withTag:2];
            [self setText:[self.info objectAtIndex:2] forView:cell withTag:3];
            [self setText:[self.info objectAtIndex:3] forView:cell withTag:4];
            [self setText:[self.info objectAtIndex:4] forView:cell withTag:5];
            [self setText:[self.info objectAtIndex:5] forView:cell withTag:6];
        }else if (indexPath.row == 1)
        {
            cell = [self.tableview dequeueReusableCellWithIdentifier:@"Cell2"];
            [self setText:[self.info objectAtIndex:0] forView:cell withTag:2];
            [self setText:[self.info objectAtIndex:6] forView:cell withTag:3];
            [self setText:[self.info objectAtIndex:7] forView:cell withTag:4];
            [self setText:[self.info objectAtIndex:8] forView:cell withTag:5];
            [self setText:[self.info objectAtIndex:9] forView:cell withTag:6];
            [self setText:[self.info objectAtIndex:10] forView:cell withTag:7];
            [self setText:[self.info objectAtIndex:11] forView:cell withTag:8];
            [self setText:[self.info objectAtIndex:12] forView:cell withTag:9];
        }
    }else
    {
        cell = [self.tableview dequeueReusableCellWithIdentifier:@"Cell3"];
        [self setText:[self.info objectAtIndex:1] forView:cell withTag:1];
        [self setText:[self.info objectAtIndex:0] forView:cell withTag:2];
        [self setText:[self.info objectAtIndex:2] forView:cell withTag:3];
        [self setText:[self.info objectAtIndex:3] forView:cell withTag:4];
        [self setText:[self.info objectAtIndex:4] forView:cell withTag:5];
        [self setText:[self.info objectAtIndex:5] forView:cell withTag:6];
    }
    return cell;
    
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

- (void)dealloc {
    [_tableview release];
    [super dealloc];
}
@end