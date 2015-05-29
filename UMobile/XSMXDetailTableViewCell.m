//
//  XSMXDetailTableViewCell.m
//  UMobile
//
//  Created by live on 15-5-5.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "XSMXDetailTableViewCell.h"

@interface XSMXDetailTableViewCell()
{
    UIFont *labelFont;
    UIColor *labelColor;
}

@property(nonatomic , retain) UIScrollView *rightScrollView;
@property(nonatomic , retain) UIView *scrollContentView;

@property(nonatomic , retain) UILabel *dateLabel;
@property(nonatomic , retain) UILabel *numberLabel;

@property(nonatomic , retain) UILabel *typeLabel;
@property(nonatomic , retain) UILabel *companyLabel;
@property(nonatomic , retain) UILabel *storeLabel;
@property(nonatomic , retain) UILabel *itemNameLabel;
@property(nonatomic , retain) UILabel *itemAmountLabel;
@property(nonatomic , retain) UILabel *largnessAmountLabel;
@property(nonatomic , retain) UILabel *moneyLabel;
@property(nonatomic , retain) UILabel *costMoneyLabel;
@property(nonatomic , retain) UILabel *profitLabel;

@end

@implementation XSMXDetailTableViewCell
@synthesize rightScrollView;
@synthesize scrollContentView;

@synthesize dateLabel;
@synthesize numberLabel;

@synthesize typeLabel;
@synthesize companyLabel;
@synthesize storeLabel;
@synthesize itemNameLabel;
@synthesize itemAmountLabel;
@synthesize largnessAmountLabel;
@synthesize moneyLabel;
@synthesize costMoneyLabel;
@synthesize profitLabel;

@synthesize delegate;

