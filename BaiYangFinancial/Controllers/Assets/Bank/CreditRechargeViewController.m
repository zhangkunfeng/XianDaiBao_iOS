//
//  CreditRechargeViewController.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/3/24.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "CreditRechargeViewController.h"
#import "XRPayPassWorldView.h"
#import "VerificationiPhoneCodeViewController.h"
#import <Photos/Photos.h>
#import "MBProgressHUD.h"
#import "ForgetPassWdViewController.h"

@interface CreditRechargeViewController ()<XRPayPassWorldViewDelegate>
{
    UIAlertView *showArlert;
    UIAlertView *jumpArlert;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *theFirstViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *ruleDescLabel;
@property (weak, nonatomic) IBOutlet UITextField *chargeMoneyTF;
@property (weak, nonatomic) IBOutlet UIButton *clickChargeMaxBtn;
@property (weak, nonatomic) IBOutlet UIButton *select_wechat;
@property (weak, nonatomic) IBOutlet UIButton *select_airpay;

@property (copy, nonatomic) NSString * qrCodeUrlStr;
@property (assign, nonatomic)BOOL showAlert;
@property (strong, nonatomic)XRPayPassWorldView *payPWDView;

- (IBAction)chargeBtnClicked:(id)sender;

- (IBAction)wechatSelectClicked:(id)sender;
- (IBAction)airPayClicked:(id)sender;

@end

#define CreditRechargeVCText @"二维码充值"
@implementation CreditRechargeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomMadeNavigationControllerView *creditRechargeView = [[CustomMadeNavigationControllerView alloc] initWithTitle:CreditRechargeVCText showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:creditRechargeView];
    
    self.theFirstViewWidth.constant = (iPhone4||iPhone5)?320:iPhone6_?414:375;
    NSString * ruleStr = @"1.充值二维码会自动保存至您的本地相册。\n2.打开支付宝或微信扫一扫功能，识别相册中的二维码即可进行支付。\n3.当您选择二维码充值时，建议使用支付宝或微信中绑定的信用卡进行支付。若您想使用储蓄卡支付，建议直接选择平台的储蓄卡充值，该方式不收取任何手续费。";
    [self setLabelSpace:self.ruleDescLabel withValue:ruleStr withFont:[UIFont systemFontOfSize:13.0f]];
    
    [self.chargeMoneyTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //点击屏幕空白区域收起键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keybordDown:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - 点击屏幕空白区域收起键盘
- (void)keybordDown:(id)sender {
    [self.view endEditing:YES];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.chargeMoneyTF) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
            [self errorPrompt:3.0 promptStr:@"最高单笔充值不能超过100万元"];
        }
    }
}

- (void)goBack{
    [self customPopViewController:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//充值
- (IBAction)chargeBtnClicked:(id)sender {
    
    if (![self isPureFloat:self.chargeMoneyTF.text]) {
        [self errorPrompt:3.0 promptStr:@"请输入数字"];
        return;
    }
    if ([self.chargeMoneyTF.text doubleValue] == 0) {
        [self errorPrompt:3.0 promptStr:@"请输入充值金额"];
        return;
    }
    
    [self showPopupWithStyle:CNPPopupStyleCentered popupView:self.payPWDView];
}

#pragma mark - payPassworldViewDelegate
- (void)sureTappend{
    [self getEncryptionString];
}

- (void)cancelTappend{
    [self dismissPopupController];
}

- (void)forgetPassWorldTappend{
    [self dismissWithDataRequestStatus];
    [self dismissPopupController];
    ForgetPassWdViewController *VerificationCode = [[ForgetPassWdViewController alloc] initWithNibName:@"ForgetPassWdViewController" bundle:nil];
    VerificationCode.iphoneNumberString = getObjectFromUserDefaults(MOBILE);
    //VerificationCode.timeout = GetCodeMaxTime;
    VerificationCode.isFindPassworld = 2;
    VerificationCode.initalClassName = NSStringFromClass([self class]);
    [self customPushViewController:VerificationCode customNum:0];
    
}

//获取交易密码加密字  秘钥
- (void)getEncryptionString {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"sid": getObjectFromUserDefaults(SID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN)
                                  };
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@user/getPwdKey", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if (![self isBlankString:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getEncryptionString];
                } withFailureBlock:^{
                    
                }];
            } else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]) {
                [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                    [weakSelf getEncryptionString];
                } withFailureBlock:^{
                    [weakSelf getEncryptionString];
                }];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self showWithDataRequestStatus:@"充值中..."];
                [weakSelf loadrongzhifuRechargeData];
            } else {
                [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
            }
        }
    }
                              fail:^{
                                  [self errorPrompt:3.0 promptStr:errorPromptString];
                              }];
}
/**
 * 2.信用卡充值接口   bank/rongzhifuRecharge
 *   参数:
 *   sid, name(姓名),
 *   money(金额), appType,
 *   id_no(身份证号), pwd(支付密码),
 *   gidType(支付渠道 微信：0 支付宝：1)
 */
