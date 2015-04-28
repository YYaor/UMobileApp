//
//  RCTableHeadSortView.m
//  PILOT
//
//  Created by  APPLE on 12/11/13.
//
//

#import "RCTableHeadSortView.h"

@implementation RCTableHeadSortView
@synthesize titles,widths,delegate;
@synthesize canBeSort = _canBeSort;
@synthesize sortLayer;
@synthesize bAsc;
@synthesize sortResult,sortKeys;
@synthesize types;
#define offset 10
#define buttonOffset 99
#define labelOffset 999

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor colorWithRed:0.89 green:0.9 blue:0.92 alpha:1];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"inventory_title"]];
        dateFormatter = [[NSDateFormatter alloc]init];
//        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}


-(void)dealloc{
    [dateFormatter release];
    self.titles = nil;
    self.widths = nil;
    self.sortLayer = nil;
    self.sortKeys = nil;
    self.types = nil;
    [super dealloc];
}

-(void)setBackgroundImage:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    self.backgroundColor =  [UIColor colorWithPatternImage:image];
}

-(void)setCanBeSort:(BOOL)canBeSort{
    _canBeSort = canBeSort;
    if (_canBeSort) {
        self.sortLayer = [CALayer layer];
        self.sortLayer.contents = (id)[UIImage imageNamed:@"sort.png"].CGImage;
    }else{
        self.sortLayer = nil;
    }

    
}

BOOL beNumber(NSString *str){
    BOOL B;
    int _i;
    float _f;
    NSScanner *scanner = [NSScanner scannerWithString:str];
    B = [scanner scanInt:&_i] && [scanner isAtEnd];
    if (B)
        return B;
    else
        B = [scanner scanFloat:&_f] && [scanner isAtEnd];
    return B;
}

NSInteger sortDictionary(NSDictionary *dic1,NSDictionary *dic2, void *context){
    NSDictionary *dic = (NSDictionary *)context;
    NSString *key = [dic objectForKey:@"KEY"];
    BOOL bAsc = [[dic objectForKey:@"ASC"] boolValue];
    

    NSString *str1 = [NSString stringWithFormat:@"%@",[dic1 objectForKey:key]];
    NSString *str2 = [NSString stringWithFormat:@"%@",[dic2 objectForKey:key]];
    

    if (beNumber(str1) && beNumber(str2)) {
        NSNumber *number1 = [NSNumber numberWithLongLong:[str1 longLongValue]];
        NSNumber *number2 = [NSNumber numberWithLongLong:[str2 longLongValue]];
        if (bAsc)
            return [number1 compare:number2];
        else
            return [number2 compare:number1];
    }else {
        if (bAsc)
            return [str1 compare:str2];
        else
            return [str2 compare:str1];
    }
}



-(void)sortClick:(UIButton *)sender{
    bAsc = !bAsc;

    if (_canBeSort) {
        if([delegate respondsToSelector:@selector(beforeSortButtonClick)]) [delegate beforeSortButtonClick];
        if ([delegate respondsToSelector:@selector(sortInIndex:sortAsc:)]) {
            if(self.layer != nil){
                CGRect rect = [[self viewWithTag:sender.tag - buttonOffset + 1] frame];
                [self.sortLayer setFrame:CGRectMake(rect.size.width + 1, (rect.size.height - 15.0)/2 , 15, 15)];
                
                [self.sortLayer removeAnimationForKey:@"position"];
                [sender.layer addSublayer:self.sortLayer];
                
                if (bAsc)
                    [self.sortLayer setAffineTransform:CGAffineTransformMakeRotation(M_PI)];
                else
                    [self.sortLayer setAffineTransform:CGAffineTransformMakeRotation(M_PI * 2)];
            }
        
            NSString *key = [sortKeys objectAtIndex:sender.tag - buttonOffset];
            NSNumber *numAsc = [NSNumber numberWithBool:bAsc];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:key,@"KEY",numAsc,@"ASC", nil];
            [self.sortResult sortUsingFunction:sortDictionary context:dic];
            
            
            [delegate sortInIndex:sender.tag - buttonOffset sortAsc:bAsc];
        }
    }
    
}


-(CGRect)getFrameForHeader:(NSUInteger)index{
    UIButton *button = (UIButton *) [self viewWithTag:index + buttonOffset];
    return button.frame;
}

