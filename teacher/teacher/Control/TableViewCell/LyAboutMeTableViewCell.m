//
//  LyAboutMeTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyAboutMeTableViewCell.h"
#import "LyReplyTableViewCell.h"

#import "LyAboutMeManager.h"
#import "LyUserManager.h"
#import "LyCurrentUser.h"
#import "LyNewsManager.h"

#import "LyUtil.h"








#define amcellWidth                         SCREEN_WIDTH

CGFloat const btnReplyWidth = 40.0f;
CGFloat const btnReplyHeight = 20.0f;

CGFloat const amtcIvAvatarSize = 50.0f;

#define amtcLbNameWidth                         (amcellWidth-amtcIvAvatarSize-btnReplyWidth-horizontalSpace*4)
CGFloat const amtcLbNameHeight = 30.0f;
#define lbNameFont                          LyFont(14)

#define lbTimeWidth                         amtcLbNameWidth
CGFloat const lbTimeHeight = 20.0f;
#define lbTimeFont                          LyFont(12)

#define amtcViewStatusWidth                     (amcellWidth-horizontalSpace*2)
CGFloat const amtcViewStatusHeight = 40.0f;
#define lbStatusWidth                       (amtcViewStatusWidth-horizontalSpace*2)
CGFloat const amtcLbStatusHeight = amtcViewStatusHeight;
#define lbStatusFont                        LyFont(12)


#define tvReplyWidth                        (amcellWidth-horizontalSpace*2)
CGFloat const tvReplyHeight = 10.0f;



 NSString *const lyAboutMeReplayTableViewCellReuseIdentifier = @"lyAboutMeReplayTableViewCellReuseIdentifier";


@interface LyAboutMeTableViewCell () <UITableViewDelegate, UITableViewDataSource>
{
    UIButton                        *btnReply;
    
    UIImageView                     *ivAvatar;
    UILabel                         *lbName;
    UILabel                         *lbTime;
    
    UIView                          *viewStatus;
    UILabel                         *lbStatus;
    
    UITableView                     *tvReplay;
    
    
    NSArray                         *arrReply;
    BOOL                            flagSetTvRepaly;
    CGFloat                         heightTvReplay;
}
@end


@implementation LyAboutMeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndLayoutSubviews];
    }
    
    return self;
}


