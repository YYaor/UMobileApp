//
//  SetDefaultConfigViewController.m
//  UMobile
//
//  Created by live on 15-5-4.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "SetDefaultConfigViewController.h"
#import "SaleViewController.h"
#import "DepartmentViewController.h"
#import "KHGLViewController.h"
#import "CangKuViewController.h"
#import "AccountViewController.h"
#import "USettingModel.h"

@interface SetDefaultConfigViewController ()<saleViewControllerDelegate,departmentViewControllerDelegate,KHGLViewControllerDelegate,cangkuControllerDelegate,accountViewControllerDelegate>

@end

@implementation SetDefaultConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self adjustInterface];
    [self setDefaultValueForTextField];
}
-(void) adjustInterface{
    self.backView.layer.cornerRadius = 4;
    self.CZButton.layer.cornerRadius = 1.5;
}
- (IBAction)back:(UIBarButtonItem *)sender {
    USettingModel *model = [USettingModel getSetting];
//    NSString *param = @"-1,-1,-1,-1,-1,-1,-1,-1,-1";
    NSString *param =  [NSString stringWithFormat:@"%d,%d,%d,%d,%d,%d,%d,%d,%d,",
                                                    model.JSRId,
                                                    model.BMId,
                                                    model.KHId,
                                                    model.GRSId,
                                                    model.FHCKId,
                                                    model.DHCKId,
                                                    model.FKZHId,
                                                    model.SKZHId,
                                                    [[self GetUserID] intValue]];
     NSString *link = [self GetLinkWithFunction:99 andParam:param];
    __block SetDefaultConfigViewController *tempSelf = self;
    [self StartQuery:link completeBlock:^(id obj) {
       [tempSelf.navigationController popViewControllerAnimated:YES];
    } lock:NO];
    
}
- (IBAction)CZButtonClicked:(UIButton *)sender {
    [self.setting removeObjectForKey:@"SetDefaultParam"];
    [self setDefaultValueForTextField];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) setDefaultValueForTextField{
    if ([[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"salesInfo"]){
        NSDictionary *dic = [[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"salesInfo"];
        self.JSRField.text = [dic objectForKey:@"salesName"];
    }else{
        self.JSRField.text = @"";
    }
    //-----depart info
    if ([[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"departInfo"]){
        NSDictionary *dic = [[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"departInfo"];
        self.BMField.text = [dic objectForKey:@"departName"];
    }else{
        self.BMField.text = @"";
    }
    //---client info
    if ([[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"clientInfo"]){
        NSDictionary *dic = [[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"clientInfo"];
        self.KHField.text = [dic objectForKey:@"clientName"];
    }else{
        self.KHField.text = @"";
    }

    //---supplier info
    if ([[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"supplierInfo"]){
        NSDictionary *dic = [[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"supplierInfo"];
        self.GYSField.text = [dic objectForKey:@"supplierName"];
    }else{
        self.GYSField.text = @"";
    }
    //--FHCK info
    if ([[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"FHCKInfo"]){
        NSDictionary *dic = [[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"FHCKInfo"];
        self.FHCKField.text = [dic objectForKey:@"ckName"];
    }else{
        self.FHCKField.text = @"";
    }

    //--DHCK info
    if ([[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"DHCKInfo"]){
        NSDictionary *dic = [[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"DHCKInfo"];
        self.DHCKField.text = [dic objectForKey:@"ckName"];
    }else{
        self.DHCKField.text = @"";
    }
    //--fk account info
    if ([[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"FKaccountInfo"]){
        NSDictionary *dic = [[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"FKaccountInfo"];
        self.FKZHField.text = [dic objectForKey:@"accountName"];
    }else{
        self.FKZHField.text = @"";
    }
    //--ck account info
    if ([[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"SKaccountInfo"]){
        NSDictionary *dic = [[self.setting objectForKey:@"SetDefaultParam"] objectForKey:@"SKaccountInfo"];
        self.SKZHField.text = [dic objectForKey:@"accountName"];
    }else{
        self.SKZHField.text = @"";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark UITextField Delegate
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (textField == self.JSRField){
        SaleViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"SaleViewController"];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (textField == self.BMField){
        //---choose department
        DepartmentViewController *department = [storyBoard instantiateViewControllerWithIdentifier:@"DepartmentViewController"];
        department.delegate = self;
        [self.navigationController pushViewController:department animated:YES];
    }else if (textField == self.KHField || textField == self.GYSField){
        //－－choose client or supplier
        KHGLViewController *khgl = [storyBoard instantiateViewControllerWithIdentifier:@"KHGLViewController"];
        khgl.bSelect = YES;
        khgl.delegate = self;
        if (textField == self.KHField){
            khgl.type = KHGLType_ChooseClient;
        }else{
            khgl.type = KHGLType_ChooseSupplier;
        }
        [self.navigationController pushViewController:khgl animated:YES];
    }else if(textField == self.FHCKField || textField == self.DHCKField){
        CangKuViewController *cangKu = [storyBoard instantiateViewControllerWithIdentifier:@"CangKuViewController"];
        cangKu.delegate = self;
        if (textField == self.FHCKField){
            cangKu.chooseType = ChooseCkType_FHCK;
        }else{
            cangKu.chooseType = ChooseCkType_DHCK;
        }
        [self.navigationController pushViewController:cangKu animated:YES];
    }else if(textField == self.FKZHField || textField == self.SKZHField){
        AccountViewController *account = [storyBoard instantiateViewControllerWithIdentifier:@"AccountViewController"];
        account.delegate = self;
        if (textField == self.FKZHField){
            account.chooseType = ChooseAccountType_FKAccount;
        }else{
            account.chooseType = ChooseAccountType_CKAccount;
        }
        [self.navigationController pushViewController:account animated:YES];
    }
    return NO;
}
#pragma mark SaleViewControllerDelegate
-(void) salesmanSelectedWithSalesId:(NSInteger)salesId salesName:(NSString *)salesName departId:(NSInteger)departId departName:(NSString *)departName{
    NSMutableDictionary *dic = nil;
    if ([self.setting objectForKey:@"SetDefaultParam"]){
        dic = [NSMutableDictionary dictionaryWithDictionary:[self.setting objectForKey:@"SetDefaultParam"]];
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    [dic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:salesId],@"salesId",salesName,@"salesName", nil] forKey:@"salesInfo"];
    [dic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:departId],@"departId",departName,@"departName", nil] forKey:@"departInfo"];
    [self.setting setObject:dic forKey:@"SetDefaultParam"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setDefaultValueForTextField];
}
#pragma mark departmentControllerDelegate
-(void) departmentSelectedWith:(NSInteger)departId departName:(NSString *)departName{
    NSMutableDictionary *dic = nil;
    if ([self.setting objectForKey:@"SetDefaultParam"]){
        dic = [NSMutableDictionary dictionaryWithDictionary:[self.setting objectForKey:@"SetDefaultParam"]];
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    [dic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:departId],@"departId",departName,@"departName", nil] forKey:@"departInfo"];
    [self.setting setObject:dic forKey:@"SetDefaultParam"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setDefaultValueForTextField];
}
#pragma mark KHGLController delegate
-(void) clientSelectedWithClientId:(NSInteger)clientId clientName:(NSString *)clientName{
    NSMutableDictionary *dic = nil;
    if ([self.setting objectForKey:@"SetDefaultParam"]){
        dic = [NSMutableDictionary dictionaryWithDictionary:[self.setting objectForKey:@"SetDefaultParam"]];
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    [dic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:clientId],@"clientId",clientName,@"clientName", nil] forKey:@"clientInfo"];
    [self.setting setObject:dic forKey:@"SetDefaultParam"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setDefaultValueForTextField];

}
-(void) supplierSelectedWithSupplierId:(NSInteger)supplierId supplierName:(NSString *)supplierName{
    NSMutableDictionary *dic = nil;
    if ([self.setting objectForKey:@"SetDefaultParam"]){
        dic = [NSMutableDictionary dictionaryWithDictionary:[self.setting objectForKey:@"SetDefaultParam"]];
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    [dic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:supplierId],@"supplierId",supplierName,@"supplierName", nil] forKey:@"supplierInfo"];
    [self.setting setObject:dic forKey:@"SetDefaultParam"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setDefaultValueForTextField];
}
#pragma mark cangkuController delegate
-(void) FHCKSelectedWithckId:(NSInteger)ckId ckName:(NSString *)ckName{
    NSMutableDictionary *dic = nil;
    if ([self.setting objectForKey:@"SetDefaultParam"]){
        dic = [NSMutableDictionary dictionaryWithDictionary:[self.setting objectForKey:@"SetDefaultParam"]];
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    [dic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:ckId],@"ckId",ckName,@"ckName", nil] forKey:@"FHCKInfo"];
    [self.setting setObject:dic forKey:@"SetDefaultParam"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setDefaultValueForTextField];
}
-(void) DHCKSelectedWihtckId:(NSInteger)ckId ckName:(NSString *)ckName{
    NSMutableDictionary *dic = nil;
    if ([self.setting objectForKey:@"SetDefaultParam"]){
        dic = [NSMutableDictionary dictionaryWithDictionary:[self.setting objectForKey:@"SetDefaultParam"]];
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    [dic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:ckId],@"ckId",ckName,@"ckName", nil] forKey:@"DHCKInfo"];
    [self.setting setObject:dic forKey:@"SetDefaultParam"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setDefaultValueForTextField];
}
#pragma mark AccountViewController delegate
-(void) FKaccountChoosedId:(NSInteger)accountId accountName:(NSString *)accountName{
    NSMutableDictionary *dic = nil;
    if ([self.setting objectForKey:@"SetDefaultParam"]){
        dic = [NSMutableDictionary dictionaryWithDictionary:[self.setting objectForKey:@"SetDefaultParam"]];
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    [dic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:accountId],@"accountId",accountName,@"accountName", nil] forKey:@"FKaccountInfo"];
    [self.setting setObject:dic forKey:@"SetDefaultParam"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setDefaultValueForTextField];

}
-(void) CKaccountChoosedId:(NSInteger)accountId accountName:(NSString *)accountName{
    NSMutableDictionary *dic = nil;
    if ([self.setting objectForKey:@"SetDefaultParam"]){
        dic = [NSMutableDictionary dictionaryWithDictionary:[self.setting objectForKey:@"SetDefaultParam"]];
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    [dic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:accountId],@"accountId",accountName,@"accountName", nil] forKey:@"SKaccountInfo"];
    [self.setting setObject:dic forKey:@"SetDefaultParam"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setDefaultValueForTextField];

}

- (void)dealloc {
    [_JSRField release];
    [_BMField release];
    [_KHField release];
    [_GYSField release];
    [_FHCKField release];
    [_DHCKField release];
    [_FKZHField release];
    [_SKZHField release];
    [_CZButton release];
    [_backView release];
    [super dealloc];
}
@end
