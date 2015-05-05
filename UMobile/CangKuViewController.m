//
//  CangKuViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/23.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "CangKuViewController.h"

@interface CangKuViewController ()

@end

@implementation CangKuViewController
@synthesize result,info,title,link;
@synthesize chooseType;
@synthesize delegate;

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
    if (self.title) self.navigationItem.title = self.title;
    if (!self.result){
        [self setHeaderRefresh:self.tableView];
        [self.tableView headerBeginRefreshing];
    }
    // Do any additional setup after loading the view.
    
}


-(void)headerRereshing{
    if (!self.link)
        self.link = [self GetLinkWithFunction:62 andParam:@"'',0,0,1,1"];//  [NSString stringWithFormat:@"%@?UID=119&Call=62&Param='',1",MainUrl];
    
    __block CangKuViewController *tempSelf = self;
    [self StartQuery:self.link completeBlock:^(id obj) {
        
        if ([[[obj objectFromJSONString] objectForKey:@"success"] isEqual:@"0"]) {  //授权失败
            
            // fixBug   网络状况不佳，服务器返回错误
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据加载失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[obj objectFromJSONString] objectForKey:@"Result"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
        }else{  //授权成功
            
            //判断是否绑定过
            //获取应用程序沙盒的Documents目录
            //            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            //            NSString *plistPath1 = [paths objectAtIndex:0];
            //
            //            //得到完整的文件名
            //            NSString *filename=[plistPath1 stringByAppendingPathComponent:@"user.plist"];
            //
            //            //那怎么证明我的数据写入了呢？读出来看看
            //            NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
            //            //NSLog(@"%@", data1);
            //            NSString *uid = [data1 objectForKey:@"uid"];
            //            if (nil == uid || [@""  isEqual: uid]) {    //未绑定
            //                //写入用户配置文件 uid
            //                NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
            //                NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
            //
            //                //添加一项内容
            //                [data setObject:[self uuid] forKey:@"uid"];
            //                [data setObject:[[self setting] objectForKey:@"PhoneNum"] forKey:@"tel"];
            //                //输入写入
            //                [data writeToFile:filename atomically:YES];
            //            }
            if (self.tel == nil) {
                self.tel = [self.setting strForKey:@"PhoneNum"];
            }

            tempSelf.result =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
            [tempSelf.tableView reloadData];
        }
        
        [tempSelf.tableView headerEndRefreshing];
        
    } lock:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
    NSUInteger sIndex = self.showIndex > 0?self.showIndex:1;
    [self setText:[rs objectAtIndex:sIndex] forView:cell withTag:1];
    if ([self.info count] > 0) {
        UIImage *image = [[rs objectAtIndex:0] isEqualToString:[self.info ingoreObjectAtIndex:0]]?[UIImage imageNamed:@"choose"]:[UIImage imageNamed:@"choose_no"];
        [self setImage:image forView:cell withTag:2];
    }

    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *rs =  [self.result objectAtIndex:indexPath.row];
    [self.info removeAllObjects];
    NSUInteger sIndex = self.showIndex > 0?self.showIndex:1;
    
    if(2 == rs.count){
        [self.info addObjectsFromArray:@[[rs objectAtIndex:0]
                                         ,[rs objectAtIndex:1]]];
        // add orderType notif  20150204    ghd
        NSNotification *notification =[NSNotification notificationWithName:@"sendOrderMessage" object:nil userInfo:@{@"message":rs}];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else{
        [self.info addObjectsFromArray:@[[rs objectAtIndex:0]
                                         ,[rs objectAtIndex:sIndex]
                                         ,[rs ingoreObjectAtIndex:4]
                                         ,[rs objectAtIndex:3]]];
    }
    
    // change   ghd 0205
    if ([self.title isEqualToString:@"选择账套"]) {
        [self.parentVC performSelector:@selector(resetUser)];
    }
    if (chooseType == ChooseCkType_FHCK){
        if (delegate && [delegate respondsToSelector:@selector(FHCKSelectedWithckId:ckName:)]){
            [delegate FHCKSelectedWithckId:[[rs objectAtIndex:0] integerValue] ckName:[rs objectAtIndex:1]];
        }
    }else if (chooseType == ChooseCkType_DHCK){
        if (delegate && [delegate respondsToSelector:@selector(DHCKSelectedWihtckId:ckName:)]){
            [delegate DHCKSelectedWihtckId:[[rs objectAtIndex:0] integerValue] ckName:[rs objectAtIndex:1]];
        }
    }
    
    [self.parentVC performSelector:@selector(loadData) withObject:nil];
    
    [self dismiss];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self dismiss];
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

-(void)dealloc{
    self.link = nil;
    self.title = nil;
    self.result = nil;
    [_tableView release];
    [super dealloc];
}

@end
