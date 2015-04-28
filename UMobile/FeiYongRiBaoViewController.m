//
//  FeiYongRiBaoViewController.m
//  UMobile
//
//  费用日报
//
//  Created by  APPLE on 2014/9/20.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "FeiYongRiBaoViewController.h"

@interface FeiYongRiBaoViewController ()

@end

@implementation FeiYongRiBaoViewController

@synthesize result;

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
    self.result  = [NSMutableArray array];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableDictionary *)explainArray:(NSArray *)arr{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    CGFloat max = 0;
    CGFloat min = 0;
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *labels = [NSMutableArray array];
    for (NSArray *rs in arr){
        CGFloat v = [[rs objectAtIndex:3] floatValue];
        if (v > max) max = v;
        if (v <= min) min = v;
        [values addObject:[NSString stringWithFormat:@"%0.2f",v]];
        [labels addObject:[rs objectAtIndex:2]];
    }
    [dic setObject:[NSString stringWithFormat:@"%0.2f",max] forKey:@"Max"];
    [dic setObject:[NSString stringWithFormat:@"%0.2f",min] forKey:@"Min"];
    [dic setObject:values forKey:@"Values"];
    [dic setObject:labels forKey:@"Labels"];
    return dic;
}

-(void)loadData{
//    NSString *link = [self GetLinkWithFunction:35 andParam:@"'%@',1"];//6 [NSString stringWithFormat:@"%@?UID=119&Call=35&Param='',1",MainUrl];
    
    NSString *link = [self GetLinkWithFunction:35 andParam:[NSString stringWithFormat:@"'%@',%@",[self GetCurrentDate],[self GetUserID]]];
//    NSString *link = [self GetLinkWithFunction:35 andParam:[NSString stringWithFormat:@"'%@',%@",[self GetCurrentDate],[[self setting] objectForKey:@"UID"]]];
    
    __block FeiYongRiBaoViewController *tempSelf = self;
    
    [self StartQuery:link completeBlock:^(id obj) {
        /*
        tempSelf.result = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        NSMutableDictionary *dic = [self explainArray:self.result];
        
        tempSelf.pieChart.maxValue = [dic floatForKey:@"Max"];
        tempSelf.pieChart.minValue = [dic floatForKey:@"Min"];
        
        tempSelf.pieChart.numYIntervals = 2;
        tempSelf.pieChart.widthOfColumn = 30;
        tempSelf.pieChart.xLabels = [dic objectForKey:@"Labels"];
        tempSelf.pieChart.values = [dic objectForKey:@"Values"];
        [tempSelf.pieChart reloadInView];
        */
        
        
        tempSelf.result = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        
//        PCPieChart *pieChart = (PCPieChart *)[tempSelf.view viewWithTag:1];
        // change   20150126
        PCPieChart *pieChart = (PCPieChart *)[self.view viewWithTag:999];
        if (pieChart == nil) {
            pieChart = [[[PCPieChart alloc] init] autorelease];
            pieChart.tag = 999;
            pieChart.showValue = YES;
            pieChart.frame = CGRectMake(10, 20 , self.view.bounds.size.width - 20, self.view.bounds.size.height - 30);
            pieChart.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) + 10);
            [tempSelf.view addSubview:pieChart];
        }

        
        [tempSelf setPieChart:pieChart withArray:[tempSelf explainToPercent:tempSelf.result toIndex:0]];
        //[self setPieChart:pieChart withArray:tempSelf.result];
        
        
        
    } lock:NO];
}

-(void)setPieChart:(PCPieChart *)pieChart withArray:(NSArray *)Rs{
    if (Rs == nil) {
        return;
    }
    [pieChart setSameColorLabel:YES];
    
    NSMutableArray *components =  [NSMutableArray array];
    for (int i=0; i<[Rs count]; i++)
    {
        NSDictionary *item = [Rs objectAtIndex:i];
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:[item strForKey:@"Title"] value:[[item strForKey:@"Value"] floatValue]];
        
        //NSArray *item = [Rs objectAtIndex:i];
        //PCPieComponent *component = [PCPieComponent pieComponentWithTitle:item[2] value:[item[3] floatValue]];
        
        [components addObject:component];
        
        NSArray *colors =  @[PCColor1,PCColor2,PCColor3,PCColor4,PCColor5,PCColor6,PCColor7,PCColor8,PCColor9,PCColor10,PCColor11,PCColor12,
                             PCColor1,PCColor2,PCColor3,PCColor4,PCColor5,PCColor6,PCColor7,PCColor8,PCColor9,PCColor10,PCColor11,PCColor12];
        
        [component setColour:[colors objectAtIndex:i]];
    }
    [pieChart setComponents:components];
}

-(NSMutableArray *)explainToPercent:(NSArray *)arr toIndex:(NSInteger)index{
    index = [arr count];
    
    NSMutableArray *rs =  [NSMutableArray array];
//    CGFloat total = 0;
//    for (int i = 0 ; i < index ; i ++){
//        NSArray *item = [arr objectAtIndex:i];
//        
//        total += [[item objectAtIndex:3] floatValue];
//    }

    for (int i =0 ; i < index ; i ++){
        NSArray *it = [arr objectAtIndex:i];
        
        NSDictionary *item = @{@"Title": [it objectAtIndex:2],
                               @"Value": [it objectAtIndex:3]};
        NSLog(@"item %@",item);
        
        [rs addObject:item];
    }
    
    return rs;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [UIScreen mainScreen].bounds.size.width;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [self.result count] > 0?1:0;
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return [self.result count] > 0?1:0;;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSArray *rs =  [self.result objectAtIndex:0];
//    
////    if (indexPath.row == 0){
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
//        
//        [self setText:[rs objectAtIndex:0] forView:cell withTag:1];
//        [self setText:[rs objectAtIndex:1] forView:cell withTag:2];
//        [self setText:[rs objectAtIndex:2] forView:cell withTag:3];
//        
//        
//        PCPieChart *pieChart = (PCPieChart *)[cell viewWithTag:4];
//        
//        [self setPieChart:pieChart withArray:[self explainToPercent:rs toIndex:2]];
//        
//        return cell;
//}



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
    //[_pieChart release];
    [super dealloc];
}
@end
