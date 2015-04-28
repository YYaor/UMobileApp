//
//  ZhiBiaoKanBanViewController.m
//  UMobile
//
//  Created by  APPLE on 2014/9/20.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "ZhiBiaoKanBanViewController.h"

@interface ZhiBiaoKanBanViewController ()

@end

@implementation ZhiBiaoKanBanViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

-(void)loadData{
    // change
    NSString *param = [NSString stringWithFormat:@"%d,'%@'", [[self GetUserID] intValue], [self GetCurrentDate]];
    NSString *link = [self GetLinkWithFunction:41 andParam:param];// [NSString stringWithFormat:@"%@?UID=119&Call=41&Param=1",MainUrl];
    
    __block ZhiBiaoKanBanViewController *tempSelf = self;
    
    [self StartQuery:link completeBlock:^(id obj) {
        tempSelf.result = [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [tempSelf setContext];
    } lock:NO];
}

-(void)setContext{
    
    NSArray *rs = nil;
    UIView *view =  nil;
    double ratio = [self.setting intForKey:@"ISBS"] == 1?100:1;
    
    view = [self.view viewWithTag:101];
    
    rs = [self.result objectAtIndex:0];
    [self setText:[rs objectAtIndex:0] forView:view withTag:1];
    [self setText:[rs objectAtIndex:1] forView:view withTag:2];
    
    rs = [self.result objectAtIndex:1];
    [self setText:[rs objectAtIndex:0] forView:view withTag:3];
    [self setText:[NSString stringWithFormat:@"%0.2f%%",[[rs objectAtIndex:1] doubleValue] * ratio] forView:view withTag:4];
    
    // ..
    view = [self.view viewWithTag:102];
    
    rs = [self.result objectAtIndex:2];
    [self setText:[rs objectAtIndex:0] forView:view withTag:1];
    [self setText:[rs objectAtIndex:1] forView:view withTag:2];
    
    rs = [self.result objectAtIndex:3];
    [self setText:[rs objectAtIndex:0] forView:view withTag:3];
    [self setText:[NSString stringWithFormat:@"%0.2f%%",[[rs objectAtIndex:1] doubleValue] * ratio] forView:view withTag:4];
    
    // ..
    view = [self.view viewWithTag:103];
    
    rs = [self.result objectAtIndex:4];
    [self setText:[rs objectAtIndex:0] forView:view withTag:1];
    [self setText:[rs objectAtIndex:1] forView:view withTag:2];
    
    rs = [self.result objectAtIndex:5];
    [self setText:[rs objectAtIndex:0] forView:view withTag:3];
    [self setText:[NSString stringWithFormat:@"%0.2f%%",[[rs objectAtIndex:1] doubleValue] * ratio] forView:view withTag:4];
    
    // ..
    view = [self.view viewWithTag:104];
    
    rs = [self.result objectAtIndex:6];
    [self setText:[rs objectAtIndex:0] forView:view withTag:1];
    [self setText:[NSString stringWithFormat:@"%0.2f%%",[[rs objectAtIndex:1] doubleValue] * ratio] forView:view withTag:2];
    
    rs = [self.result objectAtIndex:7];
    [self setText:[rs objectAtIndex:0] forView:view withTag:3];
    [self setText:[NSString stringWithFormat:@"%0.2f%%",[[rs objectAtIndex:1] doubleValue] * ratio] forView:view withTag:4];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.result = nil;
    [super dealloc];
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
