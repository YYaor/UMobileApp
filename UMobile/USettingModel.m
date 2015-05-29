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
        if(model.JSRId == 0){
            model.JSRId = -1;
        }
        model.JSRName = [[dic objectForKey:@"salesInfo"] objectForKey:@"salesName"];
        
        model.BMId = [[[dic objectForKey:@"departInfo"] objectForKey:@"departId"] integerValue];
        if(model.BMId == 0){
            model.BMId = -1;
        }
        model.BMName = [[dic objectForKey:@"departInfo"] objectForKey:@"departName"];
        
        model.KHId = [[[dic objectForKey:@"clientInfo"] objectForKey:@"clientId"] integerValue];
        if(model.KHId == 0){
            model.KHId = -1;
        }
        model.KHName = [[dic objectForKey:@"clientInfo"] objectForKey:@"clientName"];
        
        model.GRSId = [[[dic objectForKey:@"supplierInfo"] objectForKey:@"supplierId"] integerValue];
        if(model.GRSId == 0){
            model.GRSId = -1;
        }
        model.GRSName  = [[dic objectForKey:@"supplierInfo"] objectForKey:@"supplierName"];
        
        model.FHCKId =[[[dic objectForKey:@"FHCKInfo"] objectForKey:@"ckId"] integerValue];
        if(model.FHCKId == 0){
            model.FHCKId = -1;
        }
        model.FHCKName = [[dic objectForKey:@"FHCKInfo"] objectForKey:@"ckName"];
        
        model.DHCKId = [[[dic objectForKey:@"DHCKInfo"] objectForKey:@"ckId"] integerValue];
        if(model.DHCKId == 0){
            model.DHCKId = -1;
        }
        model.DHCKName = [[dic objectForKey:@"DHCKInfo"] objectForKey:@"ckName"];
        
        model.FKZHId = [[[dic objectForKey:@"FKaccountInfo"] objectForKey:@"accountId"] integerValue];
        if(model.FKZHId == 0){
            model.FKZHId = -1;
        }
        model.FKZHName = [[dic objectForKey:@"FKaccountInfo"] objectForKey:@"accountName"];
        
        model.SKZHId = [[[dic objectForKey:@"SKaccountInfo"] objectForKey:@"accountId"] integerValue];
        if(model.SKZHId == 0){
            model.SKZHId = -1;
        }
        model.SKZHName = [[dic objectForKey:@"SKaccountInfo"] objectForKey:@"accountName"];
    }
    
    return model;
}
@end
