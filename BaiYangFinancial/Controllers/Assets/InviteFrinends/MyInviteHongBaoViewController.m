//
//  MyInviteHongBaoViewController.m
//  BaiYangFinancial
//
//  Created by 洪徐 on 16/6/28.
//  Copyright © 2016年 艾运旺. All rights reserved.
//

#import "BindingBankCardViewController.h"
#import "CustomMadeNavigationControllerView.h"
#import "MyInviteHongBaoViewController.h"
#import <UShareUI/UShareUI.h>
#import <AdSupport/AdSupport.h> //获取设备号

@interface MyInviteHongBaoViewController () <CustomUINavBarDelegate,  UIAlertViewDelegate>
{
    NSString * _platfromTypeString;
    NSString * _stautsStr;

}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *ContentButton;
@property (weak, nonatomic) IBOutlet UIImageView *QrcodeImageView;
- (IBAction)InviteFrindsShareButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *detailLable1;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ruleDescLabelTop;

@end

@implementation MyInviteHongBaoViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _platfromTypeString = @"";
    _stautsStr = @"1";//默认分享失败
    CustomMadeNavigationControllerView *InviteFrinendsView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"邀请好友送红包" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:InviteFrinendsView];
    
    self.ruleDescLabelTop.constant = iPhone4?25:iPhone5?32:iPhone6?39:47.5;
    
    [self clearLocalUserinfoDictOnlyOne];
   
    [self RecordScore];
    if ([self isLegalObject:[self getLocalUserinfoDict]]) {
        [self errorHide];
        [self setCodeImage];
        [self settingInviteDetailLabel:[self getLocalUserinfoDict][@"htmlRules"]];
    } else {
        [self getShareInfo];
    }
    
}

- (void)clearLocalUserinfoDictOnlyOne{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      NSLog(@"只打印一次");
        [self removeLocalUserinfoDict];
    });
}

- (void)RecordScore {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *nowTimeString = [NSString stringWithFormat:@"%.0f", a];
    NSUserDefaults *userDefaults = UserDefaults;
    
    NSString *oldTimeString = getObjectFromUserDefaults(RECORDFIRSTSCORETIME);
    if ([self isBlankString:oldTimeString]) {
        saveObjectToUserDefaults(nowTimeString, RECORDFIRSTSCORETIME);
    } else {
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


- (void)goBack {
    [self customPopViewController:0];
}

/**
 {
	r = 1,
	data = [
 ],
	msg = 成功！,
	item = {
	imgUrl = ,
	htmlRules = 1、每成功邀请一位好友在注册后累计投资大于1000元即可获得10元现金红包，邀请越多，奖励越多，上不封顶哦！
 2、只有您的好友通过推荐链接填写手机号并注册投资，您才能获得红包哦！
 3、获得的现金红包不可直接提现，投资回款后即可提现！,
	title = 贤钱宝专注车贷金融，理财收益12%起,
	desc = 我在在使用最安全的理财产品APP贤钱宝投资，现在注册还送60元大礼包！http://123.56.233.157/phone/invitedPage?yqr=40301&sign=73fd3ad07476808f773a2649cc377305,
	link = http://123.56.233.157/phone/invitedPage?yqr=40301&sign=73fd3ad07476808f773a2649cc377305
 },
	total = 0
 }
 */
- (void)getShareInfo {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN) };
    [_activityIndicatorView startAnimating];
    _activityIndicatorView.hidden = NO;
    self.ContentButton.enabled = NO;
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/shareUrl", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([self isLegalObject:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
//                NSLog(@"%@",responseObject);
                [self errorHide];
                [self userDefaultsKeyForDictionary:(NSDictionary *) [responseObject[@"item"] copy] defaultsKey:InviteCode];
                [weakSelf setCodeImage];
                //邀请细则
                [self settingInviteDetailLabel:responseObject[@"item"][@"htmlRules"]];
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
                [self errorHide];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                   [self errorHide];
                                [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}

- (void)settingInviteDetailLabel:(NSString *)htmlRules
{
    htmlRules=htmlRules.length>0?htmlRules:@"1、每成功邀请一位好友在注册后累计投资大于1000元即可获得30元现金红包，邀请越多，奖励越多，上不封顶哦！\n2、只有您的好友通过推荐链接填写手机号并注册投资，您才能获得红包哦！\n3、获得的现金红包不可直接提现，投资回款后即可提现!";
    self.detailLable1.text = htmlRules;//这样以/n 直接换行也行
//    NSArray * strArray = [htmlRules componentsSeparatedByString:@"/n"];//不考虑分割了
}

/*外面已调用,先留着*/
#pragma mark - UIAlertViewDelegate
/*
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                      @"sid": getObjectFromUserDefaults(SID),
                                      @"state": @"1",
                                      @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                      };
        [self showWithDataRequestStatus:@"获取信息中..."];
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getMyBankDetail", GeneralWebsite] parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self dismissWithDataRequestStatus];
                BindingBankCardViewController *BindingBankCardView = [[BindingBankCardViewController alloc] init];
                BindingBankCardView.bankPayChannel = BankPayFromBindingCard;
                BindingBankCardView.isRefresh = ^(BOOL isRefresh) {
                    
                };
                BindingBankCardView.UserInformationDict = (NSDictionary *) [responseObject[@"item"] copy];
                [self customPushViewController:BindingBankCardView customNum:0];
            } else {
                [self dismissWithDataRequestStatus];
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
                                  fail:^{
                                      [self dismissWithDataRequestStatus];
                                      [self errorPrompt:3.0 promptStr:errorPromptString];
                                  }];
    }
}
*/

- (void)setCodeImage {
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:[self getLocalUserinfoDict][@"link"]] withWidth:140.0f withHeight:140.0f];
    UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:0.0f andGreen:0.0f andBlue:0.0f];
    self.QrcodeImageView.image = customQrcode;
    // set shadow
    self.QrcodeImageView.layer.shadowOffset = CGSizeMake(0, 2);
    self.QrcodeImageView.layer.shadowRadius = 1;
    self.QrcodeImageView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.QrcodeImageView.layer.shadowOpacity = 0.5;
}

