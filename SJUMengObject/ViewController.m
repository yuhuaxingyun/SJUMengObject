//
//  ViewController.m
//  SJUMengObject
//
//  Created by deli on 2021/5/27.
//

#import "ViewController.h"
#import "SJUMManger.h"
#import "SJShareView.h"

@interface ViewController ()

@property (nonatomic,strong) UIButton *oneLoginBtn;
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *thirdPartyLogin;
@property (nonatomic,strong) UIImageView *multipleImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.oneLoginBtn];
    [self.view addSubview:self.shareBtn];
    [self.view addSubview:self.thirdPartyLogin];
//    [self.view addSubview:self.multipleImageView];
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

- (UIButton *)thirdPartyLogin{
    if (!_thirdPartyLogin) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((ScreenWidth - 200)/2, 300, 200, 50);
        [btn setTitle:@"第三方登录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor purpleColor];
        [btn addTarget:self action:@selector(thirdPartyLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 4;
        _thirdPartyLogin = btn;
    }
    return _thirdPartyLogin;
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
