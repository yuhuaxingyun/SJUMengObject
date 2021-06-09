//
//  SJUMManger.h
//  SJUMengObject
//
//  Created by deli on 2021/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJUMManger : NSObject
+ (instancetype)shareManger;
// 分享网页链接
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType;
// 分享纯文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType;
// 第三方登录
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType;
@end

NS_ASSUME_NONNULL_END
