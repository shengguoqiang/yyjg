#import "DQSUtils_OC.h"
#import <AVFoundation/AVFoundation.h>
// 指纹识别
#import <LocalAuthentication/LocalAuthentication.h>

@implementation DQSUtils_OC

#pragma mark - 视图抖动效果
+ (void)shakerView:(UIView *)ashakerView {
    //清除动画
    [ashakerView.layer removeAllAnimations];
    //添加动画
    CAKeyframeAnimation *kfanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat currentTx = ashakerView.transform.tx;
    kfanimation.duration = 0.4;
    kfanimation.values = @[@(currentTx), @(currentTx + 10), @(currentTx - 8), @(currentTx + 8), @(currentTx - 5), @(currentTx + 5), @(currentTx)];
    kfanimation.keyTimes = @[@(0), @(0.225), @(0.425), @(0.525), @(0.750), @(0.875), @(1)];
    kfanimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [ashakerView.layer addAnimation:kfanimation forKey:@"kNoticeLabelShakerAnimationKey"];
}

#pragma mark - 设置文本行间距
+ (NSMutableAttributedString *)getAttributedStringWithLineSpace:(NSString *)text lineSpace:(CGFloat)lineSpace kern:(CGFloat)kern {
    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary*attriDict = @{NSParagraphStyleAttributeName : paragraphStyle,
                               NSKernAttributeName : @(kern)
                               };
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attriDict];
    
    return attributedString;
}


#pragma mark - 拨打号码
+ (BOOL)telePhoneCall:(NSString*)telno {
    if(![[[UIDevice currentDevice] model] isEqual:@"iPhone"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的设备不能拨打电话" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    NSString *phoneNum = telno;
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"\u8f6c" withString:@","];
    NSArray *nums = [phoneNum componentsSeparatedByString:@"/"];
    phoneNum = [nums objectAtIndex:0];
    
    if ([self isEmptyString:phoneNum]) {
        phoneNum = @"400-850-3099";
    }
    
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNum]];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:telURL options:@{} completionHandler:NULL];
    } else {
        [[UIApplication sharedApplication] openURL:telURL];
    }
    return YES;
}

#pragma mark - 根据视频URL获取封面图片
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

#pragma mark - 将文本中的html字符逆转义
+ (NSString *)filterHtmlBQ:(NSString*)str {
    if ([self isEmptyString:str]) {
        return nil;
    }
    
    NSMutableString *ms = [NSMutableString stringWithCapacity:10];
    [ms setString:str];
    [ms replaceOccurrencesOfString:@"<br />" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"<br>" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"<br/>" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&nbsp;" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"\t" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&#8226;" withString:@"•" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&#" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&ldquo;" withString:@"“" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&rdquo;" withString:@"”" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&mdash;" withString:@"—" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&lsquo;" withString:@"‘" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&rsquo;" withString:@"’" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&times;" withString:@"x" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&hellip;" withString:@"…" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"<img" withString:@"<p><img" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"/>" withString:@"/></p><p>" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"<p><p>" withString:@"<p>" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"/>/>" withString:@"/>" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&middot;" withString:@"." options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    while ([ms hasPrefix:@"\r\n"]) {
        [ms replaceOccurrencesOfString:@"\r\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, ms.length>5?5:ms.length)];
    }
    
    while ([ms replaceOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)] > 0) {
        
    }
    
    while ([ms replaceOccurrencesOfString:@"\n\n" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)] > 0) {
        
    }
    return ms;
}

#pragma mark - 判断空字符串
+ (BOOL)isEmptyString:(NSString *)_str {//判断空字符串
    if ([_str isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    
    if ([_str isEqualToString:@""])
    {
        return YES;
    }
    
    if (_str == nil)
    {
        return YES;
    }
    
    if (_str == NULL)
    {
        return YES;
    }
    
    if ((NSNull*)_str == [NSNull null])
    {
        return YES;
    }
    
    if ([_str isEqualToString:@"<null>"])
    {
        return YES;
    }
    
    if ([_str isEqualToString:@"null"])
    {
        return YES;
    }
    
    return [self isEmptyStringBySpace:_str];
    
    return NO;
}

+ (BOOL)isEmptyStringBySpace:(NSString*)_str {//全是空格
    if ([[_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}

@end