#pragma mark - InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withWidth:(CGFloat)imageWidth withHeight:(CGFloat)imageHeight {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(imageWidth / CGRectGetWidth(extent), imageHeight / CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo) kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    UIImage *Backimage = [UIImage imageWithCGImage:scaledImage];
    // Cleanup
    CGColorSpaceRelease(cs);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGImageRelease(scaledImage);
    return Backimage;
}

#pragma mark - QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent
void ProviderReleaseData(void *info, const void *data, size_t size) {
    free((void *) data);
}
- (UIImage *)imageBlackToTransparent:(UIImage *)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue {
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t *) malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t *pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) {
            // change color
            uint8_t *ptr = (uint8_t *) pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        } else {
            uint8_t *ptr = (uint8_t *) pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)InviteFrindsShareButtonAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
      [weakSelf shareWebPageToPlatformType:platformType];
    }];
}

/**
 desc = "\U6211\U5728\U5728\U4f7f\U7528\U6700\U5b89\U5168\U7684\U7406\U8d22\U4ea7\U54c";
 imgUrl = "http://123.56.250.207/static/weiApp/img/share/reward_m.png";
 link = "http://123.57.172.67:8081/mobile/phone/invitedPage?yqr=133195&sign=91f68643e04f2e5292bb143b62d1de7f";
 title = "\U4fe1\U878d\U4e13\U6ce8\U8f66\U8d37\U91d1";
 */
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
//        [self loadShareCallbackServiceWithPlatFromTypeStr:_platfromTypeString];
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
- (void)dismissPopupControllerForCustomShareView {
    [self showWithSuccessWithStatus:@"链接复制成功"];
    [self dismissPopupController];
}

- (void)dismissForCustomShareViewInshareing {
    [self dismissPopupController];
}

#pragma mark - ERROR
- (void)errorHide {
    [_activityIndicatorView stopAnimating];
    _activityIndicatorView.hidden = YES;
    self.ContentButton.enabled = YES;
}

@end
