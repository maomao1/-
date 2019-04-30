
#import "CRFBasicViewController.h"

typedef enum{
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeLogin   = 2
}GestureViewControllerType;

typedef enum{
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
    
}buttonTag;

@interface GestureViewController : CRFBasicViewController

/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;

@property (nonatomic, copy) void (^(resultHandler))(BOOL result);

@property (nonatomic, copy) void (^(loginHandler))(GestureViewController *targetController);

@end
