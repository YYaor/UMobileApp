//
//  BaoBiaoViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/19.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "BaoBiaoViewController.h"

@interface BaoBiaoViewController ()


@end

@implementation BaoBiaoViewController

@synthesize leftArray;
@synthesize viewControllers;
@synthesize callBackType;

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
    self.callBackType = 0;
    
    NSArray *rs = @[[self.storyboard instantiateViewControllerWithIdentifier:@"ZiJinRiBaoViewController"],
                    [self.storyboard instantiateViewControllerWithIdentifier:@"YingShouRiBaoViewController"],
                    [self.storyboard instantiateViewControllerWithIdentifier:@"YingFuRiBaoViewController"],
                    [self.storyboard instantiateViewControllerWithIdentifier:@"XiaoShouRiBaoViewController"],
                    [self.storyboard instantiateViewControllerWithIdentifier:@"CaiGouRiBaoViewController"],
                    [self.storyboard instantiateViewControllerWithIdentifier:@"FeiYongRiBaoViewController"],
                    [self.storyboard instantiateViewControllerWithIdentifier:@"ShouRuRiBaoViewController"],
                    [self.storyboard instantiateViewControllerWithIdentifier:@"ZhiBiaoKanBanViewController"]
                             ];
    self.viewControllers = [NSMutableArray arrayWithArray:rs];
    
    self.leftArray = @[@{@"Name": @"资金日报",@"Image":@"指标看板a_06",@"Action":@"rabioClick:",@"Function":@"51"},
                       @{@"Name": @"应收日报",@"Image":@"指标看板a_09",@"Action":@"yjClick:",@"Function":@"52"},
                       @{@"Name": @"应付日报",@"Image":@"指标看板a_12",@"Action":@"shClick:",@"Function":@"53"},
                       @{@"Name": @"销售日报",@"Image":@"指标看板a_14",@"Action":@"phbClick:",@"Function":@"54"},
                       @{@"Name": @"采购日报",@"Image":@"指标看板a_16",@"Action":@"bbzxClick:",@"Function":@"0"},
                       @{@"Name": @"费用日报",@"Image":@"指标看板a_18",@"Action":@"bbzxClick:",@"Function":@"0"},
                       @{@"Name": @"收入日报",@"Image":@"指标看板a_20",@"Action":@"bbzxClick:",@"Function":@"0"},
                       @{@"Name": @"指标看板",@"Image":@"指标看板a_22",@"Action":@"bbzxClick:",@"Function":@"0"}
                       ];
    
    // Do any additional setup after loading the view.
}

// fixBug       ghd     20151022
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!bload){
        bload = YES;
        [self setRightButton:0];
        NSDictionary *dic =  [self.leftArray objectAtIndex:0];
        self.navigationItem.title =  [dic strForKey:@"Name"];
        
        [[self.subVcView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGRect rect = CGRectZero;
        rect.origin = CGPointMake(0, 0);
        rect.size = self.subVcView.frame.size;
        RCViewController *vc = (RCViewController *) [self.viewControllers objectAtIndex:0];
        vc.parentVC  = self;
        vc.view.frame = rect;
        [self.subVcView addSubview:vc.view];
        [vc performSelector:@selector(loadData)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)dealloc{
    self.viewControllers = nil;
    self.leftArray = nil;
    [_tableView release];
    [_subVcView release];
    [super dealloc];
}

-(void)setRightButton:(BOOL) bSet{
    if(bSet){
        UIBarButtonItem *rightBarButton =  [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"StockCapitalOccupy-list"] style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonClick:)] autorelease];
        rightBarButton.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}



-(void)rightBarButtonClick:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UIViewController *vc = nil;
    if (indexPath.row == 1) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RiBaoDtlViewController"];
        [vc performSelector:@selector(setCallFunction:) withObject:(id)24];
        [vc performSelector:@selector(setNavTitle:) withObject:@"应收日报统计"];
    }else if (indexPath.row == 2){
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RiBaoDtlViewController"];
        [vc performSelector:@selector(setCallFunction:) withObject:(id)27];
        [vc performSelector:@selector(setNavTitle:) withObject:@"应付日报统计"];
    }else if (indexPath.row == 3){
//        NSArray *titles = @[@"商品明细汇总",@"商品分类汇总",@"客户汇总",@"业务员汇总"];
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZiJinRiBaoDtlViewController"];
        [vc performSelector:@selector(setCallFunction:) withObject:(id)30];
        [vc performSelector:@selector(setCallType:) withObject:(id)self.callBackType];
//        [vc performSelector:@selector(setNavTitle:) withObject:[titles objectAtIndex:self.callBackType]];
        // change   20150203
        [vc performSelector:@selector(setNavTitle:) withObject:@"销售日报统计"];

    }else if (indexPath.row == 4){
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZiJinRiBaoDtlViewController"];
        [vc performSelector:@selector(setCallFunction:) withObject:(id)33];
        [vc performSelector:@selector(setNavTitle:) withObject:@"采购金额汇总"];
    }else if (indexPath.row == 5){
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZiJinRiBaoDtlViewController"];
        [vc performSelector:@selector(setCallFunction:) withObject:(id)36];
        [vc performSelector:@selector(setNavTitle:) withObject:@"费用日报统计"];
    }else if (indexPath.row == 6){
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZiJinRiBaoDtlViewController"];
        [vc performSelector:@selector(setCallFunction:) withObject:(id)39];
        [vc performSelector:@selector(setNavTitle:) withObject:@"收入日报统计"];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self setRightButton:indexPath.row != 0 & indexPath.row != [self.viewControllers count]-1];
    NSDictionary *dic =  [self.leftArray objectAtIndex:indexPath.row];
    self.navigationItem.title =  [dic strForKey:@"Name"];
    
    [[self.subVcView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGRect rect = CGRectZero;
    rect.origin = CGPointMake(0, 0);
    rect.size = self.subVcView.frame.size;
    RCViewController *vc = (RCViewController *) [self.viewControllers objectAtIndex:indexPath.row];
    vc.parentVC  = self;
    vc.view.frame = rect;
    [self.subVcView addSubview:vc.view];
    [vc performSelector:@selector(loadData)];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.leftArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // fixBug       ghd         20150122
    if (indexPath.row == 0) {
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }

    UIImageView *imageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 44)] autorelease];
//    imageView.image =  [UIImage imageNamed:@"Cell_bg"];
    imageView.backgroundColor = [UIColor whiteColor];
    [cell setSelectedBackgroundView:imageView];
    
    [self setBackgroundView:@"navigationbar_background" forCell:cell];
 
    NSDictionary *dic =  [self.leftArray objectAtIndex:indexPath.row];
    
    [self setImage:[UIImage imageNamed:[dic strForKey:@"Image"]] forView:cell withTag:1];
    [self setText:[dic strForKey:@"Name"] forView:cell withTag:2];
    return cell;;
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
