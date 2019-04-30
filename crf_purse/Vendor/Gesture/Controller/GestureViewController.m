
#import "GestureViewController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
#import "CRFAlertUtils.h"
#import "CRFGestureManager.h"

@interface GestureViewController ()<UINavigationControllerDelegate, CircleViewDelegate>

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

@property (nonatomic, assign) NSInteger errorCount;

@end

@implementation GestureViewController

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (BOOL)fd_interactivePopDisabled {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 进来先清空存的第一个密码
    [CRFUserDefaultManager saveTemporaryGesture:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(dismissSelf) name:kDismissGestureNotificationName];

    // 1.界面相同部分生成器
    [self setupSameUI];
    
    // 2.界面不同部分生成器
    [self setupDifferentUI];
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:^{
        [CRFNotificationUtils postNotificationName:kGestureErrorToLoginNotificationName];
    }];
}

#pragma mark - 界面不同部分生成器
- (void)setupDifferentUI
{
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
- (void)setupSameUI
{
    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenWidth, 14);
    msgLabel.center = CGPointMake(kScreenWidth/2, 191);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
}

#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc
{
    [self.lockView setType:CircleViewTypeSetting];
    
    
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, 42 * kWidthRatio, 42 * kWidthRatio);
    infoView.center = CGPointMake(kScreenWidth/2, 120 * kWidthRatio);
    self.infoView = infoView;
    [self.view addSubview:infoView];
    UILabel *label = [UILabel new];
    label.text = @"暂不设置";
    label.textColor = kTextEnableColor;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(@(-80 * kWidthRatio));
        make.height.mas_equalTo(14);
    }];
    label.userInteractionEnabled = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noSetting)]];
}

#pragma mark - 登陆手势密码界面
- (void)setupSubViewsLoginVc
{
    self.errorCount = 5;
    [self.lockView setType:CircleViewTypeLogin];
     [self.msgLabel showNormalMsg:@"请输入手势密码解锁"];
    // 头像
    UIImageView  *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_Default"]];
    [self.view addSubview:imageView];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 55 / 2.0;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[CRFAppManager defaultManager].userInfo.headUrl] placeholderImage:[UIImage imageNamed:@"head_Default"]];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@100);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = kCellLineSeparatorColor;
    [self.view addSubview:line];
    UILabel *modifyLabel = [UILabel new];
    [self.view addSubview:modifyLabel];
    modifyLabel.text = @"忘记手势密码";
    UILabel *verifyLabel = [UILabel new];
    [self.view addSubview:verifyLabel];
    modifyLabel.userInteractionEnabled = verifyLabel.userInteractionEnabled = YES;
    modifyLabel.font = verifyLabel.font = [UIFont systemFontOfSize:14];
    modifyLabel.textColor = verifyLabel.textColor = kTextEnableColor;
    modifyLabel.textAlignment = NSTextAlignmentRight;
    verifyLabel.text = @"使用账号登录";
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(- 81.5 * kWidthRatio));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(1, 12));
    }];
    [modifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(@(- 80 * kWidthRatio));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2 - 10, 14));
    }];
    [verifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(@(-80 * kWidthRatio));
        make.width.mas_equalTo(kScreenWidth / 2 - 10);
        make.height.mas_equalTo(14);
    }];
    [modifyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forget)]];
    [verifyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usePassword)]];
}

- (void)forget {
    [CRFAlertUtils showAlertTitle:@"忘记手势密码，可以使用账号密码登录，登录后需重新绘制手势密码" message:nil container:self cancelTitle:@"取消" confirmTitle:@"密码登录" cancelHandler:nil confirmHandler:^{
        [CRFUserDefaultManager saveFinalGesture:nil];
        [CRFUserDefaultManager setGestureErrorMaxFlag:YES];
        if (self.loginHandler) {
            self.loginHandler(self);
        }
    }];
}

- (void)usePassword {
//     [CRFUserDefaultManager saveFinalGesture:nil];
//     [CRFUserDefaultManager setGestureErrorMaxFlag:YES];
    if (self.loginHandler) {
        self.loginHandler(self);
    }
}

#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = [CRFUserDefaultManager getTemporaryGesture];

    // 看是否存在第一个密码
    if ([gestureOne length]) {
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    NSLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showRepeatMsg:gestureTextDrawAgain];
    
    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    NSLog(@"获得第二个手势密码%@",gesture);
    
    if (equal) {
        
        NSLog(@"两次手势匹配！可以进行本地化保存了");
        
        [CRFUtils showMessage:@"手势密码设置成功"];
        [CRFUserDefaultManager saveFinalGesture:gesture];
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.resultHandler) {
                self.resultHandler(YES);
            }
        }];
        
    } else {
        NSLog(@"两次手势不匹配！");
        
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        
        if (equal) {
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.resultHandler) {
                    self.resultHandler(YES);
                }
            }];
        } else {
            self.errorCount --;
            if (self.errorCount == 0) {
                [self.msgLabel showWarnMsgAndShake:@"多次错误"];
                [CRFUserDefaultManager saveFinalGesture:nil];
                [CRFAlertUtils showAlertTitle:@"温馨提示" message:@"多次输入错误，需要重新登录" container:self cancelTitle:nil confirmTitle:@"我知道了" cancelHandler:nil confirmHandler:^{
                    [self dismissViewControllerAnimated:YES completion:^{
                        if (self.resultHandler) {
                            self.resultHandler(NO);
                        }
                        [CRFUserDefaultManager setGestureErrorMaxFlag:YES];
                        [CRFNotificationUtils postNotificationName:kDismissGestureNotificationName];
                         [CRFNotificationUtils postNotificationName:kGestureErrorToLoginNotificationName];
                    }];
                }];
                return;
            }
            [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"密码错误，您还可以输入%ld次",self.errorCount]];
        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功，跳转到设置手势界面");
            
        } else {
            NSLog(@"原手势密码输入错误！");
            
        }
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

#pragma mark - UINavigationControllerDelegate

- (void)noSetting {
    [CRFAlertUtils showAlertTitle:@"设置手势密码\n可以使您的账户更安全" message:nil container:self cancelTitle:@"暂不设置" confirmTitle:@"设置" cancelHandler:^{
        [self dismissViewControllerAnimated:YES completion:^{
            [self infoViewDeselectedSubviews];
            if (self.resultHandler) {
                self.resultHandler(NO);
            }
        }];
    } confirmHandler:^{
        [self infoViewDeselectedSubviews];
        [CRFUserDefaultManager saveTemporaryGesture:nil];
        [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    }];
}

- (void)dealloc {
    [CRFNotificationUtils removeObserver:self];
}

@end
