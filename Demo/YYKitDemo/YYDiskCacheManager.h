//
//  YYDIskCacheManager.h
//  YYKitDemo
//
//  Created by 李畅 on 2020/8/21.
//  Copyright © 2020 ibireme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCDiskCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYDiskCacheManager : NSObject

+(instancetype)sharedInstance;
-(void)addIntoManagerWithCahe:(LCDiskCache *)cache;

@end

NS_ASSUME_NONNULL_END
