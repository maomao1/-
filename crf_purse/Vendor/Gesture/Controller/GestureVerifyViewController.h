
#import "CRFBasicViewController.h"

typedef NS_ENUM(NSInteger, GestureVerifyType) {
    //设置密码
    GestureVerifyTypeClose          = 0,
    //验证并设置新密码
    GestureVerifyTypeSettingNew     = 1,
    //验证并关闭密码
    GestureVerifyTypeLogin
};

@interface GestureVerifyViewController : CRFBasicViewController

@property (nonatomic, assign) GestureVerifyType type;

@property (nonatomic, copy) void (^(resultHandler))(void);

@end
