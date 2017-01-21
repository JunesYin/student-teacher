//
//  NSMutableArray+SingleElement.m
//  teacher
//
//  Created by Junes on 16/9/1.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "NSMutableArray+SingleElement.h"

@implementation NSMutableArray (SingleElement)

- (void)singleElement {
    NSSet *set = [NSSet setWithArray:self];
    
    [self removeAllObjects];
    
    [self addObjectsFromArray:[set allObjects]];
}

- (void)singleElementByKey:(NSString *)key {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (id item in self) {
        [dic setObject:item forKey:[item valueForKey:key]];
    }
    
    [self removeAllObjects];
    
    [self addObjectsFromArray:[dic allValues]];
}

@end
