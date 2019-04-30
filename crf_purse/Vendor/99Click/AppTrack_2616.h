#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WKWebView.h>
#import "sqlite3.h"

//监测请求的发送URL,由JAVA替换，然后重新编译SDK后，提供给客户
#define _VIEW_URL_			@"https://s.oadz.com/acnt;A1;2616;*;3ThhUp+SFG6DX8YfCmg7J4tsMng=;1;"
#define _CLICK_URL_			@"https://s.oadz.com/ajcnt;A1;2616;*;bJOIc3BUI62p1S7LGjIRtK1k5+g=;1;"
#define _EVENT_URL_			@"https://s.oadz.com/aevent;E1;2616;*;eaFtx6BRqwrwMzDvtVBXlGIEp4c=;1;"
#define _ERROR_URL_			@"https://s.oadz.com/aerr;A1;2616;*;vo51ZE33EN8CU+o9We6BvkSGlSE=;1;"
#define _RECOMMEND_URL		@"https://sp.oadz.com/arec;C1;2616;*;DnWwfJ4kk4UO7+kB/0DmkOUjsWY=;1;"


@interface RecoResult : NSObject {
	// 获取推荐列表需要传入的参数
	int recoType;						// 推荐类型
	int recoProdNum;					// 推荐产品返回个数
	NSString *ozuid;					// 个性化推荐会员ID
	NSMutableArray *prodIds; 			// 需要获取推荐列表的产品ID数组
	
	// 执行方法获取推荐列表后的返回值
	int serverStatus;					// 服务器连接正常，返回值为1，服务器连接不正常，返回值为0
	int recoStatus;						// 表示返回推荐产品状态，1：存在；0：不存在
	NSMutableArray *recoProdResultList;	// prodIds中每个产品及其推荐产品列表的数组，元素类型为：RecoProduct
}
@property (nonatomic) int recoType, recoProdNum, serverStatus, recoStatus;
@property (nonatomic, retain) NSString *ozuid;
@property (nonatomic, retain) NSMutableArray *prodIds, *recoProdResultList;
@end


@interface RecoProduct : NSObject {
	// 需要获取推荐列表的产品ID
	NSString *prodId;
	// 服务器返回的prodId对应的推介列表。
	NSMutableArray *recoProdList;
}
@property (nonatomic, retain) NSString *prodId;
@property (nonatomic, retain) NSMutableArray *recoProdList;
@end


@interface UIView (SZCustomUIView)
-(void) setSZObjName: (NSString *) viewName;
-(NSString *) getSZObjName;
@end



@interface AppTrack : NSObject

/*
 *	功能：是否显示SDK日志，参数设置为TRUE表示显示日志，默认为FALSE
 **/
+(void) setShowLog: (bool) isLogShow;


/*
 *	功能：启用苹果推送功能。
 **/
+ (void) startAppPushMsg;

/*
 *		去往苹果服务器注册推送功能，需要已经在developer.apple.com的Identifiers下该App对应的AppId
 *	开启推送功能，才能获取到下一步的推送deviceToken。
 **/
+ (void) registerForRemoteNotifications;

/*
 *		功能同上，支持Ios8.0以上的UIMutableUserNotificationAction功能。需要自己生成UIMutableUserNotificationCategory
 *	作为参数传入。
 **/
+ (void) registerForRemoteNotifications: (NSSet *)categories;

/*
 *		在AppDelegate的didRegisterForRemoteNotificationsWithDeviceToken方法中调用，将苹果服务器返回
 *	的deviceToken回传给商助推送服务器，用户以后推送消息到该设备。
 **/
+ (void) registerDeviceToken: (NSData *) deviceToken;


+ (void) countAppPush: (NSDictionary *)userInfo;

/**
 * 功能：根据openUrl判定是否启用可视化定制
 */
+(void) setVisualState: (NSURL *) openUrl;

+(void) enableAutoMonitorPV;

/**
 * 功能：当该ViewController实现了motionEnded，方法中手动调用该方法
 */
+(void) webVisualCustom;

