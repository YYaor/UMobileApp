//
//  KHGLAddViewController.m
//  UMobile
//
//  Created by 陈 景云 on 14-10-14.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "KHGLAddViewController.h"

@interface KHGLAddViewController ()

@end

@implementation KHGLAddViewController

@synthesize info;
@synthesize categoryInfo,priceInfo,typeInfo;
@synthesize cusInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.info =  [NSMutableDictionary dictionary];
    [self.info setObject:@"0" forKey:@"5"];
    [self.info setObject:@"100" forKey:@"6"];
    [self.info setObject:@"0" forKey:@"7"];
    [self.info setObject:@"100" forKey:@"8"];
    
    if (self.cusInfo){
        self.navigationItem.title = @"往来单位编辑";
        [self.info setObject:[self.cusInfo objectAtIndex:0] forKey:@"16"];
        self.typeInfo =  [NSMutableArray arrayWithObjects:[self.cusInfo objectAtIndex:16],[self.cusInfo objectAtIndex:17], nil];
//        self.typeInfo = [NSMutableArray arrayWithObjects:@"-1",[self.cusInfo objectAtIndex:3], nil];
        self.priceInfo = [NSMutableArray array];
        self.priceInfo2 = [NSMutableArray array];
        
        NSDictionary *dic = @{@"客户":@"1",@"供应商":@"2",@"两者皆是":@"3"};
        self.categoryInfo = [NSMutableArray arrayWithObjects:[dic strForKey:[self.cusInfo objectAtIndex:3]],[self.cusInfo objectAtIndex:3], nil];
        
        [self.info setObject:[self.cusInfo objectAtIndex:1] forKey:@"1"];
        [self.info setObject:[self.cusInfo objectAtIndex:2] forKey:@"2"];
        [self.info setObject:[self.cusInfo objectAtIndex:3] forKey:@"3"];
        [self.info setObject:[self.cusInfo objectAtIndex:17] forKey:@"4"];
        
        [self.info setObject:@"不启用" forKey:@"5"];
        [self.info setObject:@"不启用" forKey:@"7"];
        
        if ([self.setting intForKey:@"ISBS"] == 1) {
            NSDictionary *priInfo = @{@"0":@"不启用",@"1":@"预设售价一",@"2":@"预设售价二",@"3":@"预设售价三",@"4":@"预设售价四",@"5":@"预设售价五",@"6":@"零售价"};
//            20,21,22,23
            // BS 接口才能拿到 预设 信息？
            if ([self.cusInfo count] > 20) {
                [self.info setObj:[priInfo objectForKey:[self.cusInfo objectAtIndex:20]] forKey:@"5"];
                [self.info setObj:[self.cusInfo objectAtIndex:22] forKey:@"6"];
                [self.info setObj:[priInfo objectForKey:[self.cusInfo objectAtIndex:21]] forKey:@"7"];
                [self.info setObj:[self.cusInfo objectAtIndex:23] forKey:@"8"];
            }
        }
        


        

        
        [self.info setObject:[self.cusInfo objectAtIndex:4] forKey:@"9"];
        [self.info setObject:[self.cusInfo objectAtIndex:5] forKey:@"10"];
        [self.info setObject:[self.cusInfo objectAtIndex:6] forKey:@"17"];
        [self.info setObject:[self.cusInfo objectAtIndex:7] forKey:@"11"];
        
        [self.info setObject:[self.cusInfo objectAtIndex:11] forKey:@"14"];
        [self.info setObject:[self.cusInfo objectAtIndex:13] forKey:@"15"];
        [self.info setObject:[self.cusInfo objectAtIndex:14] forKey:@"18"];
        [self.info setObject:[self.cusInfo objectAtIndex:15] forKey:@"13"];
        [self.info setObject:[self.cusInfo objectAtIndex:12] forKey:@"12"];
    }else{
        [self.info setObject:@"-1" forKey:@"16"];
        [self.info setObject:@"不启用" forKey:@"5"];
        [self.info setObject:@"不启用" forKey:@"7"];
        [self.info setObject:@"客户" forKey:@"3"];
        self.priceInfo = [NSMutableArray arrayWithObjects:@"0",@"不启用", nil];
        self.priceInfo2 = [NSMutableArray arrayWithObjects:@"0",@"不启用", nil];
        self.categoryInfo = [NSMutableArray arrayWithObjects:@"1",@"客户", nil];
        self.typeInfo = [NSMutableArray array];
    }

    cellCount = 2;
    [self createTableFooter:@"更多"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    // Do any additional setup after loading the view.
}

