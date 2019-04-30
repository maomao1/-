//
//  CRFInvestdetailCell.h
//  crf_purse
//
//  Created by maomao on 2017/8/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

static NSString *const CRFINVEST_COLLECTION_CELL_ID  = @"invest_collection_cellId";

typedef NS_ENUM(NSInteger, goBackType) {
    Close           = 0,
    GoBack          = 1,
    Warning         = 2,
};

typedef NS_ENUM(NSInteger, ErrorType) {
    Show_Error_Alert        = 0,
    Show_Error_Toast        = 1,
    Show_Default_Alert      = 2,
    Show_Error_RefreshToken = 3,
    Show_Pop                = 4,
};

typedef void (^cellWebBlock) (NSString *webTitle,BOOL isCanGoBack);
@interface CRFInvestdetailCell : UICollectionViewCell<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy)  NSString   *urlString;
@property (nonatomic,copy) cellWebBlock webTitleBlock;

@property (nonatomic, copy) void (^(gotoLoginAndCreateAccount))(void);
@property (nonatomic, copy) void (^(webViewCanGoBack))(goBackType type);
//@property (nonatomic,strong) UIButton   *investBtn;
- (void)loadWebViewWithUrl:(NSString*)urlStr;


@property (nonatomic, copy) void (^(showErrorForWebView))(ErrorType errorType, NSString *message);

@end
