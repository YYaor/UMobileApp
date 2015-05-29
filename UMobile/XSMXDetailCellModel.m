//
//  XSMXDetailCellModel.m
//  UMobile
//
//  Created by live on 15-5-5.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "XSMXDetailCellModel.h"

@implementation XSMXDetailCellModel
+(XSMXDetailCellModel *)parseDataFromArray:(NSArray *)dataArray{
    XSMXDetailCellModel *model = [[[XSMXDetailCellModel alloc] init] autorelease];
    model.dateString = [dataArray objectAtIndex:4];
    model.numberString = [dataArray objectAtIndex:5];
    
    model.typeString = [dataArray objectAtIndex:6];
    model.companyString = [dataArray objectAtIndex:7];
    model.storeString = [dataArray objectAtIndex:8];
    model.itemNameString = [dataArray objectAtIndex:9];
    model.itemAmountString = [dataArray objectAtIndex:10];
    model.largnessAmountString = [dataArray objectAtIndex:11];
    model.moneyString = [dataArray objectAtIndex:12];
    model.costMoneyString = [dataArray objectAtIndex:13];
    model.profitMoneyString = [dataArray objectAtIndex:14];
    //--testData
//    model.dateString = @"2015-05-04";
//    model.numberString = @"KL12345678900000";
//    
//    model.typeString = @"销售定单";
//    model.companyString = @"二货公司";
//    model.storeString = @"30.00";
//    model.itemNameString = @"哪个傻比做的";
//    model.itemAmountString = @"10.00";
//    model.largnessAmountString = @"1.00";
//    model.moneyString = @"8000.00";
//    model.costMoneyString = @"6000.00";
//    model.profitMoneyString = @"2000.00";
    return model;

}
@end
