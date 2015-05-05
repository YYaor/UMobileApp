//
//  AccountViewController.m
//  UMobile
//
//  Created by Rid on 15/1/14.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

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
        self.link = [self GetLinkWithFunction:62 andParam:[NSString stringWithFormat:@"'',0,0,1,%@",[self GetUserID]]];//  [NSString stringWithFormat:@"%@?UID=119&Call=62&Param='',1",MainUrl];
    
    __block AccountViewController *tempSelf = self;
    [self StartQuery:self.link completeBlock:^(id obj) {
        tempSelf.result =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
        [tempSelf.tableView reloadData];
        [tempSelf.tableView headerEndRefreshing];
        
    } lock:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
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
    [self setText:[rs objectAtIndex:0] forView:cell withTag:1];
    [self setText:[rs objectAtIndex:1] forView:cell withTag:2];
    [self setText:[rs objectAtIndex:2] forView:cell withTag:3];
    [self setText:[rs objectAtIndex:3] forView:cell withTag:4];
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *rs =  [self.result objectAtIndex:indexPath.row];
    [self.info removeAllObjects];
    NSUInteger sIndex = self.showIndex > 0?self.showIndex:1;
    [self.info addObjectsFromArray:@[[rs objectAtIndex:0],[rs objectAtIndex:sIndex],[rs ingoreObjectAtIndex:4]]];
    [self.parentVC performSelector:@selector(loadData) withObject:nil];
    if (chooseType == ChooseAccountType_CKAccount){
        if (delegate && [delegate respondsToSelector:@selector(CKaccountChoosedId:accountName:)]){
            [delegate CKaccountChoosedId:[[rs objectAtIndex:0] integerValue] accountName:[rs objectAtIndex:2]];
        }
    }else if (chooseType == ChooseAccountType_FKAccount){
        if (delegate && [delegate respondsToSelector:@selector(FKaccountChoosedId:accountName:)]){
            [delegate FKaccountChoosedId:[[rs objectAtIndex:0] integerValue] accountName:[rs objectAtIndex:2]];
        }
    }
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