-(void)footButtonClick:(id)sender{
    if (cellCount == 2) {
        cellCount = 4;
        [self createTableFooter:@"收起"];
    }else{
        cellCount = 2;
        [self createTableFooter:@"更多"];
    }
    [self.tableView reloadData];
}

-(void)createTableFooter:(NSString *)title{
    self.tableView.tableFooterView = nil;
    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
    view.backgroundColor = [UIColor clearColor];
    APRoundedButton *button = [[[APRoundedButton alloc]initWithFrame:CGRectMake(10, 5, 300, 30)] autorelease];
    button.backgroundColor = [UIColor clearColor];
    [button setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [view addSubview:button];
    self.tableView.tableFooterView = view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardWillShow:(id)info{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 280, 0);
}

-(void)keyboardWillHide:(id)info{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    curTextField = textField;
    
    UITableViewCell *cell = [self GetSuperCell:textField];
    NSIndexPath *indexPath =  [self.tableView indexPathForCell:cell];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.info setObject:textField.text forKey:[NSString stringWithFormat:@"%d",textField.tag]];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 3 || textField.tag == 4 || textField.tag == 5 || textField.tag == 7){
//        [curTextField resignFirstResponder];
        
        CangKuViewController *vc = (CangKuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CangKuViewController"];
        vc.parentVC = self;
        switch (textField.tag) {
            case 3:
                vc.info = self.categoryInfo;
                vc.title = @"所属分类";
                vc.result = @[@[@"1",@"客户"],@[@"2",@"供应商"],@[@"3",@"两者皆是"]];
                break;
            case 4:
                vc.info = self.typeInfo;
                vc.title = @"所属父类";
                vc.link = [self GetLinkWithFunction:77 andParam:[NSString stringWithFormat:@"20,0,%@",[self GetUserID]]];
                break;
            case 5:
                vc.info = self.priceInfo;
                vc.title = @"价格等级";
                vc.result = @[@[@"0",@"不启用"],@[@"1",@"预设售价一"],@[@"2",@"预设售价二"],@[@"3",@"预设售价三"],@[@"4",@"预设售价四"],@[@"5",@"预设售价五"],@[@"6",@"零售价"]];
                break;
            case 7:
                vc.info = self.priceInfo2;
                vc.title = @"价格等级";
                vc.result = @[@[@"0",@"不启用"],@[@"1",@"预设售价一"],@[@"2",@"预设售价二"],@[@"3",@"预设售价三"],@[@"4",@"预设售价四"],@[@"5",@"预设售价五"],@[@"6",@"零售价"]];
                break;
            default:
                break;
        }

        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}
- (IBAction)saveClick:(id)sender {
    
    [curTextField resignFirstResponder];
    NSArray *notes = @[@"请先选择所属分类",@"往来单位名称和编码不能为空"];
    if ([self.info emptyForKey:@"1"] || [self.info emptyForKey:@"2"]){
        [self.view makeToast:[notes objectAtIndex:1]];
        return;
    }
    if ([self.typeInfo count] == 0) {
        [self.view makeToast:[notes objectAtIndex:0]];
        return;
    }
    NSMutableString *param = [NSMutableString string];
    for (int i = 1 ; i < 19 ; i ++){
        if (i == 6 | i == 8 )
            [param appendFormat:@"%d,",[self.info intForKey:[NSString stringWithFormat:@"%d",i]]];
        else if (i == 5)
            [param appendFormat:@"%d,",[[self.priceInfo ingoreObjectAtIndex:0] integerValue]];
        else if (i == 7)
            [param appendFormat:@"%d,",[[self.priceInfo2 ingoreObjectAtIndex:0] integerValue]];
        else if (i == 4)
            [param appendFormat:@"%@,",[self.typeInfo ingoreObjectAtIndex:0]];
        else if (i == 16)
            [param appendFormat:@"%@,",[self.info strForKey:[NSString stringWithFormat:@"%d",i]]];
        else if (i == 18)
            [param appendFormat:@"'%@'",[self.info strForKey:[NSString stringWithFormat:@"%d",i]]];
        else
            [param appendFormat:@"'%@',",[self.info strForKey:[NSString stringWithFormat:@"%d",i]]];
    }
    NSString *link =  [self GetLinkWithFunction:73 andParam:[param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    __block KHGLAddViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic intForKey:@"success"] == 1){
            if (self.cusInfo){
                [tempSelf ShowMessage:@"修改成功"];
//                if ([self.setting intForKey:@"ISBS"] == 1) {
//                    [tempSelf.parentVC performSelector:@selector(loadData) withObject:nil];
//                }
            }else{
                
                [tempSelf ShowMessage:@"新增成功"];
            }
            [tempSelf dismiss];
        }else{
            [tempSelf ShowMessage:[dic strForKey:@"Result"]];
        }
    } lock:YES];
}

