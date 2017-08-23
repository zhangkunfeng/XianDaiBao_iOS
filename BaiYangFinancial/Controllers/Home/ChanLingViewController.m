//
//  ChanLingViewController.m
//  BaiYangFinancial
//
//  Created by dudu on 2017/6/28.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "ChanLingViewController.h"
#import "ChangeRecordViewController.h"
#import "RollInViewController.h"
#import "RollOutViewController.h"
@interface ChanLingViewController ()

@property (weak, nonatomic) IBOutlet UIView *NavigationView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) NSDictionary *changDict;
@property (weak, nonatomic) IBOutlet UILabel *titleStr;

@end

@implementation ChanLingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _changDict = [[NSDictionary alloc]init];
    //[self changMoeny];
    // Do any additional setup after loading the view from its nib.
    [self.backBtn setImage:[UIImage imageNamed:@"back_ Selected"] forState:UIControlStateHighlighted];
    [self changMoeny];
}
- (IBAction)backLin:(id)sender {
    [self customPopViewController:0];

}
- (IBAction)chongZhiBtn:(id)sender {
    
    RollInViewController * rollInVC = [[RollInViewController alloc] initWithNibName:@"RollInViewController" bundle:nil];
    rollInVC.bid = _changDict[@"bid"];
    rollInVC.rollInRefresh = ^(BOOL isRefresh){
        if (isRefresh) {
            [self changMoeny];
        }
    };
    [self customPushViewController:rollInVC customNum:0];

    
}
- (IBAction)tiXianBtn:(id)sender {
    
    RollOutViewController * rollOutVC = [[RollOutViewController alloc] initWithNibName:@"RollOutViewController" bundle:nil];
    rollOutVC.changeMoneyBlanceStr = _changDict[@"personAmount"];
    rollOutVC.bid = _changDict[@"bid"];
    rollOutVC.rollOutRefresh = ^(BOOL isRefresh){
        if (isRefresh) {
            [self changMoeny];
        }
    };
    [self customPushViewController:rollOutVC customNum:0];
    
}





- (IBAction)mingxi:(id)sender {
    
    ChangeRecordViewController *chang = [[ChangeRecordViewController alloc]init];
    [self customPushViewController:chang customNum:0];

}

/*item = {
	amount = 80000,
	uid = <null>,
	borrowedAmount = 0,
	tenderMinAmount = 100,
	borrowAnnualYieldDay = 0.068493,
	title = 零钱标[test],
	borrowAnnualYield = 25,
	recoveredInterest = 0,
	personAmount = 0,
	bid = 2
 },
	total = 0
*/

-(void)changMoeny{
    NSDictionary *parameters = @{ @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid": getObjectFromUserDefaults(UID)};

    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/getCoinInfo", GeneralWebsiteT] parameters:parameters success:^(id responseObject) {
        WS(weakSelf);
        if ([self isLegalObject:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf changMoeny];
                }
                                                                     withFailureBlock:^{
                                                                         
                                                                     }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                    _changDict = [responseObject[@"item"] copy];
                    _titleStr.text = [NSString stringWithFormat:@"%@",_changDict[@"title"]];
                    _nHuaLab.text = [NSString stringWithFormat:@"%@",_changDict[@"borrowAnnualYield"]];
                    _yesTerDayLab.text = [NSString stringWithFormat:@"%@",_changDict[@"recoveredInterest"]];
                    _totalAmLab.text = [NSString stringWithFormat:@"%@",_changDict[@"borrowedAmount"]];
                    _remainingLab.text = [NSString stringWithFormat:@"%@",_changDict[@"personTotalEarnings"]];
                    _cumulativeLab.text = [NSString stringWithFormat:@"%@",_changDict[@"personSurplus"]];
                    _cumulativeBigLab.text = [NSString stringWithFormat:@"%@",_changDict[@"totalVolumeBusiness"]];
                    _cumulativeUserLab.text = [NSString stringWithFormat:@"%@",_changDict[@"countInvestors"]];

                    }

                
                NSLog(@"%@",responseObject);
                
            }else{
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0f promptStr:errorPromptString];
                              }];
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