/*
 * 功能：忽略该ViewController上的自动PV监测
 */
+(void) ignoreAutoViewOnViewController: (UIViewController *) controller;

/*
 * 功能：设置UIViewController在自动监测中对应的Topic
 */
+(void) setViewController: (NSObject *) controller withTopic: (NSString *) topic;

/*
 * 功能：设置UIViewController在自动监测中对应的Ttile
 */
+(void) setViewController: (NSObject *) controller withTitle: (NSString *) title;

/*
 * 功能：设置UIViewController在自动监测中对应的OzprmDictionary
 *		controller参数可以传入NSString，表示ViewController的类名，也可以直接传入ViewController实例
 */
+(void) setViewController: (NSObject *) controller withOzprmDictionary: (NSDictionary *) ozprmDictionary NS_DEPRECATED_IOS(2_0, 5_0);;

/*
 * 功能：是否保存日志请求的状态
 */
+(void) setStoreRequest: (bool) isRequestStore;
+(void) printStoredRequest;

/*
 *	功能：
 *		1、查看Url中是否有ozaid参数，若有，相当于使用参数值调用setOzaid函数
 **/
+(void) setOpenUrl: (NSString *) openUrl;

/*
 *	功能：
 *		设置IDFA作为设备用户，设置该值后，SiteApp系统改为使用该值统计用户数据。
 *		必须在调用countOpen方法之前执行该方法，多次执行以第一次为准
 **/
+(void) setIDFA: (NSString *) idfa;

/*
 *	功能：设置APP的版本，参数格式如："BaiduMap 4.2"
 **/
+(void) setOzAppVer: (NSString *) version;

/*
 *	功能：设置APP的渠道，参数格式如："Baidu"
 **/
+(void) setOzChannel: (NSString *) channel;

/*
 *	功能：设置APP的触发来源
 *		source格式如："JDPay"
 **/
+(void) setOzSource: (NSString *) source;

/*
 *	功能：设置App的渠道广告ID，建议使用英文字母和数字，最大不超过40。如使用汉字，最多不超过15个。
 *		ozaid格式如：AdPosition1
 **/
+(void) setOzaid: (NSString *) ozaid;

/*
 *	功能：设置App使用者的注册用户ID，建议使用英文字母和数字，最大不超过40。如使用汉字，最多不超过15个。
 **/
+(void) setOzsru: (NSString *) ozsru;

/*
 *	功能：清除App使用者的注册用户ID。
 **/
+(void) clearOzsru;

/*
 *	功能：设置单个系统扩展参数KV
 *		key格式如：	"author"
 *		value格式如：	"DEV Team A"
 **/
+(void) setOzSysParamKV: (NSString *) key andValue: (NSString *) value;

/*
 *	功能：设置APP订单中一个产品的属性，内容为属性的“name-value”对，name需要和系统设置或提供的一致
 **/
+(void) setSku : (NSDictionary *) skuAttrDictionary;

/*
 *	功能：设置APP中一个订单的属性，参数内容为属性的“name-value”对，name需要和系统设置或提供的一致
 **/
+(void) setOrder : (NSDictionary *) orderAttrDictionary;

/*
 *	功能：初始化需要监测的UIWebView，参数为需要监测其加载网页的UIWebView对象
 **/
+(void) initUIWebView: (UIWebView *) webView;

/*
 *	功能：UIWebView加载页面监测
 *		参数：
 *			webView：		需要监测其加载网页的UIWebView对象
 *			request：		页面需要加载的NSURLRequest对象，包含URL
 **/
+(BOOL) countWebEvent: (UIWebView *) webView
		   andRequest: (NSURLRequest *)request;

/*
 *	功能：初始化需要监测的WKWebView，参数为需要监测其加载网页的WKWebView对象
 **/
+(void) initWKWebView: (WKWebView *) webView;


/*
 * 	功能：获取产品的推荐列表
 * 	参数：
 * 		recoResult：		服务器返回的推荐列表：调用前需要设置recoType、recoProdNum、prodIds、ozuid等属性
 */
