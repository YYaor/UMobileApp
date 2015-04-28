//
//  ChartViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/18.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "ChartViewController.h"

@interface ChartViewController ()

@end

@implementation ChartViewController

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
//    self.info = @[@[@"0",@"abc",@"20"],
//                  @[@"0",@"def",@"25"],
//                  @[@"0",@"gh",@"25"],
//                  @[@"0",@"1aa",@"30"]
//                  ];

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.callFuntion == Function_KCJJ)
        [self initContent];
    else
        [self initLines];
}

-(NSMutableDictionary *)explainInfo:(NSArray *)arr{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSMutableArray *points = [NSMutableArray array];
    NSMutableArray *xTitles = [NSMutableArray array];
    CGFloat maxValue = 0;
    CGFloat minValue = 0;

    for (NSArray *rs in arr){
        NSDecimalNumber *num = [[[NSDecimalNumber alloc]initWithString:[rs objectAtIndex:2]] autorelease];
        CGFloat curValue = [[rs objectAtIndex:2] doubleValue];
        [points addObject:[num stringValue]];//[rs objectAtIndex:2]];
        [xTitles addObject:[NSString stringWithFormat:@"%@",[rs objectAtIndex:0]]];
        if (maxValue < curValue) maxValue = curValue;
        if (minValue > curValue) minValue = curValue;
    }
    [result setObject:points forKey:@"Points"];
    [result setObject:xTitles forKey:@"xTitles"];
    [result setObject:[NSString stringWithFormat:@"%f",maxValue] forKey:@"MaxValue"];
    [result setObject:[NSString stringWithFormat:@"%f",minValue] forKey:@"MinValue"];
    return result;
}

-(void)initLines{
    


    //线图
    PCLineChartView *lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    [self.view addSubview:lineChartView];
    [lineChartView release];
		
    NSDictionary *lineInfo = [self explainInfo:self.info];
    
    lineChartView.minValue = [[lineInfo objectForKey:@"MinValue"] floatValue] - 10 ;
    lineChartView.maxValue = [[lineInfo objectForKey:@"MaxValue"] floatValue] + 10 ;
    lineChartView.autoscaleYAxis = YES;

    //lineChartView.interval = (lineChartView.maxValue - lineChartView.minValue) / 5 ;
    
    NSMutableArray *components = [NSMutableArray array];
	

    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init] ;
    [component setTitle:@""];
    [component setPoints:[lineInfo objectForKey:@"Points"]];
//    [component setShouldLabelValues:YES];
    
    [component setColour:PCColorRed];
    
    
    [components addObject:component];
    [component release];
		
    [lineChartView setComponents:components];
	[lineChartView setXLabels:[lineInfo objectForKey:@"xTitles"]];
	
}

-(void)initContent{
    //饼图
//    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-width)/2,([self.view bounds].size.height-height)/2,width,height)];
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:150];
    [pieChart setSameColorLabel:YES];
//    [pieChart setShowArrow:YES];
    [pieChart setShowValue:YES];
    
    [self.view addSubview:pieChart];
    [pieChart release];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
        pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
    }
    
    
    NSMutableArray *components =  [NSMutableArray array];
    NSArray *colors =  @[PCColor1,PCColor2,PCColor3,PCColor4,PCColor5,PCColor6,PCColor7,PCColor8,PCColor9,PCColor10,PCColor11,PCColor12];
    
    for (int i=0; i<[self.info count]; i++)
    {
        NSArray *item = [self.info objectAtIndex:i];
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:[item objectAtIndex:1] value:[[item objectAtIndex:2] doubleValue]];
        
        [components addObject:component];
        
        
        [component setColour:[colors objectAtIndex:i % 12]];
        

    }
    [pieChart setComponents:components];

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
