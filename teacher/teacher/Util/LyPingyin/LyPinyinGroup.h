//
//  LEOPinyinGroup.h
//  CarSupermarket
//
//  Created by lion on 15/7/26.
//  Copyright (c) 2015年 lion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  获取model数组
 */
UIKIT_EXTERN NSString *const LyPinyinGroupResultKey;

/**
 *  获取所包函字母的数组
 */
UIKIT_EXTERN NSString *const LyPinyinGroupNameKey;

@interface LyPinyinGroup : NSObject

/*
 参数group:未排训分组的model数组
 参数key:根据model中的那个属性排训
 */
+(NSDictionary *)group:(NSArray *)datas key:(NSString *)key;

@end
