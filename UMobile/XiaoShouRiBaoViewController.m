//
//  XiaoShouRiBaoViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/20.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "XiaoShouRiBaoViewController.h"

@interface XiaoShouRiBaoViewController ()

@end

@implementation XiaoShouRiBaoViewController

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
    
    __block XiaoShouRiBaoViewController *tempSelf = self;
    [self.segmentedController setItem:@[@{@"text":@"商品明细"},@{@"text":@"商品分类"},@{@"text":@"客户"},@{@"text":@"业务员"}] andSelectionBlock:^(NSUInteger segmentIndex) {
        [tempSelf.parentVC performSelector:@selector(setCallBackType:) withObject:(id)self.segmentedController.selectIndex];
        [tempSelf loadData];
    }];
    
    self.segmentedController.color= [UIColor colorWithRed:0.0f/255.0 green:141.0f/255.0 blue:147.0f/255.0 alpha:1];;// [UIColor colorWithRed:88.0f/255.0 green:88.0f/255.0 blue:88.0f/255.0 alpha:1];
    self.segmentedController.borderWidth=0.5;
    self.segmentedController.borderColor=[UIColor darkGrayColor];
    self.segmentedController.selectedColor= [UIColor orangeColor] ;//[UIColor colorWithRed:0.0f/255.0 green:141.0f/255.0 blue:147.0f/255.0 alpha:1];
    self.segmentedController.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                              NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.segmentedController.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                      NSForegroundColorAttributeName:[UIColor whiteColor]};
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
        CGFloat v = [[rs objectAtIndex:2] floatValue];
        if (v > max) max = v;
        if (v <= min) min = v;
        [values addObject:[NSString stringWithFormat:@"%0.2f",v]];
        [labels addObject:[rs objectAtIndex:1]];
    }
    [dic setObject:[NSString stringWithFormat:@"%0.2f",max] forKey:@"Max"];
    [dic setObject:[NSString stringWithFormat:@"%0.2f",min] forKey:@"Min"];
    [dic setObject:values forKey:@"Values"];
    [dic setObject:labels forKey:@"Labels"];
    return dic;
}

-(void)loadData{
    NSString *link = [self GetLinkWithFunction:29 andParam:[NSString stringWithFormat:@"10,'%@',%d,%@",[self GetCurrentDate],self.segmentedController.selectIndex,[[self setting] objectForKey:@"UID"]]];// [NSString stringWithFormat:@"%@?UID=119&Call=29&Param=10,'',%d,1",MainUrl,self.segmentedController.selectIndex];
    
    __block XiaoShouRiBaoViewController *tempSelf = self;
    
    [self StartQuery:link completeBlock:^(id obj) {
        if (obj != nil) {
            NSMutableString *str = [NSMutableString stringWithString:[NSMutableString deleteSpecialChar:obj]];
            tempSelf.result = [[str objectFromJSONString] objectForKey:@"D_Data"];
        }
        NSMutableDictionary *dic = [self explainArray:self.result];
        
        tempSelf.columnView.maxValue = [dic floatForKey:@"Max"];
        tempSelf.columnView.minValue = [dic floatForKey:@"Min"];
        
        tempSelf.columnView.numYIntervals = 6;
        tempSelf.columnView.widthOfColumn = 60;// bHighRetain?50:30;//tempSelf.columnView.frame.size.width / ([tempSelf.result count] + 2);
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
    [_segmentedController release];
    [super dealloc];
}


@end
