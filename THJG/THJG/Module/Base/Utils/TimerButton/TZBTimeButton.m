
#import "TZBTimeButton.h"
#import "NSTimer+TZBTimer.h"

static const NSInteger totalSeconds = 60;
@interface TZBTimeButton()

@property (nonatomic,strong) NSTimer *timer;

//当前读秒
@property (nonatomic,assign) NSInteger  currentSecond;

@end

@implementation TZBTimeButton

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //初始化倒计时时间
    self.currentSecond = totalSeconds;
    [self setTitle:@"获取" forState:UIControlStateNormal];
}

- (void)start {
    self.currentSecond = totalSeconds;
    self.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer blockSupport_scheduleTimerWithTimeInterval:1 block:^{
      __strong typeof(self) strongSelf = weakSelf;
      --strongSelf.currentSecond;
      [strongSelf setTitle:[NSString stringWithFormat:@"%lds", (long)strongSelf.currentSecond] forState:UIControlStateNormal];
      strongSelf.titleLabel.font = [UIFont systemFontOfSize:15.0];
      strongSelf.userInteractionEnabled = NO;
      if (strongSelf.currentSecond == 0) {
          [strongSelf over];
          [strongSelf setTitle:@"获取" forState:UIControlStateNormal];
          strongSelf.userInteractionEnabled = YES;
      }
  } repeats:YES];
}

- (void)over {
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self setTitle:@"获取" forState:UIControlStateNormal];
    self.userInteractionEnabled = YES;
}

@end
