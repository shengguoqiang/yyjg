//
//  DQSRSAHelper.m
//  ZNCF
//
//  Created by 大强神 on 2019/1/23.
//  Copyright © 2019 中南财富. All rights reserved.
//

#import "DQSRSAHelper.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation DQSRSAHelper

+ (BOOL)rsaSHA256VerifyData:(NSData *)plainData withSignature:(NSData *)signature {
    SecKeyRef key = [self fetchPublicSecKeyRef:[[NSBundle mainBundle] pathForResource:@"rsa_public_key" ofType:@"der"]];
    
    size_t signedHashBytesSize = SecKeyGetBlockSize(key);
    const void* signedHashBytes = [signature bytes];
    
    size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return NO;
    }
    
    OSStatus status = SecKeyRawVerify(key,
                                      kSecPaddingPKCS1SHA256,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);
    
    return status == errSecSuccess;
}

+ (SecKeyRef)fetchPublicSecKeyRef:(NSString *)pubDerPath; {
    static SecKeyRef keyRef = nil;
    NSData *certificateData = [NSData dataWithContentsOfFile:pubDerPath];
    SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)certificateData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
    }
    keyRef = SecTrustCopyPublicKey(myTrust);
    CFRelease(myCertificate);
    CFRelease(myPolicy);
    CFRelease(myTrust);
    return keyRef;
}

@end
