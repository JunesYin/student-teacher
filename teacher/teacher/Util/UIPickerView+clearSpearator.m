//
//  UIPickerView+clearSpearator.m
//  student
//
//  Created by MacMini on 2016/12/12.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "UIPickerView+clearSpearator.h"

@implementation UIPickerView (clearSpearator)

- (void)clearSpearator
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height < 1)
        {
            [obj setBackgroundColor:[UIColor clearColor]];
        }
    }];
}


@end
