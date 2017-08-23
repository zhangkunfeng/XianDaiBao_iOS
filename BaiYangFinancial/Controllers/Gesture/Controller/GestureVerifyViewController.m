
#import "GestureVerifyViewController.h"
#import "GestureViewController.h"
#import "PCCircle.h"
#import "PCCircleInfoView.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"

@interface GestureVerifyViewController () <CircleViewDelegate> {
    NSInteger count;
    PCCircleView *_lockView;
    NSTimer *_timer;
}

/**
 *  文字提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;
/**
 *  手势密码不匹配数，默认是5
 */
@property (nonatomic, assign) NSUInteger unmatchCounter;

@end

@implementation GestureVerifyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
//        backImage.backgroundColor = [UIColor redColor];
//        if (iPhone4) {
//            [backImage setImage:[UIImage imageNamed:@"手势密码背景4s-0729.png"]];
//        } else if (iPhone5) {
//            [backImage setImage:[UIImage imageNamed:@"手势密码背景5s-0729.png"]];
//        } else if (iPhone6) {
//            [backImage setImage:[UIImage imageNamed:@"手势密码背景6－0729.png"]];
//        } else if (iPhone6_) {
//            [backImage setImage:[UIImage imageNamed:@"手势密码背景6P－0729.png"]];
//        }
//         [backImage setImage:[UIImage imageNamed:@"手势背景图"]];
        backImage.backgroundColor = AppMianColor;
        [self.view addSubview:backImage];
        [self.view sendSubviewToBack:backImage];

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"验证手势解锁";

    _lockView = [[PCCircleView alloc] init];
    _lockView.delegate = self;
    [_lockView setType:CircleViewTypeVerify];
    [self.view addSubview:_lockView];

    UIButton *cacelButton = [[UIButton alloc] initWithFrame:CGRectMake(iPhoneWidth - 90, iPhoneHeight - 60, 45, 30)];
    [cacelButton setTitle:@"取消" forState:UIControlStateNormal];
    cacelButton.backgroundColor = [UIColor clearColor];
    [cacelButton addTarget:self action:@selector(cancelBotton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cacelButton];

    //文案-验证手势密码
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kScreenW, 20)];
    label.text = @"关闭手势密码";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];

    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW / 2, CGRectGetMinY(_lockView.frame) - 30);
    [msgLabel showNormalMsg:gestureTextOldGesture];
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
                                                                                                                      
    //手势密码不匹配数，默认是5
    self.unmatchCounter = 5;

    //倒计时秒数
    count = 30;
}

- (void)cancelBotton {
    self.closeGesture(NO);
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
#pragma mark - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal {
    if (type == CircleViewTypeVerify) {
        if (equal) {
            [self dismissViewControllerAnimated:YES completion:^{
                self.closeGesture(YES);
                [PCCircleViewConst removeLocaGestureWithKey:gestureFinalSaveKey];
            }];
        } else {
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
            self.unmatchCounter--;
            if (self.unmatchCounter == 0) {
                _lockView.userInteractionEnabled = NO;
                [self.msgLabel showWarnMsgAndShake:@"30s 后请重新输入"];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
            } else {
                [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"密码错误,还有 %zd 次机会", self.unmatchCounter]];
            }
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
        [self.msgLabel showNormalMsg:gestureTextOldGesture];
    } else {
        [self.msgLabel showWarnMsg:[NSString stringWithFormat:@" %zd s 后请重新输入", count]];
        _lockView.userInteractionEnabled = NO;
    }
}

@end
