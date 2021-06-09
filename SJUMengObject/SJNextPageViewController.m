//
//  SJNextPageViewController.m
//  SJUMengObject
//
//  Created by deli on 2021/6/9.
//

#import "SJNextPageViewController.h"

@interface SJNextPageViewController ()
@property (nonatomic,strong) UIButton *closeButton;
@end

@implementation SJNextPageViewController

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
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.closeButton];
}

- (void)closeButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 10, 40, 40);
        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor purpleColor];
        [btn addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 20;
        btn.tag = 1;
        _closeButton = btn;
    }
    return _closeButton;
}

@end
