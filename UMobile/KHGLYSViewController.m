//
//  KHGLYSViewController.m
//  UMobile
//
//  Created by Rid on 14/12/8.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "KHGLYSViewController.h"

@implementation KHGLYSViewController

@synthesize strCode;


-(void)viewDidLoad{
    
    [super viewDidLoad];
    NSString *param =  [NSString stringWithFormat:@"%@,%@",strCode,[self GetUserID]];
    NSString *link = [self GetLinkWithFunction:11 andParam:param];
    
    __block KHGLYSViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
        for (int i = 1 ; i < 7 ; i ++){
            NSArray *rs = [[obj objectFromJSONString] objectForKey:@"D_Data"];
            if ([rs count] > 0){
                NSArray *info = [rs objectAtIndex:0];
                [tempSelf setText:[NSString numberFromString:[info objectAtIndex:i]] forView:tempSelf.view withTag:i];
            }
            
        }
        
    } lock:NO];
}

-(void)dealloc{
    self.strCode = nil;
    [super dealloc];
}

@end
