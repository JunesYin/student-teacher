//
//  LyFriendsTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/30.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyFriendsTableViewCell.h"
#import "LyUserManager.h"
#import "LyUtil.h"


#import "UIImageView+WebCache.h"

#define maCellWidth                                 SCREEN_WIDTH
CGFloat const fcellHeight = 60.0f;

//#define horizontalSpace                       10


CGFloat const ftcIvAvatarSize = 45.0f;

//CGFloat const lbItemHeight = 20.0f;

CGFloat const friCellIvKindWidth = 60;

#define maCellSignatureWidth                        (maCellWidth-horizontalSpace*3-maCellAvatarSize)



#define maCellNameFont                              LyFont(16)
#define maCellSignatureFont                         LyFont(14)


@interface LyFriendsTabelViewCell ()
{
    UIImageView                     *ivAvatar;
    UILabel                         *lbName;
    UIImageView                     *ivKind;
    UILabel                         *lbSignature;
}

@end



@implementation LyFriendsTabelViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initSubviews];
    }
    
    return self;
}




- (void)initSubviews
{   
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, fcellHeight/2-ftcIvAvatarSize/2, ftcIvAvatarSize, ftcIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar setClipsToBounds:YES];
    [self addSubview:ivAvatar];
    
    
    lbName = [UILabel new];
    [lbName setFont:maCellNameFont];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbName];
    
    
    ivKind = [UIImageView new];
    [ivKind setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:ivKind];
    
    
    lbSignature = [UILabel new];
    [lbSignature setTextColor:[UIColor darkGrayColor]];
    [lbSignature setTextAlignment:NSTextAlignmentLeft];
    [lbSignature setFont:maCellSignatureFont];
    [lbSignature setNumberOfLines:0];
    [self addSubview:lbSignature];
}




- (void)setUser:(LyUser *)user
{
    if (!user)
    {
        return;
    }
    
    _user = user;
    
    //头像
    NSString *strAvatarName;
    if (LyUserType_normal == _user.userType)
    {
        [ivAvatar.layer setCornerRadius:ftcIvAvatarSize/2.0f];
        strAvatarName = @"ct_avatar";
    }
    else
    {
        [ivAvatar.layer setCornerRadius:btnCornerRadius];
        strAvatarName = @"ds_avatar";
    }
    
    
    if (!_user.userAvatar)
    {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:_user.userId]
                    placeholderImage:[LyUtil imageForImageName:strAvatarName needCache:NO]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image)
                               {
                                   [_user setUserAvatar:image];
                               }
                               else
                               {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:_user.userId]
                                               placeholderImage:[LyUtil imageForImageName:strAvatarName needCache:NO]
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                          if (image)
                                                          {
                                                              [_user setUserAvatar:image];
                                                          }
                                                      }];
                               }
                           }];
    }
    else
    {
        [ivAvatar setImage:_user.userAvatar];
    }
    
    
    //姓名
    CGFloat fWidthLbName = [_user.userName sizeWithAttributes:@{NSFontAttributeName : maCellNameFont}].width;
    [lbName setFrame:CGRectMake( ivAvatar.frame.origin.x+ivAvatar.frame.size.width+horizontalSpace, ivAvatar.frame.origin.y, fWidthLbName, lbItemHeight)];
    [lbName setText:user.userName];
    
    
    //类别
    [ivKind setFrame:CGRectMake( lbName.frame.origin.x+lbName.frame.size.width+horizontalSpace, lbName.frame.origin.y, friCellIvKindWidth, lbItemHeight)];
    [LyUtil setAttentionKindImageView:ivKind withMode:_user.userType];
    
    
    
    
    //个人签名
    [lbSignature setFrame:CGRectMake( lbName.frame.origin.x, lbName.frame.origin.y+lbName.frame.size.height, SCREEN_WIDTH-friCellIvKindWidth-horizontalSpace*3, fcellHeight-lbName.frame.origin.y-lbItemHeight)];
    if (!user.userSignature || ![LyUtil validateString:_user.userSignature])
    {
        [lbSignature setText:@""];
    }
    else
    {
        [lbSignature setText:_user.userSignature];
    }
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
