//
//  CaiGouRiBaoViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/20.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "CaiGouRiBaoViewController.h"

@interface CaiGouRiBaoViewController ()

@end

@implementation CaiGouRiBaoViewController

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
    
    NSString *param = [NSString stringWithFormat:@"5,'%@',1", [self GetCurrentDate]];
    
    NSString *link = [self GetLinkWithFunction:32 andParam:param];//  [NSString stringWithFormat:@"%@?UID=119&Call=32&Param=5,'',1",MainUrl];
    
    __block CaiGouRiBaoViewController *tempSelf = self;
    
    [self StartQuery:link completeBlock:^(id obj) {
        tempSelf.result = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        NSMutableDictionary *dic = [self explainArray:self.result];
        tempSelf.columnView.maxValue = [dic floatForKey:@"Max"];
        tempSelf.columnView.minValue = [dic floatForKey:@"Min"];
        
        tempSelf.columnView.numYIntervals = 2;
        tempSelf.columnView.widthOfColumn = 60;
        tempSelf.columnView.xLabels = [dic objectForKey:@"Labels"];
        tempSelf.columnView.values = [dic objectForKey:@"Values"];
        [tempSelf.columnView reloadInView];
    } lock:NO];
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
    [_columnView release];
    [super dealloc];
}
@end
