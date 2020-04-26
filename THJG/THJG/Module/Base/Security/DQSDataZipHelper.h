/**
 * Data压缩与解压
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DQSDataZipHelper : NSObject

/**
 * 压缩数据
 * @param data 待压缩数据
 *
 * return 压缩过的数据
 */
+ (id)zipDataWithData:(NSData *)data;

/**
 * 解压数据
 * @param data 待解压数据
 *
 * @return 解压过的数据
 */
+ (id)unZipDataWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
