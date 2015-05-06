//
//  ShangPinDtlViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/14.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "ShangPinDtlViewController.h"

@interface ShangPinDtlViewController ()

@end

@implementation ShangPinDtlViewController

@synthesize result,products;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)shareClick:(id)sender {
    NSArray *rs = [self.result objectAtIndex:0];
    NSString *content = [NSString stringWithFormat:@"商品名称:%@\n型号:%@\n编码:%@\n规格:%@",
                         [rs objectAtIndex:3],
                         [rs objectAtIndex:7],
                         [rs objectAtIndex:2],
                         [rs objectAtIndex:6]
                         ];
    [self shareContent:content];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *link = [self GetLinkWithFunction:13 andParam:[NSString stringWithFormat:@"%d",self.shID]];//  [NSString stringWithFormat:@"%@?UID=119&Call=13&Param=%d",MainUrl,self.shID];

    __block ShangPinDtlViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        NSString *str = [self explandJsonString:obj];
        
        NSDictionary * resultDic=[str objectFromJSONString];
        if (resultDic==nil) {
            self.failedJSON=YES;
            //截取字符串
            NSRange range=[obj rangeOfString:@"\"D_Data\":"];
            NSString * resultString=[obj substringFromIndex:range.location];
            
            //切分字符串
            NSMutableArray *dataArray= [[resultString componentsSeparatedByString:@","] mutableCopy];
            
            //将商品详情单独取出并从数组中移除
            NSArray *detailArray=[dataArray subarrayWithRange:NSMakeRange(19, dataArray.count-19)];
            self.detail=[[detailArray componentsJoinedByString:@","] stringByReplacingOccurrencesOfString:@"]]}" withString:@""];
            [dataArray removeObjectsInArray:detailArray];
            
            //合并新数组
            NSString *jsonString=[NSString stringWithFormat:@"{%@]]}",[dataArray componentsJoinedByString:@","]];

            tempSelf.result=[[jsonString objectFromJSONString] objectForKey:@"D_Data"];
        }else{
            tempSelf.result = [resultDic objectForKey:@"D_Data"];
        }
        [tempSelf.tableView reloadData];
    } lock:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark table view


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    NSArray *titles = @[@"基本信息",@"价格信息",@"商品描述"];
//    RCTableTitleView *titleView = [[[RCTableTitleView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)] autorelease];
//    [titleView setBackgroundImage:nil];
//    [titleView setIcon:nil withText:titles[section]];
//    return titleView;
//}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[@[@"290",@"150",@"92"] objectAtIndex:indexPath.section] floatValue];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.result count] > 0?3:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    NSArray *rs =  [self.result firstObject];
    NSLog(@"%@", rs);
    if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        [self setText:[rs objectAtIndex:2] forView:cell withTag:1];
        [self setText:[rs objectAtIndex:6] forView:cell withTag:2];
        [self setText:[rs objectAtIndex:10] forView:cell withTag:3];
        [self setText:[rs objectAtIndex:11] forView:cell withTag:4];
        [self setText:[rs objectAtIndex:13] forView:cell withTag:5];
        [self setText:[rs objectAtIndex:5] forView:cell withTag:6];
        [self setText:[rs objectAtIndex:8] forView:cell withTag:7];
        [self setText:[rs objectAtIndex:7] forView:cell withTag:8];
        [self setText:[rs objectAtIndex:9] forView:cell withTag:9];
        [self setText:[rs objectAtIndex:12] forView:cell withTag:10];
        [self setText:[rs objectAtIndex:3] forView:cell withTag:11];

        
        [self setProductImage:[rs objectAtIndex:0] inImageView:[cell viewWithTag:99]];
        
    }else if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        NSArray *rights = @[@"商品最近售价",@"商品最近进价",@"商品最低售价",@"商品零售价",@"商品会员价"];//14,15,16,17,18
        for (int i = 1 ; i < 6 ; i ++){
            if ([self checkRight:[rights objectAtIndex:i - 1]]) {
                [self setText:[NSString stringWithFormat:@"%.02f 元/个",[[rs objectAtIndex:13 + i] doubleValue]]  forView:cell withTag:i];
            }else{
                [self setText:@"***** 元/个"  forView:cell withTag:i];
            }
        }
//        [self setText:[NSString stringWithFormat:@"%.02f 元/个",[[rs objectAtIndex:14] doubleValue]]  forView:cell withTag:1];
//        [self setText:[NSString stringWithFormat:@"%.02f 元/个",[[rs objectAtIndex:15] doubleValue]] forView:cell withTag:2];
//        [self setText:[NSString stringWithFormat:@"%.02f 元/个",[[rs objectAtIndex:16] doubleValue]] forView:cell withTag:3];
//        [self setText:[NSString stringWithFormat:@"%.02f 元/个",[[rs objectAtIndex:17] doubleValue]] forView:cell withTag:4];
//        [self setText:[NSString stringWithFormat:@"%.02f 元/个",[[rs objectAtIndex:18] doubleValue]] forView:cell withTag:5];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3"];
        if (self.isFailedJSON) {
            [self setText:self.detail forView:cell withTag:1];
        }else{
            [self setText:[rs objectAtIndex:19] forView:cell withTag:1];
        }
    }
    return cell;
}

-(IBAction)KCXXClick:(id)sender{
    NSLog(@"库存信息");
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
    self.result = nil;
    [self.detail release],self.result=nil;
    [_tableView release];
    [super dealloc];
}
@end
