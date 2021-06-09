//
//  SJShareView.h
//  SJUMengObject
//
//  Created by deli on 2021/6/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJShareView : UIView
/**
 从底部显示更多操作模式的按钮视图
 
 @param titleArray 标题名称
 @param imgNameArray 图片名称
 @param blockTapAction 点击返回事件(0,1,2,3...)
 */
+ (void)showMoreWithTitle:(NSArray *)titleArray
             imgNameArray:(NSArray *)imgNameArray
           blockTapAction:( void(^)(NSInteger index) )blockTapAction;
@end

NS_ASSUME_NONNULL_END
