//
//  YYLRUManager.m
//  YYKitDemo
//
//  Created by 李畅 on 2020/7/22.
//  Copyright © 2020 ibireme. All rights reserved.
//

#import "YYLRUManager.h"
#import "LCLinkedList.h"
#import <pthread.h>

@implementation YYLRUManager{
    pthread_mutex_t _lock;
    LCLinkedList *_lru;
    dispatch_queue_t _queue;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        _lru = [LCLinkedList new];
        _queue = dispatch_queue_create("com.tencent.cache.memory", DISPATCH_QUEUE_SERIAL);
        _countLimit = NSUIntegerMax;
        _sizeLimit = NSUIntegerMax;
        _ageLimit = DBL_MAX;
        _autoTrimInterval = 5.0;
    }
    return self;
}

-(void)tryToFindNeedDeleteMemory
{
    __weak typeof(self) _self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_autoTrimInterval * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __strong typeof(_self) self = _self;
        if (!self) return;
        [self doSearchAction];
        [self tryToFindNeedDeleteMemory];
    });
}

-(void)doSearchAction
{
    dispatch_async(_queue, ^{
        [self checkAge];
        [self checkSize];
    });
}

-(void)checkSize
{
    BOOL finish = NO;
    pthread_mutex_lock(&_lock);
    if(_lru.totalSize < self.sizeLimit){
        finish = YES;
    }
    pthread_mutex_unlock(&_lock);
    if (finish) {
        return;
    }
    NSMutableArray *holder = [NSMutableArray new];
    while (!finish) {
        if (pthread_mutex_trylock(&_lock) == 0) {
            if (_lru.totalSize > self.sizeLimit) {
                
            }else{
                finish = YES;
            }
        }else{
            usleep(10 * 1000);
        }
    }
    if (holder.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [holder count];
        });
    }
}

-(void)checkAge
{
    
}

@end
