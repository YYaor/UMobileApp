//
//  RCTableHeadSortView.h
//  PILOT
//
//  Created by  APPLE on 12/11/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NSDictionary_IngoreNull.h"

@protocol RCTableHeadSortViewDelegate <NSObject>

@optional
-(void)sortInIndex:(NSUInteger)index sortAsc:(BOOL)bAsc;
-(void)beforeSortButtonClick;

@end

@interface RCTableHeadSortView : UIView{
    NSDateFormatter *dateFormatter;
}

@property(nonatomic) BOOL bAsc;
@property(retain,nonatomic) NSArray *titles;
@property(retain,nonatomic) NSArray *widths;
@property(nonatomic) BOOL canBeSort;
@property(assign,nonatomic) id<RCTableHeadSortViewDelegate> delegate;
@property(retain,nonatomic) CALayer *sortLayer;

@property(assign,nonatomic) NSMutableArray *sortResult;
@property(retain,nonatomic) NSArray *sortKeys;
@property(retain,nonatomic) NSArray *types;

NSInteger sortDictionary(NSDictionary *dic1,NSDictionary *dic2, void *context);

-(CGRect)getFrameForHeader:(NSUInteger )index;
-(void)setCell:(UITableViewCell *)cell withInfo:(NSDictionary *)P;
-(void)setCell:(UITableViewCell *)cell withArray:(NSArray *)P;
-(void)setCell:(UITableViewCell *)cell;
-(void)setBackgroundImage:(NSString *)imageName;
BOOL beNumber(NSString *str);

@end
