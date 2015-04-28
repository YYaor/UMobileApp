//
//  RCTableView.m
//  UMobile
//
//  Created by  APPLE on 2014/9/17.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCTableView.h"

@implementation RCTableView

@synthesize result = _result;
@synthesize titleWidths = _titleWidths;
@synthesize titles,leftTitleView,contentTitleView,titleSC;
@synthesize headerColor,leftTitleColor ;
@synthesize bFooterRefreshing = _bFooterRefreshing,bHeaderRefreshing = _bHeaderRefreshing;
@synthesize leftIsOrder;
@synthesize totalColumns;
@synthesize bInit;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    self.fixColumn = 1;
    self.rowHeight = 30;
}

-(void)setBFooterRefreshing:(BOOL)bFooterRefreshing{
    _bFooterRefreshing = bFooterRefreshing;
}

-(void)setBHeaderRefreshing:(BOOL)bHeaderRefreshing{
    _bHeaderRefreshing = bHeaderRefreshing;
}

-(UITableView *)GetTableView{
    return (UITableView *)contentSC;
}

-(void)initContent{
    if (bInit) return;
    bInit = YES;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat leftTotal = 0;//左边长度，因固定列不同而改变
    leftWidth = 0;
    for (int i = 0 ; i < self.fixColumn ; i ++){
       leftWidth += [[self.titleWidths objectAtIndex:i] floatValue];
    }
    for (NSString *str in self.titleWidths){
        leftTotal += [str floatValue];
    }
    
    if (leftTotal < self.frame.size.width) leftTotal = self.frame.size.width;
    leftTotal -= leftWidth;

    self.headerColor = [UIColor colorWithRed:216.0/255 green:227.0/255 blue:247.0/255 alpha:1.0];
    self.leftTitleColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0];
    
    leftTableView =  [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, leftWidth, self.frame.size.height) style:UITableViewStylePlain] autorelease];
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    [self addSubview:leftTableView];
    

    
    self.leftTitleView =  [[[UIView alloc]initWithFrame:CGRectMake(0, 0, leftWidth, self.rowHeight)] autorelease];
    self.leftTitleView.backgroundColor = self.headerColor;
    [self setLabel:self.leftTitleView fromIndex:0 toIndex:self.fixColumn - 1];
    [self setTitle:self.leftTitleView fromIndex:0 toIndex:self.fixColumn - 1];

    
    contentSC =  [[[UIScrollView alloc]initWithFrame:CGRectMake(leftWidth, 0 , self.frame.size.width - leftWidth , self.frame.size.height)] autorelease];
    contentSC.contentSize = CGSizeMake(leftTotal , 1);
    contentSC.delegate = self;
    contentSC.backgroundColor =  [UIColor clearColor];
    contentSC.showsHorizontalScrollIndicator = NO;
    [self addSubview:contentSC];
    

    
    contentTableView =  [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, leftTotal , self.frame.size.height)] autorelease];

    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_bHeaderRefreshing) [self setHeaderRefresh];
    if (_bFooterRefreshing) [self setFooterRefresh];
    [contentSC addSubview:contentTableView];
    


    self.titleSC =  [[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0 , self.frame.size.width - leftWidth, self.rowHeight)] autorelease];
    self.titleSC.contentSize = CGSizeMake(leftTotal, 1);
    self.titleSC.delegate = self;
    self.titleSC.backgroundColor =  self.headerColor;
    [self setLabel:self.titleSC fromIndex:self.fixColumn toIndex:[self.titleWidths count] - 1];
    [self setTitle:self.titleSC fromIndex:self.fixColumn toIndex:[self.titleWidths count] - 1];

    

}

-(void)headerEndRefreshing{
    [contentTableView headerEndRefreshing];
}

-(void)footerEndRefreshing{
    dispatch_async(dispatch_get_main_queue(), ^{
        [contentTableView footerEndRefreshing];
    });
}

-(void)setHeaderRefresh{
    [self setHeaderRefresh:contentTableView];
}

-(void)setFooterRefresh{
    [self setFooterRefresh:contentTableView];
}

-(void)headerRereshing{
    [self.rDelegate tableHeaderRefreshing];
}

-(void)footerRereshing{
    [self.rDelegate tableFooterRefreshing];
}

-(void)setHeaderRefresh:(UITableView *)tableView{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tableView.headerPullToRefreshText = @"下拉刷新";
    tableView.headerReleaseToRefreshText = @"松开刷新";
    tableView.headerRefreshingText = @"数据加载中...";
}


