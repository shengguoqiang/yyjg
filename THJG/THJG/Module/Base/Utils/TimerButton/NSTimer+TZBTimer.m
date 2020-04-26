
#import "NSTimer+TZBTimer.h"

@implementation NSTimer (TZBTimer)

+ (NSTimer *)blockSupport_scheduleTimerWithTimeInterval:(NSTimeInterval)interval
                                                  block:(void(^)())block
                                                repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(blockInvock:) userInfo:[block copy] repeats:repeats];
}

+ (void)blockInvock:(NSTimer *)timer
{
    void(^block)() = timer.userInfo;
    if (block)
    {
        block();
    }
}

@end
