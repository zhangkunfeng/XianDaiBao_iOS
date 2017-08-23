//
//  IsDingqiViewController.m
//  BaiYangFinancial
//
//  Created by dudu on 2017/7/13.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "IsDingqiViewController.h"
#import "CustomMadeNavigationControllerView.h"
#import "Masonry.h"
#import "ProductdetailsViewController.h"
#import "TransferViewController.h"
#import "TransferButtonViewController.h"

@interface IsDingqiViewController ()<CustomUINavBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *mingxiView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mingxiHeight;
@property (weak, nonatomic) IBOutlet UIView *touZhiView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *touzhiHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *zhijinOne;
@property (weak, nonatomic) IBOutlet UILabel *zhijinTwo;
@property (weak, nonatomic) IBOutlet UILabel *zhijinSte;
@property (weak, nonatomic) IBOutlet UILabel *hetongLab;
@property (weak, nonatomic) IBOutlet UILabel *biaodiLab;
@property (nonatomic, strong) NSArray *dingQiMutabArray;
@property (nonatomic, strong) NSDictionary *dingQiDic;
@property (nonatomic, strong) UILabel *lab0;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong)NSArray *huanKuanMutabArray;
@property (nonatomic, strong)NSDictionary *huanKuanDic;
@property (weak, nonatomic) IBOutlet UIButton *zhanrangBtn;

@end

@implementation IsDingqiViewController
-(void)goBack{
    [self customPopViewController:0];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"定期详情"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"定期详情"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetSideBack];
    // Do any additional setup after loading the view from its nib.
    if (_zhaunrang == 0 || _zhaunrang == 3 || _zhaunrang == 2) {
        _zhanrangBtn.backgroundColor = LineBackGroundColor;
        _zhanrangBtn.userInteractionEnabled = NO;
        [_zhanrangBtn setTitle:@"不可转让" forState:UIControlStateNormal];
    }else if ([_zhuanrStatus isEqualToString:@"WAIT_TRANSFER"]){
        _zhanrangBtn.backgroundColor = LineBackGroundColor;
        _zhanrangBtn.userInteractionEnabled = NO;
        [_zhanrangBtn setTitle:@"不可转让" forState:UIControlStateNormal];
    }
    _dingQiDic = [[NSDictionary alloc]init];
    _dingQiMutabArray = [[NSArray alloc]init];
    _huanKuanDic = [[NSDictionary alloc]init];
    _huanKuanMutabArray = [[NSArray alloc]init];
    _dic = [[NSDictionary alloc]init];
    CustomMadeNavigationControllerView *NavigationControllerView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"定期详情" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:NavigationControllerView];
     [self dingqiTouzMingx];
    [self dingqi];
   
    [self dingqiHuanK];
    
    
//    [self addmingxi];
   // [self addTouZhi];
}


-(void)addTouZhi{
    CGFloat h = 0;
    for (int i = 0; i < _huanKuanMutabArray.count; i++) {
        {
            h += 10;
            UILabel *lab0 = [[UILabel alloc]init];
            lab0.text = @"gsg";
            [_touZhiView addSubview:lab0];
            [lab0 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_touZhiView).offset(15);
                make.top.equalTo(_touZhiView).offset(h);
            }];
            UILabel *lab1 = [[UILabel alloc]init];
            lab1.text = @"eerg";
            [_touZhiView addSubview:lab1];
            [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_touZhiView).offset(-15);
                make.top.equalTo(_touZhiView).offset(h);
            }];
            UILabel *lab2 = [[UILabel alloc]init];
            lab2.text = @"投资本金:";
            [_touZhiView addSubview:lab2];
            [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(lab1.mas_left).offset(-2);
                make.top.equalTo(_touZhiView).offset(h);
            }];
            [lab0 sizeToFit];
            h += CGRectGetMaxY(lab0.frame);
        }
        if (_huanKuanMutabArray.count-i!=1) {
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = [UIColor colorWithHex:@"f5f5f5"];
            [_touZhiView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_touZhiView).offset(h + 10);
                make.height.mas_equalTo(1);
                make.left.equalTo(_touZhiView).offset(15);
                make.right.equalTo(_touZhiView).offset(15);
            }];
            h += 11;
        }
    }
    _touzhiHeight.constant = h+10;


}
-(void)dingqi{
    NSDictionary *parameters = @{
                                  @"bid": _bid,
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"uid":getObjectFromUserDefaults(UID),
                                  @"bidSubStatus":@"1"
                                  };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/getRegularBidInfo",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf dingqi];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                //[self hideMDErrorShowView:self];
                if ([responseObject[@"item"] isKindOfClass:[NSDictionary class]]) {
                    _dingQiDic = [responseObject[@"item"] copy];
                    _titleLab.text = [NSString stringWithFormat:@"%@",_dingQiDic[@"title"]];
                    _zhijinOne.text = [NSString stringWithFormat:@"%.2f",[_dingQiDic[@"capital"] doubleValue]];
                    _zhijinTwo.text = [NSString stringWithFormat:@"%.2f",[_dingQiDic[@"interest"] doubleValue]];
                    _zhijinSte.text = [NSString stringWithFormat:@"%@",_dingQiDic[@"borroePeriod"]];
                }
            
            }
        
        
        
    } fail:^{
        
    }];

}

