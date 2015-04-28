//
//  ShouRuRiBaoViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/20.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "ShouRuRiBaoViewController.h"

@interface ShouRuRiBaoViewController ()

@end

@implementation ShouRuRiBaoViewController

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
 
    NSString *link = [self GetLinkWithFunction:38 andParam:[NSString stringWithFormat:@"'%@',1",[self GetCurrentDate]]];// [NSString stringWithFormat:@"%@?UID=119&Call=38&Param='',1",MainUrl];
    
//    NSString *link = [self GetLinkWithFunction:38 andParam:@"10,1,'2014-12-30',0,1"];
    
//    NSString *link = [self GetLinkWithFunction:38 andParam:[NSString stringWithFormat:@"10,'%@',1",[self GetCurrentDate]]];
    
    __block ShouRuRiBaoViewController *tempSelf = self;
    
    [self StartQuery:link completeBlock:^(id obj) {

//        tempSelf.result = [[obj objectFromJSONString] objectForKey:@"D_Data"];
//        NSMutableDictionary *dic = [self explainArray:self.result];
//        
//        tempSelf.pieChart.maxValue = [dic floatForKey:@"Max"];
//        tempSelf.pieChart.minValue = [dic floatForKey:@"Min"];
//        
//        tempSelf.pieChart.numYIntervals = 2;
//        tempSelf.pieChart.widthOfColumn = 50;
//        tempSelf.pieChart.xLabels = [dic objectForKey:@"Labels"];
//        tempSelf.pieChart.values = [dic objectForKey:@"Values"];
//        [tempSelf.pieChart reloadInView];
        
        tempSelf.result = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        
        //        PCPieChart *pieChart = (PCPieChart *)[tempSelf.view viewWithTag:1];
        // change   20150126
        PCPieChart *pieChart = (PCPieChart *)[self.view viewWithTag:999];
        if (pieChart == nil) {
            pieChart = [[[PCPieChart alloc] init] autorelease];
            pieChart.showValue = YES;
            pieChart.frame = CGRectMake(10, 20, self.view.bounds.size.width - 20, self.view.bounds.size.height - 30);
            pieChart.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) + 10);
            pieChart.tag = 999;
            [self.view addSubview:pieChart];
        }

        
        [self setPieChart:pieChart withArray:[self explainToPercent:tempSelf.result toIndex:0]];
        
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
        
        if (i==0)
        {
            [component setColour:PCColorYellow];
        }
        else if (i==1)
        {
            [component setColour:PCColorGreen];
        }
        else if (i==2)
        {
            [component setColour:PCColorOrange];
        }
        else if (i==3)
        {
            [component setColour:PCColorRed];
        }
        else
        {
            [component setColour:PCColorBlue];
        }
    }
    [pieChart setComponents:components];
}

-(NSMutableArray *)explainToPercent:(NSArray *)arr toIndex:(NSInteger)index{
    index = [arr count];
    
    NSMutableArray *rs =  [NSMutableArray array];
    CGFloat total = 0;
    for (int i = 0 ; i < index ; i ++){
        NSArray *item = [arr objectAtIndex:i];
        
        total += [[item objectAtIndex:3] floatValue];
    }
    if (total == 0) total = 1;
    for (int i =0 ; i < index ; i ++){
        NSArray *it = [arr objectAtIndex:i];
        
        NSDictionary *item = @{@"Title": [it objectAtIndex:2],
                               @"Value": [NSString stringWithFormat:@"%0.2f",[[it objectAtIndex:3] floatValue]]};
        
        [rs addObject:item];
    }
    
    return rs;
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
    [super dealloc];
}
@end
