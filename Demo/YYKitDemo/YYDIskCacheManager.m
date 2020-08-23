//
//  YYDIskCacheManager.m
//  YYKitDemo
//
//  Created by 李畅 on 2020/8/21.
//  Copyright © 2020 ibireme. All rights reserved.
//

#import "YYDiskCacheManager.h"

@interface YYDiskCacheManager(){
    NSMapTable *_globalInstances;
    dispatch_semaphore_t _globalInstancesLock;
}

@end

@implementation YYDiskCacheManager

static YYDiskCacheManager *manager = nil;
+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YYDiskCacheManager alloc] init];
    });
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _globalInstancesLock = dispatch_semaphore_create(1);
        _globalInstances = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory capacity:0];
    }
    return self;
}


@end
