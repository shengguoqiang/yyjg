/**
 * 极光推送注册
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class THJGAppDelegate;
@interface THJGJPushRegister : NSObject

+ (void)registerJPush:(THJGAppDelegate *)delegate;

@end

NS_ASSUME_NONNULL_END