static const CGFloat labelWidth = 80;
static const CGFloat labelHorSpace = 10;
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self initVaribles];
        [self initViews];
    }
    return self;
}
-(void) initVaribles{
    labelColor = [UIColor blackColor];
    labelFont = [UIFont systemFontOfSize:14];
}
-(void) initViews{
    dateLabel = [[UILabel alloc] init];
    dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    dateLabel.font = labelFont;
    dateLabel.textColor = labelColor;
    dateLabel.numberOfLines = 0;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:dateLabel];
    [dateLabel release];
    
    numberLabel = [[UILabel alloc] init];
    numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    numberLabel.font = labelFont;
    numberLabel.textColor = labelColor;
    numberLabel.numberOfLines = 0;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:numberLabel];
    [numberLabel release];
    
    rightScrollView = [[UIScrollView alloc] init];
    rightScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    rightScrollView.contentSize = CGSizeMake(9*labelWidth+11*labelHorSpace, rightScrollView.contentSize.height);
    rightScrollView.bounces = NO;
    rightScrollView.delegate = self;
    rightScrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:rightScrollView];
    [rightScrollView release];
    
    scrollContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 9*labelWidth+11*labelHorSpace, 60)];
    //scrollContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [rightScrollView addSubview:scrollContentView];
    [scrollContentView release];
    
    //---vertical
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[dateLabel]-(0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(dateLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[numberLabel]-(0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(numberLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[rightScrollView]-(0)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(rightScrollView)]];
    //---horizonal
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[dateLabel(width)]-(horSpace)-[numberLabel(width)]-(0)-[rightScrollView]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:labelWidth],@"width",[NSNumber numberWithFloat:labelHorSpace],@"horSpace", nil] views:NSDictionaryOfVariableBindings(dateLabel,numberLabel,rightScrollView)]];
    //--------label in scroll
    typeLabel = [self initLabel];
    [scrollContentView addSubview:typeLabel];
    [typeLabel release];
    
    companyLabel = [self initLabel];
    [scrollContentView addSubview:companyLabel];
    [companyLabel release];
    
    storeLabel = [self initLabel];
    [scrollContentView addSubview:storeLabel];
    [storeLabel release];
    
    itemNameLabel = [self initLabel];
    [scrollContentView addSubview:itemNameLabel];
    [itemNameLabel release];
    
    itemAmountLabel = [self initLabel];
    [scrollContentView addSubview:itemAmountLabel];
    [itemAmountLabel release];
    
    largnessAmountLabel = [self initLabel];
    [scrollContentView addSubview:largnessAmountLabel];
    [largnessAmountLabel release];
    
    moneyLabel = [self initLabel];
    [scrollContentView addSubview:moneyLabel];
    [moneyLabel release];
    
    costMoneyLabel = [self initLabel];
    [scrollContentView addSubview:costMoneyLabel];
    [costMoneyLabel release];
    
    profitLabel = [self initLabel];
    [scrollContentView addSubview:profitLabel];
    [profitLabel release];
    
    //---constraints on scroll content view
    //----vertical;
    [scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[typeLabel]-(0)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(typeLabel)]];
    
    [scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[companyLabel]-(0)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(companyLabel)]];
    [scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[storeLabel]-(0)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(storeLabel)]];
    
    [scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[itemNameLabel]-(0)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(itemNameLabel)]];
    
    [scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[itemAmountLabel]-(0)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(itemAmountLabel)]];
    
    [scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[largnessAmountLabel]-(0)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(largnessAmountLabel)]];
    
    [scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[moneyLabel]-(0)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(moneyLabel)]];
    
    [scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[costMoneyLabel]-(0)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(costMoneyLabel)]];
    
    [scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[profitLabel]-(0)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(profitLabel)]];
    //--horizonal
    [scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(horSpace)-[typeLabel(width)]-(horSpace)-[companyLabel(width)]-(horSpace)-[storeLabel(width)]-(horSpace)-[itemNameLabel(width)]-(horSpace)-[itemAmountLabel(width)]-(horSpace)-[largnessAmountLabel(width)]-(horSpace)-[moneyLabel(width)]-(horSpace)-[costMoneyLabel(width)]-(horSpace)-[profitLabel(width)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:labelWidth],@"width",[NSNumber numberWithFloat:labelHorSpace],@"horSpace", nil] views:NSDictionaryOfVariableBindings(typeLabel,companyLabel,storeLabel,itemNameLabel,itemAmountLabel,largnessAmountLabel,moneyLabel,costMoneyLabel,profitLabel)]];
    
}
-(UILabel *) initLabel{
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.numberOfLines = 0;
    label.font = labelFont;
    label.textColor = labelColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
-(void) updateCellWithData:(XSMXDetailCellModel *)model contentOffset:(CGFloat)offsetX{
    dateLabel.text = model.dateString;
    numberLabel.text = model.numberString;
    
    typeLabel.text = model.typeString;
    companyLabel.text = model.companyString;
    storeLabel.text = model.storeString;
    itemNameLabel.text = model.itemNameString;
    itemAmountLabel.text = model.itemAmountString;
    largnessAmountLabel.text = model.largnessAmountString;
    moneyLabel.text= model.moneyString;
    costMoneyLabel.text = model.costMoneyString;
    profitLabel.text = model.profitMoneyString;
    
    rightScrollView.contentOffset = CGPointMake(offsetX, rightScrollView.contentOffset.y);
}
-(void)updateScrollOffsetX:(CGFloat)offsetX{
    rightScrollView.contentOffset = CGPointMake(offsetX, rightScrollView.contentOffset.y);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma scrollDelegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if (delegate &&[delegate respondsToSelector:@selector(contentOffsetXChange:)]){
        [delegate contentOffsetXChange:rightScrollView.contentOffset.x];
    }
}
-(void) dealloc{
    [rightScrollView release],rightScrollView = nil;
    [scrollContentView release],scrollContentView = nil;
    
     [dateLabel release] ,dateLabel = nil;
     [numberLabel release],numberLabel = nil;
    
     [typeLabel release],typeLabel = nil;
     [companyLabel release],companyLabel = nil;
     [storeLabel release],storeLabel = nil;
     [itemNameLabel release],itemNameLabel = nil;
     [itemAmountLabel release],itemAmountLabel = nil;
     [largnessAmountLabel release],largnessAmountLabel = nil;
     [moneyLabel release],moneyLabel = nil;
     [costMoneyLabel release],costMoneyLabel = nil;
     [profitLabel release],profitLabel = nil;
    
    [super dealloc];
}

@end
