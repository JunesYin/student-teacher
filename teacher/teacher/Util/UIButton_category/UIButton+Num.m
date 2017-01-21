//
//  UIButton+Num.m
//  teacher
//
//  Created by Junes on 16/8/23.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "UIButton+Num.h"
#import <objc/runtime.h>



CGFloat const label_numSize = 20.0f;


@implementation UIButton (Num)


- (NSString *)num
{
    return self.label_num.text;
}


- (void)setNum:(NSString *)num
{
    if (num.length < 1)
    {
        self.label_num.hidden = YES;
    }
    else
    {
        self.label_num.text = num;
        self.label_num.hidden = NO;
    }
}




- (UILabel *)label_num
{
    UILabel *label_num = objc_getAssociatedObject(self, @"label_num");
    
    if (!label_num)
    {
        //没有就创建,并设置属性
        label_num = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-label_numSize, 0, label_numSize, label_numSize)];
        label_num.font = [UIFont systemFontOfSize:12];
        label_num.textColor = [UIColor whiteColor];
        label_num.backgroundColor = [UIColor redColor];
        label_num.textAlignment = NSTextAlignmentCenter;
        label_num.layer.cornerRadius = label_numSize/2.0f;
        label_num.clipsToBounds = YES;
        
        [self addSubview:label_num];
        
        //关联到自身
        objc_setAssociatedObject(self, @"label_num", label_num, OBJC_ASSOCIATION_RETAIN);
    }
    
    return label_num;
}


//
//- (void)changeFrameForLable_num
//{
//    if (self.label_num.text.length < 1)
//    {
//        self.label_num.hidden = YES;
//    }
//    else
//    {
//        CGFloat fWidth = [self.num sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}].width;
//        
//        self.label_num.frame = CGRectMake(self.bounds.size.width-fWidth, 0, fWidth, label_numHeight);
//    }
//}




@end
