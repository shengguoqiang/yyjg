#import "DQSDataZipHelper.h"
#import "zlib.h"

@implementation DQSDataZipHelper

#pragma mark - 压缩数据
+ (id)zipDataWithData:(NSData *)data {
   return [self compressedDataWithBytes: [data bytes] length: (int)[data length]];
}

+ (id) compressedDataWithBytes: (const void*) bytes length: (unsigned) length {
    unsigned long compressedLength = compressBound(length);
    unsigned char* compressedBytes = (unsigned char*) malloc(compressedLength);
    if (compressedBytes != NULL && compress((Bytef *)compressedBytes, &compressedLength, (const Bytef *)bytes, length) == Z_OK) {
        char* resizedCompressedBytes = (char *)realloc(compressedBytes, compressedLength);
        if (resizedCompressedBytes != NULL) {
            return [NSData dataWithBytesNoCopy: resizedCompressedBytes length: compressedLength freeWhenDone: YES];
        } else {
            return [NSData dataWithBytesNoCopy: compressedBytes length: compressedLength freeWhenDone: YES];
        }
    } else {
        free(compressedBytes);
        return nil;
    }
}

#pragma mark - 解压数据
+ (id)unZipDataWithData:(NSData *)data {
    return [self uncompressZippedData:data];
}

+ (NSData *)uncompressZippedData:(NSData *)compressedData {
    
    if ([compressedData length] == 0) return compressedData;
    
    unsigned full_length = (int)[compressedData length];
    
    unsigned half_length = (int)[compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = (int)[compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = (Bytef *)[decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (int)[decompressed length] - (int)strm.total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
        
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}


@end