-(void)setFooterRefresh:(UITableView *)tableView{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    tableView.footerPullToRefreshText = @"上拉加载";
    tableView.footerReleaseToRefreshText = @"松开加载";
    tableView.footerRefreshingText = @"数据加载中...";
}



-(void)setBackgroundView:(NSString *)imageName forCell:(UITableViewCell *)cell{
    UIImageView *imageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)] autorelease];
    imageView.image =  [UIImage imageNamed:imageName];
    [cell setBackgroundView:imageView];
}

-(void)setTitleWidths:(NSArray *)titleWidths{
    if (_titleWidths) [_titleWidths release];
    _titleWidths =  [titleWidths retain];
}

-(void)setResult:(NSArray *)result{
    
    if (_result ) [_result release];
    _result = [result retain];
    self.totalColumns = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        rowIndex = -1;
        if (self.bCountTotal){
            self.totalColumns = [NSMutableArray array];
            for (int i = 0 ; i < [self.countColumns count] ; i ++){
                [self.totalColumns addObject:@""];
            }
        }
        
        [leftTableView reloadData];
        [contentTableView reloadData];
    });

}

-(void)setLabelColor:(UIColor *)color inView:(UIView *)view fromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
    for (int i = from; i < to + 1;i++){
        UILabel *label = (UILabel *) [view viewWithTag:i];
        label.textColor = color;
    }
}

-(void)setLabel:(UIView *)view fromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
    CGFloat offset = 0 ;
    for (int i = from; i < to + 1;i++){
        
        CGFloat width = [[self.titleWidths objectAtIndex:i] floatValue];
        CGRect newRect = CGRectMake(offset, 0, width, self.rowHeight);
        UILabel *label = [[[UILabel alloc]initWithFrame:newRect] autorelease];
        label.tag = i + 1;
        
        label.font = [UIFont systemFontOfSize:11];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.1;
        [view addSubview:label];
        offset += width;
    }
}

-(void)setTitle:(UIView *)view fromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
    for (int i = from ; i < to + 1 ; i ++){
        UILabel *label = (UILabel *)[view viewWithTag:i + 1];
        label.text = [self.titles objectAtIndex:i];
    }

}

-(void)setTotalCell:(UITableViewCell *)cell withObject:(id)object fromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
  
    NSArray *objInfo = (NSArray *)object;
    for (NSUInteger i = from ; i < to + 1 ; i ++){
        UILabel *label = (UILabel *)[cell viewWithTag:i + 1];
        label.textColor =  [UIColor blueColor];
        if (self.bCountTotal && i < self.fixColumn){
            if (i == 0)
                label.text = @"合计";
            else
                label.text = @"";//清空固定列第一列以后的数据
        }else{
            if ([[objInfo objectAtIndex:i] length] > 0){
                label.text = [NSString stringWithFormat:@"%0.2f",[[objInfo ingoreObjectAtIndex:i] doubleValue]];
            }else{
                label.text = @"";
            }
        }
    }


}

-(NSString *)totalString:(NSString *)str{
    NSRange range = [str rangeOfString:@"."];
    if (range.location  == NSNotFound) {
        return str;
    }else{
        if (range.location + 3 > [str length]) {
            return str;
        }else{
            return [str substringToIndex:range.location + 3];
        }
    }
}

-(void)setCell:(UITableViewCell *)cell withObject:(id)object fromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray *objInfo = (NSArray *)object;
        for (NSUInteger i = from ; i < to + 1 ; i ++){
            UILabel *label = (UILabel *)[cell viewWithTag:i + 1];
            label.textColor =  [UIColor blackColor];
            if (self.leftIsOrder && i == 0){
                label.text = [objInfo objectAtIndex:0];
            }else{
                NSString *value = [objInfo ingoreObjectAtIndex:[[self.keys ingoreObjectAtIndex:i] integerValue]];
                if ([[self.countColumns objectAtIndex:i] integerValue] > 0){
                    label.text = [NSString stringWithFormat:@"%0.2f",[value doubleValue]];
                }else{
                    label.text = value;
                }
            }
        }
    }else{
        NSDictionary *objInfo = (NSDictionary *)object;
        for (NSUInteger i = from ; i < to + 1 ; i ++){
            UILabel *label = (UILabel *)[cell viewWithTag:i + 1];
            label.text = [objInfo strForKey:[self.keys objectAtIndex:i]];
        }
    }
}

