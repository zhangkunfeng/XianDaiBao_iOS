//
//  BYInviteEnvelopeViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/4/24.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "BYInviteEnvelopeViewController.h"
#import "CustomMadeNavigationControllerView.h"
#import <UShareUI/UShareUI.h>
#import <AdSupport/AdSupport.h> //获取设备号

#define FinancialRuleViewText @"邀请有好礼"
@interface BYInviteEnvelopeViewController ()<CustomUINavBarDelegate>
{
    NSString * _platfromTypeString;
    NSString * _stautsStr;
}
@end

@implementation BYInviteEnvelopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _platfromTypeString = @"";
    _stautsStr = @"1";//默认分享失败
    
    CustomMadeNavigationControllerView *financialRuleView = [[CustomMadeNavigationControllerView alloc] initWithTitle:FinancialRuleViewText showBackButton:YES showRightButton:NO rightButtonTitle:@"" target:self];
    [self.view addSubview:financialRuleView];
    
    [self createView];
    [self RecordScore];
    
    if (![self isLegalObject:[self getLocalUserinfoDict]]) {
       [self getShareInfo];
    } 
}

- (void)createView
{
    float scale = (float)1334/750;
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, iPhoneWidth, iPhoneHeight-64)];
    scrollView.contentSize = CGSizeMake(iPhoneWidth,iPhoneWidth*scale);
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, iPhoneWidth*scale)];
    imageV.image =[UIImage imageNamed:@"邀请有好礼"];
    imageV.userInteractionEnabled = YES;
    [scrollView addSubview:imageV];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeMoneyTap:)];
    [imageV addGestureRecognizer:tap];
    
}

- (void)getShareInfo {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN) };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/shareUrl", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([self isLegalObject:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self userDefaultsKeyForDictionary:(NSDictionary *) [responseObject[@"item"] copy] defaultsKey:InviteCode];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getShareInfo];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:@"-9"]) {/*外面已调用,先留着*/
                /*
                 [self errorHide];
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请先绑定银行卡" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上绑卡", nil];
                 [alertView show];
                 */
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}


- (void)RecordScore {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *nowTimeString = [NSString stringWithFormat:@"%.0f", a];
    NSUserDefaults *userDefaults = UserDefaults;
    //用户登录并使用两天之后才让去评分
    NSString *oldTimeString = getObjectFromUserDefaults(RECORDFIRSTSCORETIME);
    if ([self isBlankString:oldTimeString]) {
        //第一次进来保存本地一个时间戳
        saveObjectToUserDefaults(nowTimeString, RECORDFIRSTSCORETIME);
    } else {
        //当点击下次再说的时候保存本地一个时间戳两天后在显示
        if ([self isBlankString:[userDefaults objectForKey:RecordScoreTime]]) {
            if ([nowTimeString doubleValue] - 172800 > [oldTimeString doubleValue]) {
                [self removeLocalUserinfoDict];
            }
        } else {
            NSString *RecordScoreTimeString = [userDefaults objectForKey:RecordScoreTime];
            if ([nowTimeString doubleValue] - 172800 > [RecordScoreTimeString doubleValue]) {
                [self removeLocalUserinfoDict];
            }
        }
    }
}
- (void)makeMoneyTap:(UITapGestureRecognizer *)tap
{
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
    
    switch (platformType) {
        case UMSocialPlatformType_WechatSession:
            _platfromTypeString = @"微信朋友圈";
            break;
        case UMSocialPlatformType_WechatTimeLine:
            _platfromTypeString = @"微信";
            break;
        case UMSocialPlatformType_QQ:
            _platfromTypeString = @"QQ";
            break;
        case UMSocialPlatformType_Qzone:
            _platfromTypeString = @"QQ空间";
            break;
        default:
            break;
    }
    
    //调用分享接口   /** 不调用下面返回信息 可能原因是URLSheme 不一致  需配置(现为中之源) */
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            _stautsStr = @"1";
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                _stautsStr = @"0";
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        [self loadShareCallbackServiceWithPlatFromTypeStr:_platfromTypeString];
        //        [self alertWithError:error];
    }];
}
/**
 *  uid-用户id；status-分享状态；channelName-分享渠道；appType;imei
 *  appType(安卓：100 IOS:101)    imei是手机设备号
 *  分享状态 0:分享成功 1:分享失败  分享渠道  微信 QQ  QQ朋友圈 微信朋友圈
 */
- (void)loadShareCallbackServiceWithPlatFromTypeStr:(NSString *)typeStr
{
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"at" : getObjectFromUserDefaults(ACCESSTOKEN),
                                  @"status": _stautsStr,
                                  @"appType": @"101",
                                  @"channelName":_platfromTypeString,
                                  @"imei": [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                                  };
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/insertShareCallback", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"r"] isEqualToString:verificationOK]) {
            [self dismissWithDataRequestStatus];
            NSLog(@"分享后回调后台 = %@",responseObject);
        } else {
            [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
        }
    }
                              fail:^{
                                  //                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

- (id)loadShareDictionaryDataWithType:(ShareDictType)type
{
    NSDictionary * shareDict = nil;
    if ([self isLegalObject:[self getLocalUserinfoDict]]) {
        shareDict = [self getLocalUserinfoDict];
    } else {
        [self getShareInfo];
        shareDict = [self getLocalUserinfoDict]?[self getLocalUserinfoDict]:nil;
    }
    
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
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self isLegalObject:shareDict[@"imgUrl"]] ? [self clearSiteSpecialCharactersWithURLStr:[NSString stringWithFormat:@"%@",shareDict[@"imgUrl"]]]:@""]]];
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
- (void)goBack{
    [self customPopViewController:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