-(void)layoutSubviews{
    CGFloat fx = offset;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat flactor = self.frame.size.width /[[widths lastObject] floatValue];
    for (int i = 0; i<[titles count]; i++) {
        NSString *title = [titles objectAtIndex:i];
        CGFloat width =[[widths objectAtIndex:i] floatValue] * flactor ;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setBackgroundColor:[UIColor greenColor]];
        [button addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(fx, 0, width , self.frame.size.height);
//        button.backgroundColor = [UIColor colorWithRed:0.89 green:0.9 blue:0.92 alpha:1];
        button.tag = i + buttonOffset;
        
        UILabel *label =  [[[UILabel alloc] initWithFrame:button.frame] autorelease];
       
        [label setText:title];
        [label setFont:[UIFont systemFontOfSize:11]];
        label.tag = i + labelOffset;
        CGSize size = [label.text sizeWithFont:label.font];
        [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width, label.frame.size.height)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [self addSubview:button];
        [self addSubview:label];
        fx = fx + width + 5;
    }
}

-(void)setCell:(UITableViewCell *)cell{
    for (int i = 0;i<[self.titles count];i++){
  
        CGRect rect = [self getFrameForHeader:i];
        CGRect newRect = CGRectMake(rect.origin.x, 0, rect.size.width, cell.frame.size.height);
        
        UILabel *label = [[UILabel alloc]initWithFrame:newRect];
        label.font = [UIFont systemFontOfSize:11];
        label.backgroundColor = [UIColor clearColor];
        label.tag = i + 1;
        [cell addSubview:label];

    }
}

-(void)setCell:(UITableViewCell *)cell withArray:(NSArray *)P{
    for (int i = 0;i<[self.titles count];i++){
        UIView *view = [cell viewWithTag:i+1];
        NSDate *date = nil;
        if (view) {
            if ([view respondsToSelector:@selector(setText:)]) {
                //                CGRect rect = [self getFrameForHeader:i];
                //                CGRect newRect = CGRectMake(rect.origin.x, view.frame.origin.y, rect.size.width, view.frame.size.height);
                
                //
                //                dispatch_async(dispatch_get_main_queue(), ^{
                //                    view.frame = newRect;
                //                });
                
                
                NSString *value = [P objectAtIndex:[[self.sortKeys objectAtIndex:i] integerValue]];
                
                if (self.types != nil) {
                    switch ([[self.types objectAtIndex:i] intValue]) {
                        case 1:
                            value = [NSString stringWithFormat:@"%d", [value intValue]];
                            break;
                        case 2:
                            value = [NSString stringWithFormat:@"%0.2f", [value floatValue]];
                            break;
                        case 3:
                            [dateFormatter setDateFormat:@"YYYY-MM-DD hh:mm:ss"];
                            date = [dateFormatter dateFromString:value];
                            [dateFormatter setDateFormat:@"YYYY-MM-DD"];
                            value = [dateFormatter stringFromDate:date];
                            break;
                    }
                }
                
                [view performSelector:@selector(setText:) withObject:value];
            }
        }
    }
}


-(void)setCell:(UITableViewCell *)cell withInfo:(NSDictionary *)P{
    for (int i = 0;i<[self.titles count];i++){
        UIView *view = [cell viewWithTag:i+1];
        NSDate *date = nil;
        if (view) {
            if ([view respondsToSelector:@selector(setText:)]) {
//                CGRect rect = [self getFrameForHeader:i];
//                CGRect newRect = CGRectMake(rect.origin.x, view.frame.origin.y, rect.size.width, view.frame.size.height);

//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    view.frame = newRect;
//                });


                NSString *value = [P strForKey:[self.sortKeys objectAtIndex:i]];
                
                if (self.types != nil) {
                    switch ([[self.types objectAtIndex:i] intValue]) {
                        case 1:
                            value = [NSString stringWithFormat:@"%d", [value intValue]];
                            break;
                        case 2:
                            value = [NSString stringWithFormat:@"%0.2f", [value floatValue]];
                            break;
                        case 3:
                            [dateFormatter setDateFormat:@"YYYY-MM-DD hh:mm:ss"];
                            date = [dateFormatter dateFromString:value];
                            [dateFormatter setDateFormat:@"YYYY-MM-DD"];
                            value = [dateFormatter stringFromDate:date];
                            break;
                    }
                }
            
                [view performSelector:@selector(setText:) withObject:value];
            }
        }
    }
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
