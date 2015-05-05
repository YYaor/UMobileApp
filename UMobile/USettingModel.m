//
//  USettingModel.m
//  UMobile
//
//  Created by yunyao on 15/5/5.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "USettingModel.h"

@implementation USettingModel
+(USettingModel*)getSetting{
    USettingModel *model = [[[USettingModel alloc] init] autorelease];
    NSDictionary *dic = [[[NSMutableDictionary alloc] initWithDictionary:[USER_DEFAULT objectForKey:@"Setting"]] objectForKey:@"SetDefaultParam"];
    if (dic){
        model.JSRId = [[[dic objectForKey:@"salesInfo"] objectForKey:@"salesId"] integerValue];
        model.JSRName = [[dic objectForKey:@"salesInfo"] objectForKey:@"salesName"];
        
        model.BMId = [[[dic objectForKey:@"departInfo"] objectForKey:@"departId"] integerValue];
        model.BMName = [[dic objectForKey:@"departInfo"] objectForKey:@"departName"];
        
        model.KHId = [[[dic objectForKey:@"clientInfo"] objectForKey:@"clientId"] integerValue];
        model.KHName = [[dic objectForKey:@"clientInfo"] objectForKey:@"clientName"];
        
        model.GRSId = [[[dic objectForKey:@"supplierInfo"] objectForKey:@"supplierId"] integerValue];
        model.GRSName  = [[dic objectForKey:@"supplierInfo"] objectForKey:@"supplierName"];
        
        model.FHCKId =[[[dic objectForKey:@"FHCKInfo"] objectForKey:@"ckId"] integerValue];
        model.FHCKName = [[dic objectForKey:@"FHCKInfo"] objectForKey:@"ckName"];
        
        model.DHCKId = [[[dic objectForKey:@"DHCKInfo"] objectForKey:@"ckId"] integerValue];
        model.DHCKName = [[dic objectForKey:@"DHCKInfo"] objectForKey:@"ckName"];
        
        model.FKZHId = [[[dic objectForKey:@"FKaccountInfo"] objectForKey:@"accountId"] integerValue];
        model.FKZHName = [[dic objectForKey:@"FKaccountInfo"] objectForKey:@"accountName"];
        
        model.SKZHId = [[[dic objectForKey:@"SKaccountInfo"] objectForKey:@"accountId"] integerValue];
        model.SKZHName = [[dic objectForKey:@"SKaccountInfo"] objectForKey:@"accountName"];
    }
    
    return model;
}
@end
