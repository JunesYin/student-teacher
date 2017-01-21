//
//  UITextView+textCount.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/22.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "UITextView+textCount.h"
#import <objc/runtime.h>

#define RIGHT_MARGIN    5.0f
#define BOTTOME_MARGIN  5.0f


@implementation UITextView (textCount)

@dynamic textCount;



- (int)textCount
{
    NSRange range1 = [self.label_textCount.text rangeOfString:@"/"];
    
    NSString *strTextCount = [self.label_textCount.text substringFromIndex:range1.location+1];
    
    return [strTextCount intValue];
}

- (void)setTextCount:(int)textCount
{
    self.label_textCount.text = [[NSString alloc] initWithFormat:@"%ld/%d", self.text.length, textCount];
    [self changeLaelFrame];
    
    //监听文本改变,如果没有设置placeholder就不会监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange_textCount:) name:UITextViewTextDidChangeNotification object:nil];
}


- (void)update
{
    [self changeLaelFrame];
    self.label_textCount.text = [[NSString alloc] initWithFormat:@"%ld/%d", self.text.length, self.textCount];
}


- (void)updateTextCount
{
    [self changeLaelFrame];
    self.label_textCount.text = [[NSString alloc] initWithFormat:@"%ld/%d", self.text.length, self.textCount];
}



- (void)textDidChange_textCount:(NSNotification *)notification
{
    if (self.text.length > self.textCount) {
        self.label_textCount.textColor = [UIColor redColor];
    } else {
        self.label_textCount.textColor = [UIColor grayColor];
    }
    
    self.label_textCount.text = [[NSString alloc] initWithFormat:@"%ld/%d", self.text.length, self.textCount];
    [self changeLaelFrame];
}



- (UILabel *)label_textCount
{
    UILabel *label_textCount = objc_getAssociatedObject( self, @"lable_UITextView_textCount");
    
    if ( !label_textCount)
    {
        //没有就创建,并设置属性
        label_textCount = [UILabel new];
        [label_textCount setFont:self.font];
        [label_textCount setTextColor:[UIColor grayColor]];
        [label_textCount setTextAlignment:NSTextAlignmentRight];
        
        [self addSubview:label_textCount];
        
        //关联到自身
        objc_setAssociatedObject( self, @"lable_UITextView_textCount", label_textCount, OBJC_ASSOCIATION_RETAIN);
    }
    
    
    return label_textCount;
}



- (void)changeLaelFrame
{
    NSString *strTextMax = [[NSString alloc] initWithFormat:@"%d/%d", self.textCount, self.textCount];
    CGSize sizeText = [strTextMax sizeWithAttributes:@{NSFontAttributeName:self.font}];
    
    CGSize sizeLabel = [strTextMax boundingRectWithSize:sizeText options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    sizeLabel = CGSizeMake(sizeLabel.width + 10, sizeLabel.height);
    
    self.label_textCount.frame = CGRectMake( self.frame.size.width-RIGHT_MARGIN-sizeLabel.width, (self.contentSize.height > CGRectGetHeight(self.bounds) ? self.contentSize.height : CGRectGetHeight(self.bounds))-BOTTOME_MARGIN-sizeLabel.height, sizeLabel.width, sizeLabel.height);
}


@end
