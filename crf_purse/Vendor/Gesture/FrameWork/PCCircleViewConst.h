
#import <Foundation/Foundation.h>


/**
 *  单个圆背景色
 */
#define CircleBackgroundColor [UIColor clearColor]



/**
 *  三角形边长
 */
#define kTrangleLength 10.0f

/**
 *  普通时连线颜色
 */
#define CircleConnectLineNormalColor rgba(34,178,246,1)


/**
 *  连线宽度
 */
#define CircleConnectLineWidth 1.0f

/**
 *  单个圆的半径
 */
#define CircleRadius 40.0f

/**
 *  单个圆的圆心
 */
#define CircleCenter CGPointMake(CircleRadius, CircleRadius)

/**
 *  空心圆圆环宽度
 */
#define CircleEdgeWidth 20.0f

/**
 *  九宫格展示infoView 单个圆的半径
 */
#define CircleInfoRadius 3

/**
 *  内部实心圆占空心圆的比例系数
 */
#define CircleRadio 0.25


/**
 *  连接的圆最少的个数
 */
#define CircleSetCountLeast 4

/**
 *  错误状态下回显的时间
 */
#define kdisplayTime 2.0f

/**
 *  绘制解锁界面准备好时，提示文字
 */
#define gestureTextBeforeSet @"为了您的账号安全，请设置手势密码"

/**
 *  设置时，连线个数少，提示文字
 */
#define gestureTextConnectLess [NSString stringWithFormat:@"最少连接%d个点，请重新绘制", CircleSetCountLeast]

/**
 *  确认图案，提示再次绘制
 */
#define gestureTextDrawAgain @"请再次绘制手势密码"

/**
 *  再次绘制不一致，提示文字
 */
#define gestureTextDrawAgainError @"与上次绘制不一致，请重新绘制"

/**
 *  设置成功
 */
#define gestureTextSetSuccess @"设置成功"

/**
 *  请输入原手势密码
 */
#define gestureTextOldGesture @"请输入原手势密码"

/**
 *  密码错误
 */
#define gestureTextGestureVerifyError @"密码错误"