#pragma mark - 融支付充值接口
- (void)loadrongzhifuRechargeData
{
        NSString * chargeUrlString = ![self isBlankString:_chargeUrlStr]?_chargeUrlStr:@"bank/rongzhifuRecharge";
        NSString  * gidTypeStr = _select_wechat.selected?@"0":@"1";
        NSDictionary *parameters = @{@"uid":   getObjectFromUserDefaults(UID),
                                     @"sid":   getObjectFromUserDefaults(SID),
                                     @"at" :   getObjectFromUserDefaults(ACCESSTOKEN),
                                     @"name"   : _UserInformationDict[@"userName"],
                                     @"id_no"  : _UserInformationDict[@"idNumber"],
                                     @"card_no": _UserInformationDict[@"account"],
                                     @"bankId" : _UserInformationDict[@"bankId"],
                                     @"money"  : self.chargeMoneyTF.text,
                                     @"gidType": gidTypeStr,
                                     @"appType": @"101",
                                     @"pwd":  [NetManager TripleDES:self.payPWDView.textField.text encryptOrDecrypt:kCCEncrypt key:K3DESKey],};
        
        NSLog(@"parameters = %@",parameters);
        /*
         BaiYangFinancial[626:207097] {
         data =     (
         );
         item = "weixin://wxpay/bizpayurl?pr=XusWU69";
         //item = "https://qr.alipay.com/bax01344gfybmec2jiyc8037";
         msg = "\U6210\U529f";
         r = 1;
         total = 0;
         }
         */
        [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@%@",GeneralWebsite,chargeUrlString] parameters:parameters success:^(id responseObject) {
            WS(weakSelf);
            if (responseObject[@"r"]) {
                if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                    [self cancelTappend];
                    [self dismissWithDataRequestStatus];
                    if ([responseObject[@"item"] isKindOfClass:[NSString class]]) {
                        _qrCodeUrlStr = [responseObject[@"item"] copy];
                        [self saveImageToPhotosAlbum];
                    }
                    
                }else if ([responseObject[@"r"] isEqualToString:TOKEN_TIME]){
                    [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                        [weakSelf loadrongzhifuRechargeData];
                    } withFailureBlock:^{
                        
                    }];
                }else if ([responseObject[@"r"] isEqualToString:SESSION_EMPTY]){
                    [[WDQuerySessionID sharedInstance] querySessionIDWithSuccessBlock:^(id responseObj) {
                        [weakSelf loadrongzhifuRechargeData];
                    } withFailureBlock:^{
                        
                    }];
                }else{
                    [self errorPrompt:3.0 promptStr:responseObject[@"msg"]];
                }
            }
        } fail:^{
            [self errorPrompt:3.0 promptStr:errorPromptString];
        }];
}

//保存图片到本地
- (void)saveImageToPhotosAlbum
{
    UIImage * image = [self generateQrcodeImageWithUrlStr:_qrCodeUrlStr?_qrCodeUrlStr:@""];
    NSString  * textStr = [NSString stringWithFormat:@"%@  充值 %@ 元   %@",
                           _select_wechat.selected?@"微信":@"支付宝",
                           self.chargeMoneyTF.text,[self getNowTime]];
    
    //加水印 二维码位置无法更改
   /* CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    UIImage * newImage = [self addText:image text:textStr withRect:CGRectMake(12, h-15, w, 15)];*/
    
    //创建图片视图
    UIView * shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, iPhoneWidth)];
    
    UIImageView *wechatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, iPhoneWidth - 60, iPhoneWidth - 60)];
    wechatImageView.image  = image;
    [shareView addSubview:wechatImageView];
    UILabel * descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(wechatImageView.frame)-10, iPhoneWidth-20, 40)];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = [UIColor darkGrayColor];
    descLabel.text = textStr;
    descLabel.adjustsFontSizeToFitWidth = YES;
    [shareView addSubview:descLabel];
    UIImage * newImage = [self createViewImage:shareView];
    
    
    [self saveImageToPhotos:newImage];
}

