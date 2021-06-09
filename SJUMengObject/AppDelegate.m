//
//  AppDelegate.m
//  SJUMengObject
//
//  Created by deli on 2021/5/27.
//

#import "AppDelegate.h"
#include <arpa/inet.h>

#import "UMSocialSinaHandler.h"
#import "WXApi.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define kUniversalLink @"通用链接"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UMConfigure initWithAppkey:@"60af0fbbbb989470aec15702" channel:@"App Store"];
    [self configUSharePlatforms];
    //设置秘钥
    NSString*info =@"M47KReIDHhRi5hqq0EpI8EAdP14BwGEjPGEZ8FzLzDCTLfV3NQjFchWi9mp15c7bLgCLvL6i24iXXyW7mp/+Al3UlycSAlb7XM7vuJiZ4W4GemmYhvs1jtv+swAH0szVpy6Hg934ZCcMr+PiKXxVdepzhiq+2D/w4nP2/zLHfdaCP3f5HMKReoK4EKs5hQBr3r1vO55zwknO5+FtBW+puSTqw96Zc2QGZ/xhzooooTd53kql6qHtAVfaIWDA35fc3uO71CE8+zFn7zeNCaMMeQ==";
    [UMCommonHandler setVerifySDKInfo:info complete:^(NSDictionary*_Nonnull
      resultDic){
    }];
    
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];//设置打开日志，发布时设置为NO
    
    // Push功能配置
    UMessageRegisterEntity* entity =[[UMessageRegisterEntity alloc] init];
     entity.types =UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
//    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
//    if(([[[UIDevice currentDevice] systemVersion]intValue]>=8)&&([[[UIDevice currentDevice] systemVersion]intValue]<10)){
//        UIMutableUserNotificationAction*action1 =[[UIMutableUserNotificationAction alloc] init];
//        action1.identifier =@"action1_identifier";
//        action1.title=@"打开应用";
//        action1.activationMode =UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//
//        UIMutableUserNotificationAction*action2 =[[UIMutableUserNotificationAction alloc] init];//第二按钮
//        action2.identifier =@"action2_identifier";
//        action2.title=@"忽略";
//        action2.activationMode =UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action2.destructive = YES;
//        UIMutableUserNotificationCategory*actionCategory1 =[[UIMutableUserNotificationCategory alloc] init];
//                actionCategory1.identifier =@"category1";//这组动作的唯一标示
//        [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
//        NSSet*categories =[NSSet setWithObjects:actionCategory1,nil];
//        entity.categories=categories;
//    }
//    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
//    if([[[UIDevice currentDevice] systemVersion]intValue]>=10){
//        UNNotificationAction*action1_ios10 =[UNNotificationAction actionWithIdentifier:@"action1_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
//        UNNotificationAction*action2_ios10 =[UNNotificationAction actionWithIdentifier:@"action2_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
//
//        //UNNotificationCategoryOptionNone
//        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
//        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
//        UNNotificationCategory*category1_ios10 =[UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
//        NSSet*categories =[NSSet setWithObjects:category1_ios10,nil];
//         entity.categories=categories;
//    }

    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted,NSError*_Nullable error){
        if(granted){
        }else{
        }
    }];
    
    return YES;
}

#pragma mark - 设置分享
- (void)configUSharePlatforms{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];

    /* 设置分享到QQ互联的appID
         * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
        */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106271196"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes =(const unsigned*)[deviceToken bytes];
    NSString*hexToken =[NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken:%@",hexToken);
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    //传入的devicetoken是系统回调didRegisterForRemoteNotificationsWithDeviceToken的入参，切记
    //[UMessage registerDeviceToken:deviceToken];
}

//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter*)center willPresentNotification:(UNNotification*)notification withCompletionHandler:(void(^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary* userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];

    }else{
    //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter*)center didReceiveNotificationResponse:(UNNotificationResponse*)response withCompletionHandler:(void(^)(void))completionHandler{
    NSDictionary* userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication*)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
//6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result =[[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if(!result){
    // 其他如支付等SDK的回调
    }
    return result;
}

-(BOOL)application:(UIApplication*)application handleOpenURL:(NSURL *)url{
    BOOL result =[[UMSocialManager defaultManager] handleOpenURL:url];
    if(!result){
    // 其他如支付等SDK的回调
        
    }
    return result;
}

//- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
//
//    return YES;
//}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    NSString *activityTypeStr = userActivity.activityType;
    if ([activityTypeStr isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
        if ([url.host isEqualToString:kUniversalLink]) {
            //此处写iOS13后分享或支付
//         return [WXApi handleOpenUniversalLink:userActivity delegate:[WXApiManager sharedManager]];
            //打开对应页面
        } else {
           [[UIApplication sharedApplication] openURL:url];
        }
    }
 return YES;
}
@end
