//
//  UIDatePicker+clearSpearator.m
//  student
//
//  Created by MacMini on 2016/12/12.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "UIDatePicker+clearSpearator.h"

@implementation UIDatePicker (clearSpearator)

- (void)clearSpearator
{
    for (UIView *subView1 in self.subviews)
    {
        if ([subView1 isKindOfClass:[UIPickerView class]])//取出UIPickerView
        {
            for(UIView *subView2 in subView1.subviews)
            {
                if (subView2.frame.size.height < 1)//取出分割线view
                {
                    subView2.hidden = YES;//隐藏分割线
                }
            }
        }
    }
}


@end