-(void)loadData{
    @try {
        [self.info setObject:[self.categoryInfo ingoreObjectAtIndex:1] forKey:@"3"];//所属类型
        [self.info setObject:[self.typeInfo ingoreObjectAtIndex:1] forKey:@"4"];//所属分类
        [self.info setObject:[self.priceInfo ingoreObjectAtIndex:1] forKey:@"5"];
        [self.info setObject:[self.priceInfo2 ingoreObjectAtIndex:1] forKey:@"7"];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }


    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

}

#pragma mark -
#pragma mark tableview delegate

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 40;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
//    view.backgroundColor = [UIColor clearColor];
//    APRoundedButton *button = [[[APRoundedButton alloc]initWithFrame:CGRectMake(10, 5, 300, 30)] autorelease];
//    button.backgroundColor = [UIColor blueColor];
//    [button setTitle:@"更多" forState:UIControlStateNormal];
//    [view addSubview:button];
//    return view;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *heights = nil;
    if ([[self.categoryInfo ingoreObjectAtIndex:0] integerValue] == 3) {
        heights = @[@"80.0",@"220.0",@"150.0",@"180"];
    }else{
        heights = @[@"80.0",@"150.0",@"150.0",@"180"];
    }
    
    return [[heights objectAtIndex:indexPath.row] floatValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *secondType = @"";
    if (indexPath.row == 1) {
        secondType = [[self.categoryInfo ingoreObjectAtIndex:0] integerValue] == 3?@"":[self.categoryInfo ingoreObjectAtIndex:0];
    }
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%d%@",indexPath.row + 1,secondType];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    for (int i = 1 ; i < 19 ; i ++){
        UITextField *textField = (UITextField *)[cell viewWithTag:i];
        
        /*by hgg 20150312
        if(textField)
            textField.text = [self.info strForKey:[NSString stringWithFormat:@"%d",i]];
        */
        if(textField){
            textField.text = [self.info strForKey:[NSString stringWithFormat:@"%d",textField.tag]];
        }
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cellCount;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)dealloc {
    self.typeInfo = nil;
    self.categoryInfo = nil;
    self.priceInfo = nil;
    self.info = nil;
    [_tableView release];
    [super dealloc];
}
@end
