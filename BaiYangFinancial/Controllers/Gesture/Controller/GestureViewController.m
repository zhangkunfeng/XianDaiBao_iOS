
#import "AppDelegate.h"
#import "GestureViewController.h"
#import "LoginViewController.h"
#import "PCCircle.h"
#import "PCCircleInfoView.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"

#define WdaiGestureMD5 @"weidai2015"

@interface GestureViewController () <CircleViewDelegate> {
    NSInteger count;
    NSTimer *_timer;
    PCCircleView *_lockView;
    PCLockLabel *_label;
}


/**
 *  重设按钮
 */
@property (nonatomic, strong) UIButton *resetBtn;
/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;
/**
 *  手势密码不匹配数，默认是5
 */
@property (nonatomic, assign) NSUInteger unmatchCounter;

@end

@implementation GestureViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self forbiddenSideBack];
    if (self.type == GestureViewControllerTypeLogin) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }

    //禁用手势返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // 进来先清空存的第一个密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self forbiddenSideBack];
    // Do any additional setup after loading the view.
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    if (iPhone4) {
//        [backImage setImage:[UIImage imageNamed:@"手势密码背景4s-0729.png"]];
//    } else if (iPhone5) {
//        [backImage setImage:[UIImage imageNamed:@"手势密码背景5s-0729.png"]];
//    } else if (iPhone6) {
//        [backImage setImage:[UIImage imageNamed:@"手势密码背景6－0729.png"]];
//    } else if (iPhone6_) {
//        [backImage setImage:[UIImage imageNamed:@"手势密码背景6P－0729.png"]];
//    }
    backImage.backgroundColor = AppMianColor;
//    [backImage setImage:[UIImage imageNamed:@"手势背景图"]];
    [self.view addSubview:backImage];

    // 1.界面相同部分生成器
    [self setupSameUI];
    // 2.界面不同部分生成器
    [self setupDifferentUI];
    //手势密码不匹配数，默认是5
    self.unmatchCounter = 5;
    //倒计时秒数
    count = 30;
    
    
   
}

