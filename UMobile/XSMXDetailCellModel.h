//
//  XSMXDetailCellModel.h
//  UMobile
//
//  Created by live on 15-5-5.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSMXDetailCellModel : NSObject

@property(nonatomic , retain) NSString *dateString;
@property(nonatomic , retain) NSString *numberString;

@property(nonatomic , retain) NSString *typeString;
@property(nonatomic , retain) NSString *companyString;
@property(nonatomic , retain) NSString *storeString;
@property(nonatomic , retain) NSString *itemNameString;
@property(nonatomic , retain) NSString *itemAmountString;
@property(nonatomic , retain) NSString *largnessAmountString;
@property(nonatomic , retain) NSString *moneyString;
@property(nonatomic , retain) NSString *costMoneyString;
@property(nonatomic , retain) NSString *profitMoneyString;

+(XSMXDetailCellModel *) parseDataFromArray:(NSArray *)dataArray;

@end
