//
//  LCLinkedList.m
//  YYKitDemo
//
//  Created by 李畅 on 2020/7/20.
//  Copyright © 2020 ibireme. All rights reserved.
//

#import "LCLinkedList.h"
#import <CoreFoundation/CoreFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface LCLinkedList()
{
    CFMutableDictionaryRef _searchDic;
}

@end

@implementation LCLinkedList

-(instancetype)init
{
    self = [super init];
    if (self) {
        _searchDic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
    return self;
}

-(void)insertFirstNode:(LCLinkedListNode *)node
{
    node.prev = node;
    node.next = node;
    self.headNode = node;
    self.trailNode = node;
}

-(void)insertNodeAtHead:(LCLinkedListNode *)node
{
    if (self.totalCount == 0) { //空
        [self insertFirstNode:node];
    }else if (self.headNode == self.trailNode){ //满
        
    }else{
        
    }
}

-(void)insertToHeadData:(id)object andKey:(NSString *)key cost:(NSUInteger)size
{
    if (self.headNode && self.headNode == self.trailNode) { //链表满了，就直接把第一个替换，searchDic中不用移除
        NSString *needDeleteKey = self.headNode.key;
        NSString *needDeleteData = self.headNode.data;
        self.headNode.key = key;
        self.headNode.data = object;
        self.headNode.size = size;
        self.headNode.updateTIme = CACurrentMediaTime();
    }
}

@end