//TODO:跳过按钮的点击事件
- (void)skipBtnClick {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

#pragma mark - 界面不同部分生成器
- (void)setupDifferentUI {
    switch (self.type) {
    case GestureViewControllerTypeSetting:
        [self setupSubViewsSettingVc];
        break;
    case GestureViewControllerTypeLogin:
        [self setupSubViewsLoginVc];
        break;
    default:
        break;
    }
}
#pragma mark - 界面相同部分生成器
- (void)setupSameUI {
    //重设按钮
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.hidden = YES;
 
    [self creatButton:resetBtn frame:CGRectMake(iPhoneWidth - 90, iPhoneHeight - 60, 45, 30) title:@"重设" alignment:UIControlContentHorizontalAlignmentRight tag:buttonTagReset];

    _lockView = [[PCCircleView alloc] init];
    _lockView.delegate = self;
    self.lockView = _lockView;
    [self.view addSubview:_lockView];

    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
//    if (iPhone4) {
//        msgLabel.center = CGPointMake(kScreenW / 2, CGRectGetMinY(_lockView.frame) - 13);
//    }else {
//        msgLabel.center = CGPointMake(kScreenW / 2, CGRectGetMinY(_lockView.frame) - 30);
//    }
    msgLabel.center = CGPointMake(kScreenW / 2, CGRectGetMinY(_lockView.frame) - (iPhone4||iPhone5?13:iPhone6?15:20));

    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
}

#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc {
    //文案-设置手势密码
    _label = [[PCLockLabel alloc] initWithFrame:CGRectMake(0, 50, kScreenW, 20)];
    _label.text = @"设置手势密码";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_label];
    
    self.resetBtn.hidden = NO;
    
    [self.lockView setType:CircleViewTypeSetting];
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    infoView.center = CGPointMake(kScreenW / 2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame) / 2 - 10);
    self.infoView = infoView;
    [self.view addSubview:infoView];
}
#pragma mark - 登陆手势密码界面
- (void)setupSubViewsLoginVc {
    [self.lockView setType:CircleViewTypeLogin];
    // 头像
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 75, 75);
    imageView.center = CGPointMake(kScreenW / 2, kScreenH / 5);
    [imageView setImage:[UIImage imageNamed:@"head@3x"]];
    [self.view addSubview:imageView];

    //描述
    if (!iPhone4) {
        UILabel * labelDescription = [[UILabel alloc] init];
        labelDescription.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame)+ (iPhone4||iPhone5?20:30), iPhoneWidth, 15);
        labelDescription.text = @"请绘制手势密码";
        labelDescription.textAlignment = NSTextAlignmentCenter;
        labelDescription.textColor = [UIColor whiteColor];
        [self.view addSubview:labelDescription];
    }
    
    // 其他方式登录
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:rightBtn frame:CGRectMake(kScreenW / 2 - CircleViewEdgeMargin - 20, kScreenH - 60, kScreenW / 2, 20) title:@"重置手势密码" alignment:UIControlContentHorizontalAlignmentRight tag:buttonTagForget];
}
#pragma mark - 创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag {
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.resetBtn = btn;
    [self.view addSubview:btn];
}
#pragma mark - button点击事件
- (void)didClickBtn:(UIButton *)sender {
    NSLog(@"%ld", (long) sender.tag);
    switch (sender.tag) {
    case buttonTagReset: {
        NSLog(@"点击了重设按钮");
        [_label showNormalMsg:@"设置手势密码"];
        // 1.隐藏按钮
//        [self.resetBtn setHidden:YES];
        [self.resetBtn setHidden:NO];
        // 2.infoView取消选中
        [self infoViewDeselectedSubviews];
        // 3.msgLabel提示文字复位
        [self.msgLabel showNormalMsg:gestureTextBeforeSet];
        // 4.清除之前存储的密码
        [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
    } break;
    case buttonTagForget: {
        removeObjectFromUserDefaults(UID);
        removeObjectFromUserDefaults(SID);
        removeObjectFromUserDefaults(gestureFinalSaveKey);
        removeObjectFromUserDefaults(InviteCode);
        LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginView.pushviewNumber = 10086;
        loginView.iPhoneNumberString = getObjectFromUserDefaults(MOBILE);
        [self customPushViewController:loginView customNum:0];
    } break;
    default:
        break;
    }
}

#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture {
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];

    // 看是否存在第一个密码
    if ([gestureOne length]) {
        [self.resetBtn setHidden:NO];
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture {
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
    [_label showNormalMsg:@"再次设置密码"];
    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}
//登录后设置第二次手势密码
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal {
    NSString *MD5GestureString = [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@", [WDEncrypt md5FromString:gesture], WdaiGestureMD5]];
    if (equal) {
        //两次手势匹配！可以进行本地化保存了
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        [PCCircleViewConst saveGesture:MD5GestureString Key:gestureFinalSaveKey];
        //注册后设置完手势密码后发通知
        if (self.isShowPupopView) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GOTOPRODUCTLIST object:nil];
        }
        if (self.isSettingGesture) {
            self.openGesture(YES);
        }
        
        if (!self.isShowPupopView) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:RefreshHomeView object:@"手势完成后加载系统通知"];//手势完成后刷新首页
            });
        }
        
        [self customPopViewController:1];
        
    } else {
        //两次手势不匹配
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        [self.resetBtn setHidden:NO];
    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal {
    NSString *MD5GestureString = [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@", [WDEncrypt md5FromString:gesture], WdaiGestureMD5]];
    NSString *circleMd5 = [WDEncrypt md5FromString:[NSString stringWithFormat:@"%@%@", [WDEncrypt md5FromString:[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey]], WdaiGestureMD5]];
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        if (equal && [circleMd5 isEqualToString:MD5GestureString]) {
            self.appDelegateGoback(YES);//验证手势密码(登录)仅一次  block内置个推跳转及通知刷新
            [self customPopViewController:0];//3跳转到最底层 原
        } else {
            self.unmatchCounter--;
            if (self.unmatchCounter == 0) {
                _lockView.userInteractionEnabled = NO;
                [self.msgLabel showWarnMsgAndShake:@"30s 后请重新输入"];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
            } else {
                [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"密码错误,还有 %zd 次机会", self.unmatchCounter]];
            }
        }
    } else if (type == CircleViewTypeVerify) {

        if (equal) {
            NSLog(@"验证成功，跳转到设置手势界面");

        } else {
            NSLog(@"原手势密码输入错误！");
        }
    }
}
//定时器执行方法
- (void)timer {
    count--;
    if (count == 0) {
        [_timer invalidate];
        //手势密码不匹配数，默认是5
        self.unmatchCounter = 5;
        //倒计时秒数
        count = 30;
        _lockView.userInteractionEnabled = YES;
        [self.msgLabel showNormalMsg:@""];
    } else {
        [self.msgLabel showWarnMsg:[NSString stringWithFormat:@" %zd s 后请重新输入", count]];
        _lockView.userInteractionEnabled = NO;
    }
}
#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView {
    for (PCCircle *circle in circleView.subviews) {

        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {

            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}
#pragma mark - 让infoView对应按钮取消选中
- (void)infoViewDeselectedSubviews {
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}

@end
