//
//  RiBaoDtlTagViewController.m
//  UMobile
//
//  Created by Rid on 15/1/22.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RiBaoDtlTagViewController.h"

@implementation RiBaoDtlTagViewController

@synthesize result;
@synthesize callFunction;
@synthesize navTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Do any additional setup after loading the view.

-(void)setSegmentController{
    //应收总帐明细 ，需要在 55 号函数增加 筛选的 参数
    __block RiBaoDtlTagViewController *tempSelf = self;
    [self.segment setItem:@[@{@"text":@"今天"},@{@"text":@"本周"},@{@"text":@"本月"},@{@"text":@"本季"}] andSelectionBlock:^(NSUInteger segmentIndex) {
        tempSelf.fliterDic = [NSMutableDictionary dictionaryWithObject:@"-1" forKey:@"2"];
        [tempSelf.result removeAllObjects];
        [tempSelf loadData];
    }];
    
    self.segment.color= [UIColor colorWithRed:0.0f/255.0 green:141.0f/255.0 blue:147.0f/255.0 alpha:1];;// [UIColor colorWithRed:88.0f/255.0 green:88.0f/255.0 blue:88.0f/255.0 alpha:1];
    self.segment.borderWidth=0.5;
    self.segment.borderColor=[UIColor darkGrayColor];
    self.segment.selectedColor= [UIColor orangeColor] ;//[UIColor colorWithRed:0.0f/255.0 green:141.0f/255.0 blue:147.0f/255.0 alpha:1];
    self.segment.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                  NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.segment.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                          NSForegroundColorAttributeName:[UIColor whiteColor]};
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    page = 1;
    self.result = [NSMutableArray array];
    nColumn = 1;
    if (self.fixColumn > 0) {
        nColumn = self.fixColumn;
    }
    self.fliterDic = [NSMutableDictionary dictionaryWithObject:@"-1" forKey:@"2"];
    self.tableView.fixColumn = nColumn;
    [self loadCallFunction];
    [self loadData];
    [self setSegmentController];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView initContent];
}
-(void)loadCallFunction{
    self.navigationItem.title = self.navTitle;
//    self.tableView.bFooterRefreshing = YES;
    self.tableView.bCountTotal = YES;
    
    self.tableView.titles = @[@"单据日期",@"单据编号",@"客户名称",@"业务员",@"增加",@"减少",@"期末余额"];
    self.tableView.titleWidths = @[@"80",@"80",@"120",@"100",@"80",@"80",@"80"];
    self.tableView.countColumns = @[@"",@"",@"",@"",@"1",@"1",@""];
    self.tableView.keys = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6"];
    self.tableView.fixColumn = 2;
    self.tableView.bCountTotal = YES;
    [self setFilterButton];

    
    self.tableView.rDelegate = self;

    
}
-(void)loadData{
    NSString *link = nil ;
    link = [self GetLinkWithFunction:79 andParam:[NSString stringWithFormat:@"%d,%d,'%@',%@,%@,'%@'",
                                                  [self.sId integerValue],self.segment.selectIndex,[self.fliterDic strForKey:@"1"],[self.fliterDic strForKey:@"2"],[self GetUserID],[self GetCurrentDate]]];

    self.result = [NSMutableArray array];
    __block RiBaoDtlTagViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [tempSelf.tableView footerEndRefreshing];
        if ([rs count] > 0)
            [tempSelf.result addObjectsFromArray:rs];
        else
            page -- ;
        
        tempSelf.tableView.result = self.result;
    } lock:YES];
}
//
//-(void)tableFooterRefreshing{
//    page ++;
//    [self loadData];
//}
//-(void)tableViewClickAtIndex:(NSUInteger)index withObject:(id)obj{
//    if (self.callFunction == 23){
//        RiBaoDtlViewController *vc = (RiBaoDtlViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"RiBaoDtlViewController"];
//        vc.callFunction = 25;
//        vc.navTitle = @"应收总帐明细";
//        NSArray *rs =  [self.result objectAtIndex:index];
//        vc.sId=[rs objectAtIndex:0];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if (self.callFunction == 26){
//        RiBaoDtlViewController *vc = (RiBaoDtlViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"RiBaoDtlViewController"];
//        vc.callFunction = 28;
//        vc.navTitle = @"应付明细";
//        
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}

-(void)setFilterButton{
    UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter2"] style:UIBarButtonItemStylePlain target:self action:@selector(filterClick)] autorelease];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)filterClick{
    KHFliterViewController *vc = (KHFliterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"KHFliterViewController"];
    vc.callFunction = self.callFunction;
    vc.fliterDic = self.fliterDic;
    vc.parentVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)loadDataWithNum:(NSString *)num{
    NSString *link = [self GetLinkWithFunction:79 andParam:[NSString stringWithFormat:@"%d,%d,'',-1,%@,'%@'",[self.sId integerValue],self.segment.selectIndex,[self GetUserID],[self GetCurrentDate]]];
    NSLog(@"%@",link);
    __block RiBaoDtlTagViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        [tempSelf.result removeAllObjects];
        NSArray * rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [tempSelf.result addObjectsFromArray:rs];
        tempSelf.tableView.result = self.result;
    } lock:YES];
    
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
    self.fliterDic = nil;
    [_tableView release];
    [_segment release];
    [super dealloc];
}

@end