- (void)initAndLayoutSubviews
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    btnReply = [[UIButton alloc] initWithFrame:CGRectMake( amcellWidth-horizontalSpace-btnReplyWidth, verticalSpace*2, btnReplyWidth, btnReplyHeight)];
    [btnReply addTarget:self action:@selector(targetForButtonReplay:) forControlEvents:UIControlEventTouchUpInside];
    [btnReply setImage:[LyUtil imageForImageName:@"btn_reply" needCache:NO] forState:UIControlStateNormal];
    [self addSubview:btnReply];
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, verticalSpace, amtcIvAvatarSize, amtcIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar setClipsToBounds:YES];
    [[ivAvatar layer] setCornerRadius:amtcIvAvatarSize/2.0f];
    [self addSubview:ivAvatar];
    
    UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForUserTapGesture:)];
    [tapAvatar setNumberOfTapsRequired:1];
    [tapAvatar setNumberOfTouchesRequired:1];
    [ivAvatar setUserInteractionEnabled:YES];
    [ivAvatar addGestureRecognizer:tapAvatar];
    
    lbName = [[UILabel alloc] initWithFrame:CGRectMake( ivAvatar.ly_y+CGRectGetWidth(ivAvatar.frame)+horizontalSpace, ivAvatar.ly_y, amtcLbNameWidth, amtcLbNameHeight)];
    [lbName setFont:lbNameFont];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbName];
    
    UITapGestureRecognizer *nameAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForUserTapGesture:)];
    [nameAvatar setNumberOfTapsRequired:1];
    [nameAvatar setNumberOfTouchesRequired:1];
    [lbName setUserInteractionEnabled:YES];
    [lbName addGestureRecognizer:nameAvatar];
    
    
    lbTime = [[UILabel alloc] initWithFrame:CGRectMake( lbName.frame.origin.x, lbName.ly_y+CGRectGetHeight(lbName.frame), lbTimeWidth, lbTimeHeight)];
    [lbTime setFont:lbTimeFont];
    [lbTime setTextAlignment:NSTextAlignmentLeft];
    [lbTime setTextColor:[UIColor darkGrayColor]];
    [self addSubview:lbTime];
    
    
    viewStatus = [[UIView alloc] initWithFrame:CGRectMake( horizontalSpace, ivAvatar.ly_y+CGRectGetHeight(ivAvatar.frame)+verticalSpace, amtcViewStatusWidth, amtcViewStatusHeight)];
    [viewStatus setBackgroundColor:LyWhiteLightgrayColor];
    
    lbStatus = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, 0, lbStatusWidth, amtcLbStatusHeight)];
    [lbStatus setFont:lbStatusFont];
    [lbStatus setTextAlignment:NSTextAlignmentLeft];
    [lbStatus setTextColor:[UIColor darkGrayColor]];
    [viewStatus addSubview:lbStatus];
    
    UITapGestureRecognizer *newsAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForNewsTapGesture:)];
    [newsAvatar setNumberOfTapsRequired:1];
    [newsAvatar setNumberOfTouchesRequired:1];
    [viewStatus setUserInteractionEnabled:YES];
    [viewStatus addGestureRecognizer:newsAvatar];

    
    [self addSubview:viewStatus];
    
    
    tvReplay = [[UITableView alloc] initWithFrame:CGRectMake( horizontalSpace, viewStatus.ly_y+CGRectGetHeight(viewStatus.frame)+verticalSpace, tvReplyWidth, tvReplyHeight)
                                            style:UITableViewStylePlain];
    [tvReplay setDelegate:self];
    [tvReplay setDataSource:self];
    [tvReplay setScrollsToTop:NO];
    [tvReplay setScrollEnabled:NO];
    [tvReplay setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [tvReplay registerClass:[LyReplyTableViewCell class] forCellReuseIdentifier:lyAboutMeReplayTableViewCellReuseIdentifier];
    [self addSubview:tvReplay];
    
    
}


