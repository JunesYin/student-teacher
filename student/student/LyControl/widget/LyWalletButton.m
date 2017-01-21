//
//  LyWalletButton.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/12.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyWalletButton.h"
#import "LyUtil.h"


CGFloat const lbTextHeight = 30.0f;
#define lbTextFont                              LyFont(16)

CGFloat const lbTitleHeight = lbTextHeight;
#define lbTitleFont                             lbTextFont


@interface LyWalletButton ()
{
    UILabel                                     *lbText;
    UILabel                                     *lbTitle;
    
    
    NSString                                    *unit;
}
@end



@implementation LyWalletButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self initAndLayoutSubview];
    }
    
    
    return self;
}



- (void)initAndLayoutSubview
{
    lbText = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetWidth(self.frame)/2-lbTextHeight, CGRectGetWidth(self.frame), lbTextHeight)];
    [lbText setTextColor:Ly517ThemeColor];
    [lbText setTextAlignment:NSTextAlignmentCenter];
    [lbText setFont:lbTextFont];
    
    
    
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( 0, lbText.frame.origin.y+lbText.frame.size.height, lbText.frame.size.width, lbTextHeight)];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [lbTitle setFont:lbTitleFont];
    
    
    
    [self addSubview:lbText];
    [self addSubview:lbTitle];
}



- (void)setItemMode:(LyWalletButtonMode)itemMode
{
    _itemMode = itemMode;
    
    
    switch ( _itemMode) {
        case walletButtonMode_balance: {
            unit = @"元";
            [self setTitle:@"余额"];
            break;
        }
        case walletButtonMode_5Coin: {
            unit = @"个";
            [self setTitle:@"吾币"];
            break;
        }
        case walletButtonMode_coupon: {
            unit = @"张";
            [self setTitle:@"学车券"];
            break;
        }
    }
}



- (void)setNum:(float)num
{
    _num = num;
    
    if ( walletButtonMode_balance == _itemMode)
    {
        [lbText setText:[[NSString alloc] initWithFormat:@"%.1f%@", _num, unit]];
    }
    else
    {
        [lbText setText:[[NSString alloc] initWithFormat:@"%.0f%@", _num, unit]];
    }
}



- (void)setTitle:(NSString *)title
{
    if ( !title)
    {
        return;
    }
    
    _title = [title copy];
    
    [lbTitle setText:_title];
}






@end
