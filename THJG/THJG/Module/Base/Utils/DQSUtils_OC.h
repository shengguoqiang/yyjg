/**
 * OC工具类
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DQSUtils_OC : NSObject

/**
 * 视图抖动效果
 */
+ (void)shakerView:(UIView *)ashakerView;

/**
 * 设置文本行间距
 */
+ (NSMutableAttributedString *)getAttributedStringWithLineSpace:(NSString *)text
                                                     lineSpace:(CGFloat)lineSpace
                                                     kern:(CGFloat)kern;

/**
 * 拨打号码
 */
+ (BOOL)telePhoneCall:(NSString*)telno;

/**
 * 根据视频URL获取封面图片
 */
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/**
 *   将文本中的html字符逆转义
 */
+ (NSString *)filterHtmlBQ:(NSString*)str;

@end

NS_ASSUME_NONNULL_END