-(NSString *)decimalNumberMutiplyWithString:(NSString *)multiplierValue with:(NSString *)multiplicandValue

{
    NSString *value1 = multiplierValue;
    NSString *value2 = multiplicandValue;
    if ([multiplierValue length] == 0) {
        value1 = @"0";
    }
    if ([multiplicandValue length] == 0) {
        value2 = @"0";
    }
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:value1];
    
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:value2];
    
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByAdding:multiplierNumber];
    
    return [product stringValue];
    
}

#pragma mark -
#pragma mark scroll view

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    titleSC.contentOffset = contentTableView.contentOffset;
    if (scrollView == leftTableView){
        contentTableView.contentOffset =  leftTableView.contentOffset;
    }else{
        leftTableView.contentOffset = contentTableView.contentOffset;
    }
//    if(contentSC.contentOffset.x <= 0) contentSC.contentOffset = CGPointMake(0, 0);
}

#pragma mark -
#pragma mark table view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == leftTableView) {
        return self.leftTitleView;
    }else{
        return self.titleSC;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [contentTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    if (self.bCountTotal) {
        //点击最后一行不触发事件
        if (indexPath.row == [self.result count]) {
            return;
        }
    }
    if (self.rDelegate) {
        if ([self.rDelegate respondsToSelector:@selector(tableViewClickAtIndex:withObject:)]) {
            [self.rDelegate tableViewClickAtIndex:indexPath.row withObject:[self.result objectAtIndex:indexPath.row]];
//            if (tableView == leftTableView)
//                [self.rDelegate leftTableClickAtIndex:indexPath.row withObject:[self.result objectAtIndex:indexPath.row]];
        }else{
            NSLog(@"%@",[self.rDelegate class]);
        }
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.result count] + [[NSNumber numberWithBool:self.bCountTotal] integerValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell =  [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
        if (tableView == leftTableView) {
            [self setBackgroundView:@"inventory_cell_blue" forCell:cell];
            [self setLabel:cell fromIndex:0 toIndex:self.fixColumn - 1];
        }else{
            [self setBackgroundView:@"inventory_cell_white" forCell:cell];
            [self setLabel:cell fromIndex:self.fixColumn toIndex:[self.titleWidths count] - 1];
        }
    }
    NSArray *obj  = nil;
    
    if (indexPath.row < [self.result count])
        obj =  [self.result objectAtIndex:indexPath.row];
    
    if (self.bCountTotal){
        if (indexPath.row > rowIndex) {
            //逐行计算每列总数
            rowIndex = indexPath.row;
            for(int i = self.fixColumn ; i < [self.countColumns count]  ; i ++){
                //计算列，大于 0 的列要计算总数
                if ([[self.countColumns objectAtIndex:i] floatValue] > 0) {
                    NSString *total = [self decimalNumberMutiplyWithString:[self.totalColumns objectAtIndex:i]
                                                                      with:[obj objectAtIndex:[[self.keys objectAtIndex:i] integerValue]]];
                    [self.totalColumns replaceObjectAtIndex:i withObject:total];
                }
            }
        }
        if (indexPath.row == [self.result count]){
            //最后一行合计
            if (tableView == contentTableView) {
                [self setTotalCell:cell withObject:self.totalColumns fromIndex:self.fixColumn toIndex:[self.titleWidths count] - 1];
            }else{
                //显示合计字样
                [self setTotalCell:cell withObject:nil fromIndex:0 toIndex:self.fixColumn - 1];
            }
            return cell;
        }
    }
    if (tableView == leftTableView) {
        if (self.leftIsOrder)
            [self setCell:cell withObject:[NSArray arrayWithObject:[NSString stringWithFormat:@"%d",indexPath.row + 1]] fromIndex:0 toIndex:0];
        else
            [self setCell:cell withObject:obj fromIndex:0 toIndex:self.fixColumn - 1];
    }else{
        [self setCell:cell withObject:obj fromIndex:self.fixColumn toIndex:[self.titleWidths count] - 1];
    }
    return cell;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!self.bFooterRefreshing) {
        [contentTableView removeFooter];
    }
}

-(void)dealloc{
    self.countColumns = nil;
    self.totalColumns = nil;
    self.headerColor = nil;
    self.leftTitleColor = nil;
    self.leftTitleView = nil;
    self.contentTitleView = nil;
    self.keys = nil;
    self.titleWidths = nil;
//    self.result = nil;
    [self.result release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