+(void) initRecoProducts: (RecoResult *) recoResult;

/*
 *	功能：用来精确分析启动次数和使用时长
 **/

+(void) setOpenIntervalSecond: (int) seconds;

+(void) applicationDidBecomeActive;

+(void) applicationDidEnterBackground;

/*
 *	功能：统计启动次数
 **/
+(void) countAppOpen;

/*
 *	功能：页面浏览监测
 *		参数：
 *			pageTopic：		监测页面的页面主题
 *			ozprmDictionary：监测页面的自定义参数，参数名作为key，参数值作为value，组成一个Dictionary传入SDK。
 **/
+(void) countView: (NSString *) pageTopic;

+(void) countView: (NSString *) pageTopic
	 andPageOzprm: (NSDictionary *) ozprmDictionary;

/*
 *	功能：点击点击监测
 *		参数：
 *			pageTopic：		点击对象所在的页面主题
 *			clkObjName：		点击对象名称
 *			ozprmDictionary：监测页面的自定义参数，参数名作为key，参数值作为value，组成一个Dictionary传入SDK。
 **/
+(void) countClick: (NSString *) pageTopic
	 andClkObjName: (NSString *) clkObjName;

+(void) countClick: (NSString *) pageTopic
	 andClkObjName: (NSString *) clkObjName
	  andPageOzprm: (NSDictionary *) ozprmDictionary NS_DEPRECATED_IOS(3_0, 3_0, "Use -[Apptrack countEvent: andEventPrm:] instead") __TVOS_PROHIBITED;

/*
 *	功能：事件监测
 *		参数：
 *			eventTopic：		事件主题，需要匹配系统定制的事件内容
 *			eventPrm：		事件参数KV，Key需要匹配系统定制的事件参数名或者系统默认提供的参数名
 **/
+(void) countEvent: (NSString *) eventTopic
	   andEventPrm: (NSDictionary *) eventPrm;

/*
 *	功能：点击监测
 *		参数：
 *			pageTopic：		点击对象所在的页面主题
 *			clkObjName：		点击对象名称
 **/
void countError(NSException* exception);

@end


@interface AppTrack (Deprecated_Methods)

/*
 *	功能：设置APP的系统扩展参数，格式如："appname=shangzhu&appauthor=team A"
 **/
+(void) setOzSysPara : (NSString *) syspara NS_DEPRECATED_IOS(3_0, 8_0, "Use -[AppTrack countView:andPageOzprm:] instead") __TVOS_PROHIBITED;

/*
 *	功能：页面浏览监测
 *		参数：
 *			pageTopic：		监测页面的页面主题
 *			pageTitle：		监测页面的页面Title，在新方法中使用Dictionary：[dictionary setObject: pageTitle forKey: "oatitle"]
 *			pageOzprm：		页面客户自定义参数，格式如"search=351&ozsru=member20141211"
 **/
+(void) countView: (NSString *) pageTopic
	 andPageTitle: (NSString *) pageTitle
	 andPageOzprm: (NSString *) pageOzprm NS_DEPRECATED_IOS(3_0, 8_0, "Use -[AppTrack countView:andPageOzprm:] instead") __TVOS_PROHIBITED;

/*
 *	功能：点击点击监测
 *		参数：
 *			pageTopic：		点击对象所在的页面主题
 *			pageTitle：		点击对象所在的页面Title，在新方法中使用Dictionary：[dictionary setObject: pageTitle forKey: "oatitle"];
 *			clkObjName：		点击对象名称
 *			pageOzprm：		页面客户自定义参数，格式如"search=351&ozsru=member20141211"
 **/
+(void) countClick: (NSString *) pageTopic
	  andPageTitle: (NSString *) pageTitle
	  andPageOzprm: (NSString *) pageOzprm
	 andClkObjName: (NSString *) clkObjName
	 andClickOzprm: (NSString *) clickOzprm NS_DEPRECATED_IOS(3_0, 3_0, "Use -[Apptrack countClick:andClkObjName:andPageOzprm:] instead") __TVOS_PROHIBITED;

@end