#pragma mark - 保存视图为图片
- (UIImage *)createViewImage:(UIView *)shareView {
    UIGraphicsBeginImageContextWithOptions(shareView.bounds.size, NO, [UIScreen mainScreen].scale);
    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 保存图片到本地相册
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
}
//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存二维码图片失败,请重试" ;
    }else{
        msg = [NSString stringWithFormat:@"保存二维码图片成功,是否前往%@扫一扫页面,然后从本地扫描刚才默认保存的二维码图片进行支付。",_select_wechat.selected?@"微信,请打开":@"支付宝"];
    }
//    [self errorPrompt:3.0 promptStr:msg];
    
    //弹窗提醒
    if (iOS7) {
        jumpArlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
        [jumpArlert show];
    } else {
        //初始化提示框；
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self travelToWechatOrAirPayAction];
        }]];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0 && alertView == jumpArlert) {
        [self travelToWechatOrAirPayAction];
    }
    
    if (buttonIndex != 0 && alertView == showArlert) {
        [self customPopViewController:0];
    }
}

- (void)travelToWechatOrAirPayAction
{
    /**
     之前看到 @maple 分享的一键开启这几个功能的 Url scheme ：
     支付宝扫码  alipayqr://platformapi/startapp?saId=10000007
     支付宝付款码 alipayqr://platformapi/startapp?saId=20000056
     微信扫一扫的 weixin://dl/scan  //已失效
     QQ扫一扫代码 mqq://dl/scan/scan
     //之前配置的白名单，就是需要跳转对方App的key，即对方设置的url
     */
    NSArray * arrayUrl = @[@"weixin://",
                           @"alipayqr://platformapi/startapp?saId=10000007"];
    NSURL * url = [NSURL URLWithString:arrayUrl[_select_wechat.selected?0:1]];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        _showAlert = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowShowAlert:) name:CreditRechargeShowAlert object:nil];
        
        [[UIApplication sharedApplication] openURL:url];
    }else{
        NSArray * alertMsg = @[@"抱歉，您未安装微信客户端,请安装后再使用",
                               @"抱歉，您未安装支付宝客户端,请安装后再使用"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMsg[_select_wechat.selected?0:1] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - 加文字水印
- (UIImage *) addText:(UIImage *)img text:(NSString *)mark withRect:(CGRect)rect
{
    int w = img.size.width;
    int h = img.size.height;
    
    UIGraphicsBeginImageContext(img.size);
    [[UIColor darkGrayColor] set];
    [img drawInRect:CGRectMake(0, 0, w, h)];
    
    if([[[UIDevice currentDevice]systemName]floatValue] >= 7.0)
    {
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f], NSFontAttributeName,[UIColor darkGrayColor] ,NSForegroundColorAttributeName,NSTextAlignmentRight,nil];
        [mark drawInRect:rect withAttributes:dic];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        //该方法在7.0及其以后都废弃了
        [mark drawInRect:rect withFont:[UIFont systemFontOfSize:12]];
#pragma clang diagnostic pop        
    }
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

#pragma mark - 绘制二维码图片
- (UIImage *)generateQrcodeImageWithUrlStr:(NSString *)urlStr
{
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    //NSString *urlStr = @"http://www.ychpay.com/down.html";//测试二维码地址,次二维码不能支付,需要配合服务器来二维码的地址(跟后台人员配合)
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 6. 将CIImage转换成UIImage，并放大显示 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    //    UIImage *codeImage = [UIImage imageWithCIImage:outputImage scale:1.0 orientation:UIImageOrientationUp];
    return  [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:420];//重绘二维码,使其显示清晰
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)isShowShowAlert:(NSNotification *)notifica
{
    if (_showAlert) {
        NSString * msgStr = @"是否充值成功";
        //弹窗提醒
        if (iOS7) {
            showArlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msgStr delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [showArlert show];
        } else {
            //初始化提示框
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self customPopViewController:0];                
            }]];
            
            [self presentViewController:alertController animated:true completion:nil];
        }
    }
}


#pragma mark - setters && getters
- (XRPayPassWorldView *)payPWDView{
    if (!_payPWDView) {
        _payPWDView = [[XRPayPassWorldView alloc] init];
        _payPWDView.delegate = self;
    }
    [_payPWDView.textField becomeFirstResponder];
    return _payPWDView;
}

- (IBAction)wechatSelectClicked:(id)sender {
    self.select_airpay.selected = NO;
    self.select_wechat.selected = YES;
}

- (IBAction)airPayClicked:(id)sender {
    self.select_wechat.selected = NO;
    self.select_airpay.selected = YES;
}

@end
