/**
 * timer
 */

#import <Foundation/Foundation.h>

@interface NSTimer (TZBTimer)

/**
 *  block块封装NSTimer有效解决【保留环】问题
 *
 *  @param interval
 *  @param block
 *  @param repeats
 *
 */
+ (NSTimer *)blockSupport_scheduleTimerWithTimeInterval:(NSTimeInterval)interval
                                                  block:(void(^)())block
                                                repeats:(BOOL)repeats;

@end
