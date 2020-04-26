//
//  DQSRSAHelper.h
//  ZNCF
//
//  Created by 大强神 on 2019/1/23.
//  Copyright © 2019 中南财富. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface DQSRSAHelper : NSObject

/**
 * rsaSHA256验签
 */
+ (BOOL)rsaSHA256VerifyData:(NSData *)plainData withSignature:(NSData *)signature;

@end

NS_ASSUME_NONNULL_END
