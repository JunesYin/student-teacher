//
//  LyTeachManageTableViewCell.m
//  teacher
//
//  Created by Junes on 16/8/10.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyTeachManageTableViewCell.h"


#import "LyUtil.h"


CGFloat const tmtcellHeight = 100.0f;

//图标
CGFloat const tmtcIvIconSize = 60;

//内容-标题
#define lbItemWidth                         (SCREEN_WIDTH-tmtcIvIconSize-ivMoreSize-horizontalSpace*4)
CGFloat const tmtcLbTitleHeight = 20.0f;
//内容-内容
CGFloat const tmtcLbDetailHeight = 40.0f;

//更多图标



@interface LyTeachManageTableViewCell ()
{
    UIImageView                 *ivIcon;
    
    UILabel                     *lbTitle;
    UILabel                     *lbDetail;
    
    UIImageView                 *ivMore;
}
@end


@implementation LyTeachManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndLayoutSubviews];
    }
    
    return self;
}


- (void)initAndLayoutSubviews
{
    //图标
    ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalSpace, tmtcellHeight/2.0f-tmtcIvIconSize/2.0f, tmtcIvIconSize, tmtcIvIconSize)];
    [ivIcon setContentMode:UIViewContentModeScaleAspectFill];
    
    //内容-标题
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace+tmtcIvIconSize+horizontalSpace, ivIcon.ly_y, lbItemWidth, tmtcLbTitleHeight)];
    [lbTitle setFont:LyFont(16)];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    
    //内容-内容
    lbDetail = [[UILabel alloc] initWithFrame:CGRectMake(lbTitle.frame.origin.x, lbTitle.ly_y+CGRectGetHeight(lbTitle.frame), lbItemWidth, tmtcLbDetailHeight)];
    [lbDetail setFont:LyFont(14)];
    [lbDetail setTextColor:[UIColor darkGrayColor]];
    [lbDetail setTextAlignment:NSTextAlignmentLeft];
    [lbDetail setNumberOfLines:0];
    
    //更多
    ivMore = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-ivMoreSize, tmtcellHeight/2.0f-ivMoreSize/2.0f, ivMoreSize, ivMoreSize)];
    [ivMore setImage:[LyUtil imageForImageName:@"ivMore" needCache:NO]];
    
    [self addSubview:ivIcon];
    [self addSubview:lbTitle];
    [self addSubview:lbDetail];
    [self addSubview:ivMore];
}


- (void)setCellInfo:(UIImage *)icon title:(NSString *)title detail:(NSString *)detail
{
    [ivIcon setImage:icon];
    [lbTitle setText:title];
    [lbDetail setText:detail];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
