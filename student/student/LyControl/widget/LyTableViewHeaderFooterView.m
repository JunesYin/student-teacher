//
//  LyTableViewHeaderFooterView.m
//  teacher
//
//  Created by Junes on 16/8/25.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTableViewHeaderFooterView.h"
#import "LyUtil.h"

CGFloat const LyTableViewHeaderFooterViewHeight = 50.0f;


@implementation LyTableViewHeaderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        [super setFrame:CGRectMake(0, 0, SCREEN_WIDTH, LyTableViewHeaderFooterViewHeight)];
        
        lbContent = [UILabel new];
        [lbContent setFont:LyFont(18)];
        [lbContent setTextColor:Ly517ThemeColor];
        [self addSubview:lbContent];
    }
    
    return self;
}


- (void)setContent:(NSString *)content
{
    [lbContent setFrame:self.bounds];
    
    if (![LyUtil validateString:content]) {
        content = @" ";
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = horizontalSpace;//缩进
    style.firstLineHeadIndent = horizontalSpace;
    
    NSAttributedString *uContent = [[NSMutableAttributedString alloc] initWithString:content
                                                                          attributes:@{
                                                                                       NSParagraphStyleAttributeName:style
                                                                                       }];
    [lbContent setAttributedText:uContent];
}


- (void)setFont:(UIFont *)font {
    if (!font) {
        return;
    }
    
    _font = font;
    [lbContent setFont:_font];
}


- (void)setContentColor:(UIColor *)contentColor {
    if (!contentColor) {
        return;
    }
    
    _contentColor = contentColor;
    
    [lbContent setTextColor:_contentColor];
}



@end