-(void)dingqiTouzMingx{
    NSDictionary *parameters = @{@"bid": _bid,
                                 @"at": getObjectFromUserDefaults(ACCESSTOKEN),
                                 @"uid":getObjectFromUserDefaults(UID),
                                 @"bidSubStatus":@"0"};
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/getRegularBidInfo",GeneralWebsite] parameters:parameters success:^(id responseObject) {
       
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf dingqiTouzMingx];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                //[self hideMDErrorShowView:self];
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                    _dingQiMutabArray = [responseObject[@"data"] copy];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                    formatter.timeZone = [NSTimeZone timeZoneWithName:@"hangzhou"];
                    [formatter setDateStyle:NSDateFormatterMediumStyle];
                    [formatter setTimeStyle:NSDateFormatterShortStyle];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    
                    // 毫秒值转化为秒
                    

                    CGFloat h = 0;
                    for (int i = 0; i < _dingQiMutabArray.count; i++) {
                        
                        {
                            _dic = _dingQiMutabArray[i];
                            NSDate* date = [NSDate dateWithTimeIntervalSince1970:[_dic[@"successTime"] doubleValue]/ 1000.0];
                            NSString* dateString = [formatter stringFromDate:date];
                            h += 10;
                            UILabel *lab0 = [[UILabel alloc]init];
                            lab0.text = dateString;
                            [_mingxiView addSubview:lab0];
                            [lab0 mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(_mingxiView).offset(15);
                                make.top.equalTo(_mingxiView).offset(h);
                            }];
                            UILabel *lab1 = [[UILabel alloc]init];
                            lab1.text = [NSString stringWithFormat:@"%.2f元",[_dic[@"capital"] doubleValue]];
                            [_mingxiView addSubview:lab1];
                            [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.right.equalTo(_mingxiView).offset(-15);
                                make.top.equalTo(_mingxiView).offset(h);
                            }];
                            UILabel *lab2 = [[UILabel alloc]init];
                            lab2.text = @"投资本金:";
                            [_mingxiView addSubview:lab2];
                            [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.right.equalTo(lab1.mas_left).offset(-2);
                                make.top.equalTo(_mingxiView).offset(h);
                            }];
                            [lab0 sizeToFit];
                            h += CGRectGetMaxY(lab0.frame);
                        }
                        if (_dingQiMutabArray.count-i!=1) {
                            UIView *line = [[UIView alloc]init];
                            line.backgroundColor = [UIColor colorWithHex:@"f5f5f5"];
                            [_mingxiView addSubview:line];
                            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.top.equalTo(_mingxiView).offset(h + 10);
                                make.height.mas_equalTo(1);
                                make.left.equalTo(_mingxiView).offset(15);
                                make.right.equalTo(_mingxiView).offset(15);
                            }];
                            h += 11;
                        }
                    }
                    _mingxiHeight.constant = h+10;

                }
                
            }
        
        
        
    } fail:^{
        
    }];
    
}
-(void)dingqiHuanK{
    NSDictionary *parameters = @{
                                 @"bid": _bid,
                                 @"uid":getObjectFromUserDefaults(UID),
                                 @"at":getObjectFromUserDefaults(ACCESSTOKEN)
                                 };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@bid/getRecoverInfo",GeneralWebsite] parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if (responseObject) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf dingqiHuanK];
                } withFailureBlock:^{
                    
                }];
            }else if ([responseObject[@"r"] isEqualToString:verificationOK]){
                //[self hideMDErrorShowView:self];
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                    _huanKuanMutabArray = [responseObject[@"data"] copy];
                    
                    CGFloat h = 0;
                    
                    for (int i = 0; i < _huanKuanMutabArray.count; i++) {
                        {
                            _huanKuanDic = _huanKuanMutabArray[i];
           
                                                        h += 10;
                            UILabel *lab0 = [[UILabel alloc]init];
                            if ([_huanKuanDic[@"statusStr"] isEqualToString:@"false"] || _huanKuanDic[@"statusStr"] == nil || [_huanKuanDic[@"statusStr"] isEqualToString:@"nill"] || [_huanKuanDic[@"statusStr"] isEqualToString:@"0"] || [_huanKuanDic[@"statusStr"] intValue] == 0) {
                                
                             lab0.text = [NSString stringWithFormat:@"第%@期%@",_huanKuanDic[@"period"],_huanKuanDic[@"showTime"]];
                                

                            }else{
                            lab0.text = [NSString stringWithFormat:@"第%@期%@(已还)",_huanKuanDic[@"period"],_huanKuanDic[@"showTime"]];
                                
                            }
                            
                            [_touZhiView addSubview:lab0];
                            [lab0 mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(_touZhiView).offset(15);
                                make.top.equalTo(_touZhiView).offset(h);
                            }];
                            UILabel *lab1 = [[UILabel alloc]init];
                            lab1.text = [NSString stringWithFormat:@"%.2f元",[_huanKuanDic[@"amount"] floatValue]];
                            [_touZhiView addSubview:lab1];
                            [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.right.equalTo(_touZhiView).offset(-15);
                                make.top.equalTo(_touZhiView).offset(h);
                            }];
                            UILabel *lab2 = [[UILabel alloc]init];
                            lab2.text = @"应收本息:";
                            [_touZhiView addSubview:lab2];
                            [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.right.equalTo(lab1.mas_left).offset(-2);
                                make.top.equalTo(_touZhiView).offset(h);
                            }];
                            [lab0 sizeToFit];
                            h += CGRectGetMaxY(lab0.frame);
                        }
                        if (_huanKuanMutabArray.count-i!=1) {
                            UIView *line = [[UIView alloc]init];
                            line.backgroundColor = [UIColor colorWithHex:@"f5f5f5"];
                            [_touZhiView addSubview:line];
                            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.top.equalTo(_touZhiView).offset(h + 10);
                                make.height.mas_equalTo(1);
                                make.left.equalTo(_touZhiView).offset(15);
                                make.right.equalTo(_touZhiView).offset(15);
                            }];
                            h += 11;
                        }
                    }
                    _touzhiHeight.constant = h+10;
                 
                    
                }
                
            }
        }
        
        
    } fail:^{
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)lockHetong:(UITapGestureRecognizer *)sender {
   [self jumpToWebview:[NSString stringWithFormat:@"%@user/showContract?uid=%@&bid=%@", GeneralWebsite, getObjectFromUserDefaults(UID),_bid] webViewTitle:@"项目详情"];
    
}


- (IBAction)lockBiaoD:(UITapGestureRecognizer *)sender {
    ProductdetailsViewController *ProductdetailsView = [[ProductdetailsViewController alloc] initWithNibName:@"ProductdetailsViewController" bundle:nil];
    ProductdetailsView.productBid = [NSString stringWithFormat:@"%zd", [_bid integerValue]];
    ProductdetailsView.bidNameString = _dingQiDic[@"title"];
    [self customPushViewController:ProductdetailsView customNum:0];

    
}


- (IBAction)zhaunrangAction:(id)sender {
    
    TransferButtonViewController *transferView = [[TransferButtonViewController alloc] initWithNibName:@"TransferButtonViewController" bundle:nil];
    transferView.transferbidID = _bid;
    transferView.isbackRefresh = ^(BOOL isRefresh) {
        _zhanrangBtn.backgroundColor = LineBackGroundColor;
        _zhanrangBtn.userInteractionEnabled = NO;
        [_zhanrangBtn setTitle:@"不可转让" forState:UIControlStateNormal];

    };
    //transferView.debtUid = _useID;
    [self customPushViewController:transferView customNum:0];

    
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
