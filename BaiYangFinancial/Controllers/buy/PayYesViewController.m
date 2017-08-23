//
//  PayYesViewController.m
//  BaiYangFinancial
//
//  Created by 民华 on 2017/7/7.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "PayYesViewController.h"
#import "CustomMadeNavigationControllerView.h"
#import "WithDrawDetailsViewController.h"
#import "shareView.h"
#import "TalkingDataAppCpa.h"
#import <UShareUI/UShareUI.h>
@interface PayYesViewController ()<shareViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *kefuTeleLab;
@property (nonatomic, strong) NSDictionary *customServiceDict;
@property (copy, nonatomic) NSDictionary *shareDictionary;
@property (copy, nonatomic) NSDictionary *successViewDataDict;

@property (strong, nonatomic) shareView *shareView;
@end

@implementation PayYesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self talkingDatatrackPageBegin:@"支付成功"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self talkingDatatrackPageEnd:@"支付成功"];
   
    
}
- (void)showshareView {
    if (!_shareView) {
        _shareView = [[shareView alloc] initWithShareViewDelegate:self];
        [self showPopupWithStyle:CNPPopupStyleCentered popupView:_shareView];
    }
    
    if (getDictionaryFromUserDefaults(InvestmentSuccessDataDict)) {
        [_shareView setDataWithShareView];
    }
}
- (void)UMengShare {
    [self dismissShareView];
    
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [weakSelf shareWebPageToPlatformType:platformType];
    }];
}
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[self loadShareDictionaryDataWithType:ShareDictType_shareTitle] descr:[self loadShareDictionaryDataWithType:ShareDictType_shareDesc] thumImage:[self loadShareDictionaryDataWithType:ShareDictType_iconImage]];
    //设置网页地址
    shareObject.webpageUrl = [self loadShareDictionaryDataWithType:ShareDictType_shareLink];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
}

- (id)loadShareDictionaryDataWithType:(ShareDictType)type
{
    NSDictionary * shareDict = _shareDictionary;
    switch (type) {
        case ShareDictType_shareTitle:
        {
            return [self isLegalObject:shareDict[@"title"]] ? [NSString stringWithFormat:@"%@",shareDict[@"title"]]:@"";
        }
            break;
            
        case ShareDictType_shareLink:
        {
            return [self isLegalObject:shareDict[@"link"]] ? [NSString stringWithFormat:@"%@",shareDict[@"link"]]:@"";
        }
            break;
            
        case ShareDictType_iconImage:
        {
            UIImage * image;
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self isLegalObject:shareDict[@"imgUrl"]] ? [NSString stringWithFormat:@"%@",shareDict[@"imgUrl"]]:@""]]];
            image  = image ? image : [UIImage imageNamed:@"120-120"];
            return image;
        }
            break;
            
        case ShareDictType_shareDesc:
        {
            NSString *shareText = @"";
            if ([shareDict[@"desc"] length] > 0) {
                shareText = shareDict[@"desc"];
                //去除字符串中的标识符
                if ([shareText rangeOfString:@"\n"].location != NSNotFound) {
                    shareText = [shareText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                }
                if ([shareText rangeOfString:@"\r"].location != NSNotFound) {
                    shareText = [shareText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                }
            }
            return shareText;
        }
            break;
            
        default:
            break;
    }
    return 0;
}
/*不知*/
- (void)dismissPopupControllerForCustomShareView {
    [self showWithSuccessWithStatus:@"链接复制成功"];
    [self dismissPopupController];
}
/*不知*/
- (void)dismissForCustomShareViewInshareing {
    [self dismissPopupController];
}

- (void)dismissShareView {
    [self.popupViewController dismissPopupControllerAnimated:YES];
    if (_shareView) {
        _shareView = nil;
    }
}
- (void)goBack {
[self customPopViewController:3];
}
- (IBAction)sureBtn:(id)sender {
    [self customDismissController];
 [self customPopViewController:3];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    _customServiceDict = [NSDictionary dictionary];
    // Do any additional setup after loading the view from its nib.
    CustomMadeNavigationControllerView *NavigationControllerView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"支付成功" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:NavigationControllerView];
}

-(void)setUI {
    _tMoenyLab.text = _moen;

}

- (void)loadCustomerServiceData {
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/queryServiceHotline?at=%@", GeneralWebsite,getObjectFromUserDefaults(ACCESSTOKEN)] parameters:nil success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            if (![responseObject[@"item"] isEqual:[NSNull null]]) {
                _customServiceDict = [responseObject[@"item"] copy];
                [_kefuTeleLab setTitle:_customServiceDict[@"service_hotline"] forState:UIControlStateNormal];
                
            }
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  
                              }];
}


- (IBAction)teleAction:(id)sender {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_customServiceDict[@"service_hotline"]];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
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
