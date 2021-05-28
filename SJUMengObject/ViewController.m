//
//  ViewController.m
//  SJUMengObject
//
//  Created by deli on 2021/5/27.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) UIButton *oneLoginBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.oneLoginBtn];
}

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
        btn.frame = CGRectMake(0, 100, 200, 50);
        btn.center = self.view.center;
        [btn setTitle:@"登录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor purpleColor];
        [btn addTarget:self action:@selector(oneLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _oneLoginBtn = btn;
    }
    return _oneLoginBtn;
}

@end
