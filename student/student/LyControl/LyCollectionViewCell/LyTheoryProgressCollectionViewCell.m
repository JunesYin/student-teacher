//
//  LyTheoryProgressCollectionViewCell.m
//  student
//
//  Created by MacMini on 2016/12/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTheoryProgressCollectionViewCell.h"
#import "LyUtil.h"


#define lbTextWidth             (CGRectGetWidth(self.frame)*3/4.0f)
#define lbTextHeight            lbTextWidth
#define lbTextFont              LyFont(10)

@interface LyTheoryProgressCollectionViewCell ()
{
    UILabel             *lbText;
}




@end

@implementation LyTheoryProgressCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        lbText = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetWidth(self.frame)/2.0f-lbTextWidth/2.0f, CGRectGetHeight(self.frame)/2.0f-lbTextHeight/2.0f, lbTextWidth, lbTextHeight)];
        [lbText setBackgroundColor:[UIColor whiteColor]];
        [lbText setFont:lbTextFont];
        [lbText setTextAlignment:NSTextAlignmentCenter];
        [[lbText layer] setCornerRadius:lbTextWidth/2.0f];
        [[lbText layer] setBorderWidth:1.0f];
        [lbText setClipsToBounds:YES];
        
        [self addSubview:lbText];
    }
    
    return self;
}


- (void)setMode:(LyTheoryProgressCollectionViewCellMode)mode
{
    _mode = mode;
    
    switch ( _mode) {
        case LyTheoryProgressCollectionViewCellMode_normal: {
            [lbText setBackgroundColor:[UIColor whiteColor]];
            [lbText.layer setBorderColor:[LyLightgrayColor CGColor]];
            [lbText setTextColor:LyBlackColor];
            break;
        }
        case LyTheoryProgressCollectionViewCellMode_right: {
            [lbText setBackgroundColor:[UIColor whiteColor]];
            [lbText.layer setBorderColor:[LyRightColor CGColor]];
            [lbText setTextColor:LyRightColor];
            break;
        }
        case LyTheoryProgressCollectionViewCellMode_wrong: {
            [lbText setBackgroundColor:[UIColor whiteColor]];
            [lbText.layer setBorderColor:[LyWrongColor CGColor]];
            [lbText setTextColor:LyWrongColor];
            break;
        }
        case LyTheoryProgressCollectionViewCellMode_choosed: {
            [lbText setBackgroundColor:[UIColor whiteColor]];
            [lbText.layer setBorderColor:[Ly517ThemeColor CGColor]];
            [lbText setTextColor:Ly517ThemeColor];
            break;
        }
        case LyTheoryProgressCollectionViewCellMode_focus: {
            [lbText setBackgroundColor:LyHighLightgrayColor];
            [lbText.layer setBorderColor:[LyLightgrayColor CGColor]];
            [lbText setTextColor:LyBlackColor];
            break;
        }
    }
}


- (void)setText:(NSInteger)text
{
    _text = text;
    
    [lbText setText:[[NSString alloc] initWithFormat:@"%d", (int)_text]];
}



@end
