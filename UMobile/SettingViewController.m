//
//  SettingViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/10/17.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize titles;

- (void)viewDidLoad {
    [super viewDidLoad];
    //0 选择  1 是否  2 选择  3登出
    self.titles = @[@{@"Header":@"常用操作",
                      @"Detail":@[
                              @{@"Name":@"服务器连接设置",@"Image":@"",@"Action":@"serverClick:",@"Type":@"0",@"Value":@"Server"},
                              @{@"Name":@"流量统计",@"Image":@"",@"Action":@"flowClick:",@"Type":@"0",@"Value":@"Flow"},
                              @{@"Name":@"启用演示",@"Image":@"",@"Action":@"showClick:",@"Type":@"1",@"Value":@"Show"}
                              ]},
                    @{@"Header":@"商品管理图片模式",
                      @"Detail":@[
                              @{@"Name":@"经典模式",@"Image":@"",@"Action":@"styleClick:",@"Type":@"2",@"Value":@"Classics"},
                              @{@"Name":@"精简模式",@"Image":@"",@"Action":@"styleClick:",@"Type":@"2",@"Value":@"Simple"},
                              ]},
                    @{@"Header":@"业务设置",
                      @"Detail":@[
                              @{@"Name":@"库存数量",@"Image":@"",@"Action":@"stockClick:",@"Type":@"1",@"Value":@"Stock"},
                              @{@"Name":@"可用数量",@"Image":@"",@"Action":@"useClick:",@"Type":@"1",@"Value":@"Usable"},
                              ]},
                    @{@"Header":@"U+",
                      @"Detail":@[
                              @{@"Name":@"关于",@"Image":@"",@"Action":@"abountClick:",@"Type":@"0",@"Value":@"Abount"},
                              @{@"Name":@"意见反馈",@"Image":@"",@"Action":@"feedbackClick:",@"Type":@"0",@"Value":@"Feedback"},
                              ]},
                    @{@"Header":@"",
                      @"Detail":@[
                              @{@"Name":@"登出",@"Image":@"",@"Action":@"logoutClick:",@"Type":@"3",@"Value":@"Logout"}
                              ]}
                    ];
    // Do any additional setup after loading the view.
}


- (IBAction)dismissClick:(id)sender {
    [USER_DEFAULT setObject:self.setting forKey:@"Setting"];
    [self.navigationController popViewControllerAnimated:NO];
    
}

#pragma mark -
#pragma mark cell action

-(void)flowClick:(NSDictionary *)info{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FlowViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)abountClick:(NSDictionary *)info{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AbountViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)feedbackClick:(NSDictionary *)info{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)logoutClick:(NSDictionary *)info{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)serverClick:(NSDictionary *)info{
    RCViewController *vc = (RCViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"ServerViewController"];
    vc.parentVC = nil;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dics = [self.titles objectAtIndex:indexPath.section];
    NSDictionary *dic = [[dics objectForKey:@"Detail"] objectAtIndex:indexPath.row];

    SEL act = NSSelectorFromString([dic strForKey:@"Action"]);
    if ([self respondsToSelector:act]){
        [self performSelector:act withObject:dic];
        return;
    }
    NSUInteger type = [dic intForKey:@"Type"];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(type == 2){
        RCChooseButton *button = (RCChooseButton *)[cell viewWithTag:2];
        
        if (!button.choose){
            button.choose = YES;
            [self.setting setObject:[[NSNumber numberWithBool:button.choose] stringValue] forKey:[dic strForKey:@"Value"]];
            if ([[dic strForKey:@"Value"] isEqualToString:@"Classics"]){
                [self.setting setObject:@"0" forKey:@"Simple"];
            }else{
                [self.setting setObject:@"0" forKey:@"Classics"];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }

    }else if (type == 1){
        UISwitch *switcher = (UISwitch *)[cell viewWithTag:2];
        [switcher setOn:!switcher.on animated:YES];
        [self.setting setObject:[[NSNumber numberWithBool:switcher.on] stringValue] forKey:[dic strForKey:@"Value"]];
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dics = [self.titles objectAtIndex:indexPath.section];
    NSDictionary *dic = [[dics objectForKey:@"Detail"] objectAtIndex:indexPath.row];
    
    NSUInteger type = [dic intForKey:@"Type"];
    NSString *identify = nil;
    
    switch (type) {
        case 0:
            identify = @"Cell0";
            break;
        case 1:
            identify = @"Cell1";
            break;
        case 2:
            identify = @"Cell2";
            break;
        case 3:
            identify = @"Cell3";
            break;
    }
    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    
    [self setText:[dic strForKey:@"Name"] forView:cell withTag:1];
    if(type == 2){
        RCChooseButton *button = (RCChooseButton *)[cell viewWithTag:2];
        button.choose = [self.setting intForKey:[dic strForKey:@"Value"]] == 1;
    }else if (type == 1){
        UISwitch *switcher = (UISwitch *)[cell viewWithTag:2];
        switcher.on = [self.setting intForKey:[dic strForKey:@"Value"]] == 1;
    }
    
//    cell.imageView.image = [UIImage imageNamed:[dic strForKey:@"Image"]];
//    cell.textLabel.text = [dic strForKey:@"Name"];
//    cell.textLabel.textAlignment = [dic intForKey:@"Type"]==3 ?NSTextAlignmentCenter:NSTextAlignmentLeft;
    
    return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.titles count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[self.titles objectAtIndex:section] objectForKey:@"Detail"] count];
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return  [[self.titles objectAtIndex:section] strForKey:@"Header"];
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view =  [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
    view.backgroundColor = [UIColor clearColor];
    UILabel *lable = [[[UILabel alloc]initWithFrame:CGRectMake(20, -10, 320, 44)] autorelease];
    lable.text = [[self.titles objectAtIndex:section] strForKey:@"Header"];
    UIFont *font = [UIFont fontWithName:@"Arial" size:20.0f];
    lable.font = font;
    
    [view addSubview:lable];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}



- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
