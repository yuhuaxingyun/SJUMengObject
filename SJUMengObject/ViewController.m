//
//  ViewController.m
//  SJUMengObject
//
//  Created by deli on 2021/5/27.
//

#import "ViewController.h"
#import "SJUMManger.h"
#import "SJShareView.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "WXApi.h"
#import "SJNextPageViewController.h"

@interface ViewController ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic,strong) UIButton *oneLoginBtn;
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UILabel *thirdPartyLoginLabel;
@property (nonatomic,strong) UIButton *qqLoginButton;
@property (nonatomic,strong) UIButton *weChatLoginButton;
@property (nonatomic,strong) ASAuthorizationAppleIDButton *appleLoginButton;
@property (nonatomic,strong) UIImageView *multipleImageView;
@property (nonatomic,strong) UIButton *jumitButton;

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //添加页面统计
    [self beginLogPageView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //结束页面统计
    [self endLogPageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.oneLoginBtn];
    [self.view addSubview:self.shareBtn];
    [self.view addSubview:self.thirdPartyLoginLabel];
    [self thirdPartyLogin];
//    [self.view addSubview:self.multipleImageView];
    [self.view addSubview:self.jumitButton];
}

- (void)thirdPartyLogin{
    [self.view addSubview:self.qqLoginButton];
    [self.view addSubview:self.weChatLoginButton];
    if ([WXApi isWXAppInstalled]){
        self.qqLoginButton.frame = CGRectMake((ScreenWidth - 160)/4, 350, 80, 80);
        self.weChatLoginButton.frame = CGRectMake(3*(ScreenWidth - 160)/4 + 80, 350, 80, 80);
    }else{
        self.weChatLoginButton.frame = CGRectMake((ScreenWidth - 80)/2, 350, 80, 80);
    }

    if (@available(iOS 13.0, *)) {
        [self.view addSubview:self.appleLoginButton];
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - Event
- (void)oneLoginBtnClick{
    //检查环境
    [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^
    (NSDictionary*_Nullable resultDic){
        //判断检查环境是否成功
        if ([resultDic[@"resultCode"] integerValue] == 600000) {
            [self callPage];
        }
    }];
}

- (void)appleLoginClick{
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 用户授权请求的联系信息
        appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    } else {
        NSLog(@"该系统版本不可用Apple登录");
    }
}

- (void)shareBtnClick:(UIButton *)btn{
    [SJShareView showMoreWithTitle:@[@"新浪微博",@"微信好友",@"朋友圈",@"微信收藏",@"QQ好友",@"QQ空间",@"复制链接"] imgNameArray:@[@"share_icon_circle",@"share_icon_QQ",@"share_icon_wechat",@"share_icon_circle",@"share_icon_QQ",@"share_icon_Qzone",@"share_icon_copy"] blockTapAction:^(NSInteger index) {
            UMSocialPlatformType platformType = UMSocialPlatformType_UnKnown;
            switch (index) {
                case 0:
                    platformType = UMSocialPlatformType_Sina;
                    break;
                case 1:
                    platformType = UMSocialPlatformType_WechatSession;
                    break;
                case 2:
                    platformType = UMSocialPlatformType_WechatTimeLine;
                    break;
                case 3:
                    platformType = UMSocialPlatformType_WechatFavorite;
                    break;
                case 4:
                    platformType = UMSocialPlatformType_QQ;
                    break;
                case 5:
                    platformType = UMSocialPlatformType_Qzone;
                    break;
        
                default:
                    break;
            }
            [[SJUMManger shareManger] shareTextToPlatformType:platformType];
    }];
}

- (void)thirdPartyLoginClick:(UIButton *)btn{
    UMSocialPlatformType platformType = UMSocialPlatformType_UnKnown;
    switch (btn.tag) {
        case 0:
            platformType = UMSocialPlatformType_Sina;
            break;
        case 1:
            platformType = UMSocialPlatformType_WechatSession;
            break;
        case 2:
            platformType = UMSocialPlatformType_WechatTimeLine;
            break;
        case 3:
            platformType = UMSocialPlatformType_WechatFavorite;
            break;
        case 4:
            platformType = UMSocialPlatformType_QQ;
            break;
        case 5:
            platformType = UMSocialPlatformType_Qzone;
            break;
            
        default:
            break;
    }
    [[SJUMManger shareManger] getUserInfoForPlatform:platformType];
}

- (void)jumitButtonClick{
    SJNextPageViewController *nextPageVC = [[SJNextPageViewController alloc]init];
    [self presentViewController:nextPageVC animated:YES completion:nil];
}

- (void)callPage{
    __weak typeof(*&self) weakSelf = self;
    NSTimeInterval timeout = 3.0f;
    //1. 调⽤用取号接⼝，加速授权⻚的弹起
    [UMCommonHandler accelerateLoginPageWithTimeout:timeout complete:^(NSDictionary * _Nonnull resultDic) {
        //设置样式
        UMCustomModel*model =nil;//设置moddel，不设置为默认
        //2.调⽤用唤起授权⻚面
        [UMCommonHandler getLoginTokenWithTimeout:timeout controller:weakSelf model:model complete:^(NSDictionary * _Nonnull resultDic) {
            NSString*code =[resultDic objectForKey:@"resultCode"];
            if([PNSCodeLoginControllerPresentSuccess isEqualToString:code]){
            //弹起授权⻚成功
            }else if([PNSCodeLoginControllerClickCancel isEqualToString:code]){
            //点击了授权页的返回
            }else if([PNSCodeLoginControllerClickChangeBtn isEqualToString:code]){
            //点击切换其他登录⽅式按钮
            }else if([PNSCodeLoginControllerClickLoginBtn isEqualToString:code]){
                if([[resultDic objectForKey:@"isChecked"] boolValue]== YES){
                    //点击了登录按钮，check box选中，SDK内部接着会去获取登陆Token
                }else{
                    //点击了登录按钮，check box选中，SDK内部不会去获取登陆Token
                }
            }else if([PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:code]){
            //点击check box
            }else if([PNSCodeLoginControllerClickProtocol isEqualToString:code]){
                //点击了协议富⽂本
//                [ProgressHUD showSuccess:@"点击了协议富文本"];
            }else if([PNSCodeSuccess isEqualToString:code]){
                //点击登录按钮获取登录Token成功回调
//                NSString*token =[resultDic objectForKey:@"token"];
                //拿Token去服务器器换⼿机号
            }else{
            //获取登录Token失败
            }
        }];
    }];

}

#pragma mark - ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *user = appleIDCredential.user;
        // 使用过授权的，可能获取不到以下三个参数
        NSString *familyName = appleIDCredential.fullName.familyName;
        NSString *givenName = appleIDCredential.fullName.givenName;
        NSString *email = appleIDCredential.email;
        
        } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
            // 用户登录使用现有的密码凭证（iCloud记录的）
            ASPasswordCredential *passwordCredential = authorization.credential;
            // 密码凭证对象的用户标识 用户的唯一标识
            NSString *user = passwordCredential.user;
            // 密码凭证对象的密码
            NSString *password = passwordCredential.password;
            
        } else {
            NSLog(@"授权信息均不符");
        }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
            
        default:
            break;
    }
    NSLog(@"%@", errorMsg);
}

