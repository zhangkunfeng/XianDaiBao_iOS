//
//  InviteFrinendsViewController.m
//  xrtz
//
//  Created by 无名小子 on 15/11/16.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "BindingBankCardViewController.h"
#import "CustomMadeNavigationControllerView.h"
#import "CustomShareView.h"
#import "InviteFrinendsViewController.h"

#import "InviteFriendsController.h"

@interface InviteFrinendsViewController () <CustomUINavBarDelegate, CustomShareViewDelegte, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *ContentButton;
@property (weak, nonatomic) IBOutlet UIButton *BottomShareButton;
@property (weak, nonatomic) IBOutlet UIImageView *QrcodeImageView;
- (IBAction)InviteFrindsShareButtonAction:(id)sender;

@property (strong, nonatomic) CustomShareView *shareView;

@end

@implementation InviteFrinendsViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_shareView) {
        [_shareView removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CustomMadeNavigationControllerView *InviteFrinendsView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"邀请好友送红包" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:nil];
    [self.view addSubview:InviteFrinendsView];

    //按钮添加下划线
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"立即分享，拿现金红包>"];
    NSRange strRange = {0, [str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    _BottomShareButton.titleLabel.textColor = [self colorFromHexRGB:@"EF5650"];
    [_BottomShareButton setAttributedTitle:str forState:UIControlStateNormal];

    if ([self isLegalObject:[self getLocalUserinfoDict]]) {
        [self errorHide];
        [self setCodeImage];
    } else {
        [self getShareInfo];
    }
}

- (void)goBack {
    [self customPopViewController:0];
}

- (void)getShareInfo {
    NSDictionary *parameters = @{ @"uid": getObjectFromUserDefaults(UID),
                                  @"at": getObjectFromUserDefaults(ACCESSTOKEN) };
    [_activityIndicatorView startAnimating];
    _activityIndicatorView.hidden = NO;
    self.ContentButton.enabled = NO;
    self.BottomShareButton.enabled = NO;
    WS(weakSelf);
    [AFNetworkTool postJSONWithUrl:[NSString stringWithFormat:@"%@phone/shareUrl", GeneralWebsite] parameters:parameters success:^(id responseObject) {
        if ([self isLegalObject:responseObject[@"r"]]) {
            if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [self errorHide];
                [self userDefaultsKeyForDictionary:(NSDictionary *) [responseObject[@"item"] copy] defaultsKey:InviteCode];
                [weakSelf setCodeImage];
            } else if ([responseObject[@"r"] isEqualToString:verificationOK]) {
                [[WDQueryAccessToken sharedInstance] queryAccessTokenWithSuccessBlock:^(id responseObj) {
                    [weakSelf getShareInfo];
        } withFailureBlock:^{
            
        }];
            } else if ([responseObject[@"r"] isEqualToString:@"-9"]) {
                [self errorHide];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请先绑定银行卡" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上绑卡", nil];
                [alertView show];
            } else {
                [self errorHide];
            }
        }
    }
        fail:^{
            [self errorHide];
        }];
}

#pragma mark - UIAlertViewDelegate
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

- (IBAction)InviteFrindsShareButtonAction:(id)sender {
    if ([self isLegalObject:[self getLocalUserinfoDict]]) {
        if (!_shareView) {
            _shareView = [[CustomShareView alloc] initWithViewController:self shareDict:[self getLocalUserinfoDict] CustomShareViewDeleagte:self];
        }
        [self showPopupWithStyle:CNPPopupStyleActionSheet popupView:_shareView];
    } else {
        [self getShareInfo];
    }
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
    self.BottomShareButton.enabled = YES;
}

@end
