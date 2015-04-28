//
//  LeftView.m
//  UMobile
//
//  Created by  APPLE on 2014/10/14.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "LeftView.h"


@implementation UIView(Moving)

-(void)moveToLeft:(NSNumber *)num{
    self.frame  = CGRectMake(self.frame.origin.x - [num floatValue], self.frame.origin.y, self.frame.size.width, self.frame.size.height)  ;
}

-(void)moveToRight:(NSNumber *)num{
    self.frame  = CGRectMake(self.frame.origin.x + [num floatValue], self.frame.origin.y, self.frame.size.width, self.frame.size.height)  ;
}

@end

@implementation LeftView
@synthesize mainView = _mainView,dataSource = _dataSource,delegate;
@synthesize link;
@synthesize tbView;
@synthesize selectID;
@synthesize width;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init{
    if (self =  [super init]){
        tbView =  [[[UITableView alloc]initWithFrame:CGRectMake(-150, 0, 150, self.frame.size.height)] autorelease];
        tbView.delegate  = self;
        tbView.dataSource = self;
        tbView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbView.backgroundColor = [UIColor lightGrayColor];
//        tbView.layer.shadowColor = [UIColor blackColor].CGColor;
//        tbView.layer.shadowOffset = CGSizeMake(10, 10);
//        tbView.layer.shadowOpacity = 10.0;
        
        [tbView addHeaderWithTarget:self action:@selector(headerRereshing)];
        // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
        tbView.headerPullToRefreshText = @"下拉刷新";
        tbView.headerReleaseToRefreshText = @"松开刷新";
        tbView.headerRefreshingText = @"数据加载中...";
        
        width = 150;
        self.hidden = YES;
        self.selectIndex = 0;
        self.selectID = @"0";
        [self addSubview:tbView];

    }
    return self;
}

-(void)headerRereshing{
    __block ASIHTTPRequest * request =  [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:self.link]] autorelease];
    
    __block LeftView *tempSelf = self;
    [request setResponeBlock:^(NSString *responeString) {
        NSString *newStr = [[responeString stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        [tempSelf.tbView headerEndRefreshing];
        NSMutableArray *arr = [NSMutableArray arrayWithObject:@[@"0",@"全部"]];
        NSArray *rs = [[newStr objectFromJSONString] objectForKey:@"D_Data"];
        [arr addObjectsFromArray:rs];
        tempSelf.dataSource = arr;
        [tempSelf.tbView reloadData];
    }];
    
    [request setFailedBlock:^{
        [tempSelf.tbView headerEndRefreshing];
    }];
    
    [request startAsynchronous];
}

#pragma mark -

-(void)setMainView:(UIView *)mainView{
    _mainView = mainView;
    self.frame = CGRectMake(0 - width, 0, mainView.frame.size.width, mainView.frame.size.height);
    tbView.frame = CGRectMake(0, 0, width, mainView.frame.size.height);
    tbView.hidden = NO;
    UISwipeGestureRecognizer *recognizer = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)] autorelease];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [mainView addGestureRecognizer:recognizer];
    [mainView addSubview:self];
//    [[mainView superview] sendSubviewToBack:self];
}

-(void)swipe:(id)info{
    [self layoutLeftView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self layoutLeftView];
}

-(void)setDataSource:(NSArray *)dataSource{
    if (_dataSource) [_dataSource release];
    _dataSource = [dataSource retain];
    [tbView reloadData];
}

-(void)layoutLeftView{
    BOOL b = !self.hidden;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    
    if (!b){
        if (!self.dataSource) [self.tbView headerBeginRefreshing];
        self.hidden = NO;
        [[self.mainView subviews] makeObjectsPerformSelector:@selector(moveToRight:) withObject:[NSNumber numberWithFloat:width]];
        tbView.hidden = NO;
    }else{
        [[self.mainView subviews] makeObjectsPerformSelector:@selector(moveToLeft:) withObject:[NSNumber numberWithFloat:width]];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(setViewHidden)];
    }
    
    [UIView commitAnimations];
}

-(void)setViewHidden{
    self.hidden = YES;
}



#pragma mark -
#pragma mark tableView Delegate

-(UIView *)GetImageViewWithName:(NSString *)strName{
    UIImageView *imageView =  [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 44)] autorelease];
    imageView.image = [UIImage imageNamed:strName];
    return imageView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *info = [self.dataSource objectAtIndex:indexPath.row];
    self.selectIndex = indexPath.row;
    self.selectID = [info objectAtIndex:0];
    if (self.delegate){
        if ([self.delegate respondsToSelector:@selector(leftViewClickAtIndex:)])
            [self.delegate leftViewClickAtIndex:indexPath.row];
        if ([self.delegate respondsToSelector:@selector(leftViewClickWithInfo:)])
            [self.delegate leftViewClickWithInfo:info];
    }
    [self layoutLeftView];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tbView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
        [cell setBackgroundView:[self GetImageViewWithName:@"IMG_0615"]];
        [cell setSelectedBackgroundView:[self GetImageViewWithName:@"IMG_0616"]];

        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    NSArray *info = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [info objectAtIndex:1];// [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

-(void)dealloc{
    self.link = nil;
    self.mainView = nil;
    self.dataSource = nil;
    [super dealloc];
}

@end