#pragma mark - getter
- (UIButton *)oneLoginBtn{
    if (!_oneLoginBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((ScreenWidth - 200)/2, 100, 200, 50);
        [btn setTitle:@"一键登录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor purpleColor];
        [btn addTarget:self action:@selector(oneLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _oneLoginBtn = btn;
    }
    return _oneLoginBtn;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((ScreenWidth - 200)/2, 200, 200, 50);
        [btn setTitle:@"分享" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor purpleColor];
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn = btn;
    }
    return _shareBtn;
}

- (UILabel *)thirdPartyLoginLabel{
    if (!_thirdPartyLoginLabel) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - 200)/2, 300, 200, 20)];
        label.text = @"------    第三方登录    ------";
        label.textColor = [UIColor grayColor];
        _thirdPartyLoginLabel = label;
    }
    return _thirdPartyLoginLabel;
}

- (UIButton *)qqLoginButton{
    if (!_qqLoginButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"QQ登录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor purpleColor];
        [btn addTarget:self action:@selector(thirdPartyLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 40;
        btn.tag = 4;
        _qqLoginButton = btn;
    }
    return _qqLoginButton;
}

- (UIButton *)weChatLoginButton{
    if (!_weChatLoginButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"微信登录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor purpleColor];
        [btn addTarget:self action:@selector(thirdPartyLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 40;
        btn.tag = 1;
        _weChatLoginButton = btn;
    }
    return _weChatLoginButton;
}

- (UIButton *)jumitButton{
    if (!_jumitButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((ScreenWidth - 80)/2, 550, 80, 80);
        [btn setTitle:@"跳转" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor purpleColor];
        [btn addTarget:self action:@selector(jumitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 40;
        _jumitButton = btn;
    }
    return _jumitButton;
}

- (ASAuthorizationAppleIDButton *)appleLoginButton API_AVAILABLE(ios(13.0)){
    if (!_appleLoginButton) {
        ASAuthorizationAppleIDButton *appleLoginBtn = [[ASAuthorizationAppleIDButton alloc] initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeSignIn authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleBlack];
        appleLoginBtn.frame = CGRectMake((ScreenWidth - 200)/2, 480, 200, 50);
        appleLoginBtn.layer.cornerRadius = 5;
        appleLoginBtn.layer.masksToBounds = YES;
        [appleLoginBtn addTarget:self action:@selector(appleLoginClick) forControlEvents:UIControlEventTouchUpInside];
        _appleLoginButton = appleLoginBtn;
    }
    return _appleLoginButton;
}

- (UIImageView *)multipleImageView{
    if (!_multipleImageView) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - 200)/2, 400, 200, 200)];
        imageView.image = [UIImage imageNamed:@"bei"];
        _multipleImageView = imageView;
    }
    return _multipleImageView;
}

@end
