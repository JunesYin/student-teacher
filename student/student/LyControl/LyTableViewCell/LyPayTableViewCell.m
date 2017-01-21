//
//  LyPayTableViewCell.m
//  student
//
//  Created by Junes on 2016/11/21.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyPayTableViewCell.h"

#import "LyUtil.h"


CGFloat const ptcHeight = 60;



CGFloat const ptcIvIconSize = 50.0f;

#define ptcLbTitleWidth             (SCREEN_WIDTH - ptcIvIconSize - ptcIvSelectedSize - horizontalSpace * 4)
CGFloat const ptcLbTitleHeight = 25.0f;
#define ptcLbDetailWidth            ptcLbTitleWidth
CGFloat const ptcLbDetailHeight = 15.0f;

CGFloat const ptcIvRecommendWidth = 30.0f;
CGFloat const ptcIvRecommendHeight = ptcIvRecommendWidth / 2.0f;

CGFloat const ptcIvSelectedSize = 20.0f;


@interface LyPayTableViewCell ()
{
    UIImageView             *ivIcon;
    
    UILabel                 *lbTitle;
    UILabel                 *lbDetail;
    
    UIImageView             *ivRecommend;
    
    UIImageView             *ivAdditional;
    
    UIImageView             *ivSelected;
}
@end


@implementation LyPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpace, ptcHeight/2.0 - ptcIvIconSize/2.0f, ptcIvIconSize, ptcIvIconSize)];
    [ivIcon.layer setCornerRadius:5.0f];
    [ivIcon setClipsToBounds:YES];
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace * 2 + ptcIvIconSize, ivIcon.frame.origin.y + ptcIvIconSize/2.0f - ptcLbTitleHeight/2.0 - verticalSpace, ptcLbTitleWidth, ptcLbTitleHeight)];
    [lbTitle setFont:LyFont(15)];
    [lbTitle setTextColor:[UIColor blackColor]];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    
    lbDetail = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace * 2 + ptcIvIconSize, lbTitle.frame.origin.y + CGRectGetHeight(lbTitle.frame), ptcLbDetailWidth, ptcLbDetailHeight)];
    [lbDetail setFont:LyFont(10)];
    [lbDetail setTextColor:[UIColor grayColor]];
    [lbDetail setTextAlignment:NSTextAlignmentLeft];
    
    ivSelected = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - horizontalSpace - ptcIvSelectedSize, ptcHeight/2.0f - ptcIvSelectedSize/2.0f, ptcIvSelectedSize, ptcIvSelectedSize)];
    [ivSelected setImage:[LyUtil imageForImageName:@"ivSelected" needCache:NO]];
    
    [self addSubview:ivIcon];
    [self addSubview:lbTitle];
    [self addSubview:lbDetail];
    [self addSubview:ivSelected];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    [ivSelected setHidden:!selected];
}


- (void)setCellInfo:(UIImage *)icon title:(NSString *)title detail:(NSString *)detail additaionalImage:(UIImage *)additionalImage isRecommend:(BOOL)isRecommend {
    [ivIcon setImage:icon];
    
    CGFloat fWidthTitle = [title sizeWithAttributes:@{NSFontAttributeName : lbTitle.font}].width;
    [lbTitle setFrame:CGRectMake(lbTitle.frame.origin.x, lbTitle.frame.origin.y, fWidthTitle, ptcLbTitleHeight)];
    [lbTitle setText:title];
    
    [lbDetail setText:detail];
    
    if (additionalImage) {
        if (!ivAdditional) {
            ivAdditional = [[UIImageView alloc] initWithFrame:CGRectMake(lbTitle.frame.origin.x + fWidthTitle + horizontalSpace, lbTitle.frame.origin.y, ptcLbTitleHeight * 3, ptcLbTitleHeight)];
            [ivAdditional setContentMode:UIViewContentModeScaleAspectFit];
            [ivAdditional setImage:additionalImage];
        }
        [self addSubview:ivAdditional];
    } else {
        [ivAdditional removeFromSuperview];
        ivAdditional = nil;
    }
    
    
    if (isRecommend) {
        
        CGRect rectIvRecommed = CGRectMake(lbTitle.frame.origin.x + fWidthTitle + horizontalSpace, lbTitle.frame.origin.y + CGRectGetHeight(lbTitle.frame)/2.0f - ptcIvRecommendHeight/2.0f, ptcIvRecommendWidth, ptcIvRecommendHeight);
        
        if (!ivRecommend) {
            ivRecommend = [[UIImageView alloc] initWithFrame:rectIvRecommed];
            [ivRecommend setContentMode:UIViewContentModeScaleAspectFit];
            [ivRecommend setImage:[LyUtil imageForImageName:@"pay_recommend" needCache:NO]];
            
        } else {
            [ivRecommend setFrame:rectIvRecommed];
        }
        
        [self addSubview:ivRecommend];
    } else {
        [ivRecommend removeFromSuperview];
    }
}



@end