- (void)setAboutMe:(LyAboutMe *)aboutMe
{
    if ( !aboutMe)
    {
        return;
    }
    
    flagSetTvRepaly = NO;
    heightTvReplay = 0;
    
    _aboutMe = aboutMe;
    
    LyUser *master = [[LyUserManager sharedInstance] getUserWithUserId:[_aboutMe amMasterId]];
    if ( !master)
    {
        NSString *strName = [LyUtil getUserNameWithUserId:[_aboutMe amMasterId]];
        master = [LyUser userWithId:[_aboutMe amMasterId]
                           userNmae:strName];
        
        [[LyUserManager sharedInstance] addUser:master];
    }
    
    LyUser *object = [[LyUserManager sharedInstance] getUserWithUserId:[_aboutMe amObjectId]];
    if ( !object)
    {
        NSString *strName = [LyUtil getUserNameWithUserId:[_aboutMe amObjectId]];
        object = [LyUser userWithId:[_aboutMe amObjectId]
                           userNmae:strName];
        
        [[LyUserManager sharedInstance] addUser:object];
    }
    
    LyNews *news = [[LyNewsManager sharedInstance] getNewsWithNewsId:_aboutMe.amNewsId];
    
    LyUser *statusMaster = [[LyUserManager sharedInstance] getUserWithUserId:news.newsMasterId];
    if ( !statusMaster) {
        NSString *strName = [LyUtil getUserNameWithUserId:news.newsMasterId];
        statusMaster = [LyUser userWithId:news.newsMasterId
                                 userNmae:strName];
        
        [[LyUserManager sharedInstance] addUser:statusMaster];
    }
    
    if ( ![master userAvatar]) {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[_aboutMe amMasterId]]
                    placeholderImage:[LyUtil defaultAvatarForStudent]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image) {
                                   [master setUserAvatar:image];
                               }
                               else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:[_aboutMe amMasterId]]
                                               placeholderImage:[LyUtil defaultAvatarForStudent]
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                  if (image) {
                                                                      [master setUserAvatar:image];
                                                                  }
                                                              }];
                               }
                           }];
    }
    else
    {
        [ivAvatar setImage:[master userAvatar]];
    }
    
    
    [lbName setText:[[NSString alloc] initWithFormat:@"%@ %@", [master userName], ({
        NSString *str;
        switch ( [_aboutMe amMode]) {
            case LyAboutMeMode_praise: {
                str = @"赞了我的动态";
                break;
            }
            case LyAboutMeMode_transmit: {
                str = @"转发了我的动态";
                break;
            }
            case LyAboutMeMode_evaluate: {
                str = @"评价了我的动态";
                break;
            }
            case LyAboutMeMode_reply: {
                str = @"回复了我";
                break;
            }
            default: {
                str = @"";
                break;
            }
        }
        str;
    })]];
    
    
    [lbTime setText:[LyUtil translateTime:_aboutMe.amTime]];
    
    NSString *strLbStatusTmp = [[NSString alloc] initWithFormat:@"%@：%@", statusMaster.userName, news];
    NSMutableAttributedString *strLbStatus = [[NSMutableAttributedString alloc] initWithString:strLbStatusTmp];
    [strLbStatus addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strLbStatusTmp rangeOfString:[statusMaster userName]]];
    [lbStatus setAttributedText:strLbStatus];
    
    
    _height = viewStatus.ly_y+CGRectGetHeight(viewStatus.frame)+verticalSpace;
    
    if ( [_aboutMe amMode] >= LyAboutMeMode_evaluate)
    {
        [btnReply setHidden:NO];
        [tvReplay setHidden:NO];
        arrReply = [[LyAboutMeManager sharedInstance] additionalAboutMeWithAboutMe:_aboutMe];
        [tvReplay reloadData];
    }
    else
    {
        [tvReplay setHidden:YES];
        [btnReply setHidden:YES];
    }
}



- (void)targetForButtonReplay:(UIButton *)button
{
    if ( [_delegate respondsToSelector:@selector(onClickedButtonReplyByAboutMeTableViewCell:)])
    {
        [_delegate onClickedButtonReplyByAboutMeTableViewCell:self];
    }
}


- (void)targetForUserTapGesture:(UITapGestureRecognizer *)tapGesture
{
    if ( [_delegate respondsToSelector:@selector(onClickedUserByAboutMeTableViewCell:)])
    {
        [_delegate onClickedUserByAboutMeTableViewCell:self];
    }
}

- (void)targetForNewsTapGesture:(UITapGestureRecognizer *)tapGesture
{
    if ( [_delegate respondsToSelector:@selector(onClickedNewsByAboutMeTableViewCell:)])
    {
        [_delegate onClickedNewsByAboutMeTableViewCell:self];
    }
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyAboutMeReplayTableViewCellReuseIdentifier];
    if ( !cell)
    {
        cell = [[LyReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyAboutMeReplayTableViewCellReuseIdentifier];
    }
    [cell setAboutMe:[arrReply objectAtIndex:[indexPath row]]];
    
    if ( !flagSetTvRepaly)
    {
        if ( [indexPath row] < [arrReply count]-1)
        {
            heightTvReplay += [cell height];
        }
        else
        {
            flagSetTvRepaly = YES;
            heightTvReplay += [cell height];
            
            [tvReplay setFrame:CGRectMake( horizontalSpace, viewStatus.ly_y+CGRectGetHeight(viewStatus.frame)+verticalSpace, tvReplyWidth, heightTvReplay)];
            
            _height = tvReplay.ly_y + CGRectGetHeight(tvReplay.frame)+verticalSpace;
        }
    }
    
    return [cell height];
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrReply count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyAboutMeReplayTableViewCellReuseIdentifier];
    if ( !cell)
    {
        cell = [[LyReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyAboutMeReplayTableViewCellReuseIdentifier];
    }
    
    [cell setAboutMe:[arrReply objectAtIndex:[indexPath row]]];
    
    
    return cell;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
