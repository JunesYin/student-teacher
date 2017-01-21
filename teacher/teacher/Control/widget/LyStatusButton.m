//
//  LyStatusButton.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/28.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyStatusButton.h"
#import "LyUtil.h"



CGFloat const LyStatusButtonHorizontalMargin = 2.0f;


@interface LyStatusButton ()
{
    UIImageView                             *ivIcon;
    UILabel                                 *lbNum;
}

@end


@implementation LyStatusButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    LyStatusButton *tmpButton = (LyStatusButton *)[UIButton buttonWithType:buttonType];
    
    
    
    return tmpButton;
}


- (instancetype)init
{
    if ( self = [super init])
    {
        [self initAndAddSubview];
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self initAndAddSubview];
    }
    
    
    return self;
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    
    CGRect rectIvIcon = CGRectMake( 0, CGRectGetHeight(self.frame)/2.0f-15/2.0f, 15, 15);
    CGRect rectLbNum = CGRectMake( rectIvIcon.origin.x+rectIvIcon.size.width+LyStatusButtonHorizontalMargin, 0, self.frame.size.width-LyStatusButtonHorizontalMargin-rectIvIcon.size.width, self.frame.size.height);
    
    [ivIcon setFrame:rectIvIcon];
    [lbNum setFrame:rectLbNum];
}


- (void)initAndAddSubview
{
    CGRect rectIvIcon = CGRectMake( 0, 0, 15, 15);
    ivIcon = [[UIImageView alloc] initWithFrame:rectIvIcon];
    [ivIcon setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:ivIcon];

    CGRect rectLbNum = CGRectMake( rectIvIcon.origin.x+rectIvIcon.size.width+LyStatusButtonHorizontalMargin, 0, self.frame.size.width-rectIvIcon.size.width, self.frame.size.height);
    lbNum = [[UILabel alloc] initWithFrame:rectLbNum];
    [lbNum setFont:LyStatusButtonNumFont];
    [lbNum setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbNum];
}


- (void)setMode:(LyStatusButtonType)mode
{
    _mode = mode;
    
    switch ( _mode) {
        case statusButtonType_praise: {
            [self setImageIcon:[LyUtil imageForImageName:@"stc_praise_n" needCache:NO]];
            break;
        }
        case statusButtonType_evalution: {
            [self setImageIcon:[LyUtil imageForImageName:@"stc_evalution" needCache:NO]];
            break;
        }
        case statusButtonType_transmit: {
            [self setImageIcon:[LyUtil imageForImageName:@"stc_transmit" needCache:NO]];
            break;
        }
    }
}


- (void)setImageIcon:(UIImage *)imageIcon
{
    _imageIcon = imageIcon;
    
    [ivIcon setImage:_imageIcon];
}




- (void)setNumber:(NSInteger)number
{
    _number = number;
    
    NSString *strNum;
    if ( _number > 9999)
    {
        strNum = [[NSString alloc] initWithFormat:@"%.1f万", _number / 10000.0f];
    }
    else
    {
        strNum = [[NSString alloc] initWithFormat:@"%d", (int)_number];
    }
    
    [lbNum setText:strNum];
}


- (void)praise:(BOOL)praiseFlag
{
    _isPraised = praiseFlag;
    
    if ( _isPraised)
    {
        [ivIcon setImage:[LyUtil imageForImageName:@"stc_praise_h" needCache:NO]];
        
    }
    else
    {
        [ivIcon setImage:[LyUtil imageForImageName:@"stc_praise_n" needCache:NO]];
    }
}



@end
