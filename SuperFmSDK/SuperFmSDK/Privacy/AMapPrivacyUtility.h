//
//  AMapPrivacyUtility.h
//  officialDemoNavi
//
//  Created by menglong on 2021/10/29.
//  Copyright © 2021 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 隐私合规使用demo 工具类
 */
@interface AMapPrivacyUtility : NSObject

/**
 * @brief 通过这个方法来判断是否同意隐私合规
 * 1.如果没有同意隐私合规，则创建的SDK manager 实例返回 为nil， 无法使用SDK提供的功能
 * 2.如果同意了下次启动不提示 的授权，则不会弹框给用户
 * 3.如果只同意了，则下次启动还要给用户弹框提示
 */

+ (void)handlePrivacyAgreeStatus;
@end

NS_ASSUME_NONNULL_END
