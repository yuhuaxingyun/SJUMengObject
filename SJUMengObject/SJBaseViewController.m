//
//  SJBaseViewController.m
//  SJUMengObject
//
//  Created by deli on 2021/6/9.
//

#import "SJBaseViewController.h"
#import <UMCommon/MobClick.h>

@interface SJBaseViewController ()

@end

@implementation SJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)beginLogPageView{
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}
 
- (void)endLogPageView{
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
@end
