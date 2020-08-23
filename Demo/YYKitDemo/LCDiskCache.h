//
//  LCDiskCache.h
//  YYKitDemo
//
//  Created by 李畅 on 2020/8/21.
//  Copyright © 2020 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    LCDiskCacheContentTypeDatabase,
    LCDiskCacheContentTypeCoreData,
    LCDiskCacheContentTypeFile,
}LCDiskCacheContentType;

@interface LCDiskCache : NSObject

-(instancetype)initWithPath:(NSString *)path andType:(LCDiskCacheContentType)type;

@end

NS_ASSUME_NONNULL_END
