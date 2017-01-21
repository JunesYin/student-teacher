//
//  UILabel+LyTextAlignmentLeftAndRight.m
//  teacher
//
//  Created by Junes on 16/7/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "UILabel+LyTextAlignmentLeftAndRight.h"
#import <CoreText/CoreText.h>

@implementation UILabel (LyTextAlignmentLeftAndRight)

- (void)justifyTextAlignmentLeftAndRight
{
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName:self.font}
                                              context:nil].size;
    
    CGFloat centerMargin = (self.frame.size.width - textSize.width) / (self.text.length - 1);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttribute:(id)kCTKernAttributeName value:@(centerMargin) range:NSMakeRange(0, self.text.length - 1)];
    self.attributedText = attributedString;
}

@end
