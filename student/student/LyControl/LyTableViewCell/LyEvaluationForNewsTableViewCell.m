//
//  LyEvaluationForNewsTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyEvaluationForNewsTableViewCell.h"

#import "LyReplyTableViewCell.h"

#import "LyEvaluation.h"
#import "LyReplyManager.h"
#import "LyAboutMeManager.h"
#import "LyUserManager.h"

#import "UIImageView+WebCache.h"

#import "LyUtil.h"



#define efntcWidth                                  SCREEN_WIDTH
CGFloat const efntcHeight = 60.0f;



//头像
CGFloat const efntcIvAvatarWidth = 40.0f;
CGFloat const efntcIvAvatarHeight = efntcIvAvatarWidth;

//姓名
#define efntcLbNameWidth
CGFloat const efntcLbNameHeight = 15.0f;
#define efntcLbNameFont                             LyFont(16)

//时间
#define efntcLbTimeWidth
CGFloat const efntcLbTimeHeight = efntcLbNameHeight;
#define efntcLbTimeFont                             LyFont(13)

//评分文字
CGFloat const efntcLbScoreWidth = 35.0f;
CGFloat const efntcLbScoreHeight = efntcLbNameHeight;
#define efntcLbScoreFont                            LyFont(13)

//评分图像
CGFloat const efntcIvScoreHeight = efntcLbNameHeight;
#define efntcIvScoreWidth                           (efntcIvScoreHeight*6)

//内容
#define efntcTvContentWidth                         (efntcWidth-horizontalSpace*2)
#define efntcTvContentHeight
#define efntcTvContentFont                          LyFont(14)


NSString *const lyEvaluationForNewsReplyTableViewCellReuseIdentifier = @"lyEvaluationForNewsReplyTableViewCellReuseIdentifier";

@interface LyEvaluationForNewsTableViewCell ()< UITableViewDelegate, UITableViewDataSource>
{
    UIImageView             *ivAvatar;
    UILabel                 *lbName;
    UILabel                 *lbTime;
    UITextView              *tvContent;
    
    UITableView             *tvReply;
    
    
    BOOL                    flagSetTvReply;
    CGFloat                 heightSetTvReply;
    NSArray                 *arrReply;
}
@end


@implementation LyEvaluationForNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndAddSubview];
    }
    
    
    return self;
}


- (void)initAndAddSubview
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //头像
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, verticalSpace, efntcIvAvatarWidth, efntcIvAvatarHeight)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [[ivAvatar layer] setCornerRadius:efntcIvAvatarWidth/2.0f];
    [ivAvatar setClipsToBounds:YES];
    [self addSubview:ivAvatar];
    
    //姓名
    lbName = [UILabel new];
    [lbName setTextColor:LyBlackColor];
    [lbName setFont:efntcLbNameFont];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbName];
    
    //时间
    lbTime = [UILabel new];
    [lbTime setTextColor:LyBlackColor];
    [lbTime setFont:efntcLbTimeFont];
    [lbTime setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbTime];
    
    //内容
    tvContent = [UITextView new];
    [tvContent setTextColor:LyBlackColor];
    [tvContent setFont:efntcTvContentFont];
    [tvContent setTextAlignment:NSTextAlignmentLeft];
    [tvContent setScrollEnabled:NO];
    [tvContent setEditable:NO];
    
    [self addSubview:tvContent];
    
    
    tvReply = [[UITableView alloc] initWithFrame:CGRectMake( horizontalSpace, 0, rcellWidth, 10.0f)
                                           style:UITableViewStylePlain];
    [tvReply setDelegate:self];
    [tvReply setDataSource:self];
    [tvReply setScrollsToTop:NO];
    [tvReply setScrollEnabled:NO];
    [tvReply setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:tvReply];
    
}



- (void)setEva:(LyEvaluation *)eva
{
    if ( !eva)
    {
        return;
    }
    
    flagSetTvReply = NO;
    heightSetTvReply = 0;
    
    _eva = eva;
    
    LyUser *evaMaster = [[LyUserManager sharedInstance] getUserWithUserId:[_eva masterId]];

    
    //头像
    if ( ![evaMaster userAvatar])
    {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[evaMaster userId]]
                    placeholderImage:[LyUtil defaultAvatarForStudent]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image)
                               {
                                   [evaMaster setUserAvatar:image];
                               }
                               else
                               {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:evaMaster.userId]
                                                       placeholderImage:[LyUtil defaultAvatarForStudent]
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                  if (image) {
                                                                      [evaMaster setUserAvatar:image];
                                                                  }
                                                              }];
                               }
                           }];
    }
    else
    {
        [ivAvatar setImage:[evaMaster userAvatar]];
    }
    
    
    
    //姓名
    CGSize sizeLbName = [evaMaster.userName sizeWithAttributes:@{NSFontAttributeName:efntcLbNameFont}];
    [lbName setFrame:({
        CGRectMake( ivAvatar.frame.origin.x+ivAvatar.frame.size.width+horizontalSpace, ivAvatar.frame.origin.y+2, sizeLbName.width, efntcLbNameHeight);
    })];
    [lbName setText:evaMaster.userName];
    
    //时间
    NSString *strLbTime = [LyUtil translateTime:[_eva time]];
    CGFloat fWidthLbTime = [strLbTime sizeWithAttributes:@{NSFontAttributeName:efntcLbTimeFont}].width;
    [lbTime setFrame:CGRectMake( lbName.frame.origin.x, ivAvatar.frame.origin.y+ivAvatar.frame.size.height-2-efntcLbTimeHeight, fWidthLbTime, efntcLbTimeHeight)];
    [lbTime setText:strLbTime];
    
    
    //内容
    [tvContent setText:[_eva content]];
    CGFloat fHeightTvContent =  [tvContent sizeThatFits:CGSizeMake(efntcTvContentWidth, MAXFLOAT)].height;
    CGRect rectTest = CGRectMake( horizontalSpace, ivAvatar.frame.origin.y+ivAvatar.frame.size.height, efntcTvContentWidth, fHeightTvContent);
    [tvContent setFrame:rectTest];
    
    _height = tvContent.frame.origin.y+CGRectGetHeight(tvContent.frame)+verticalSpace;
    
    
    arrReply = [[LyReplyManager sharedInstance] addtionalReplyWithEvaluation:_eva];
    if ( [arrReply count] > 0)
    {
        [tvReply setHidden:NO];
        [tvReply reloadData];
    }
    else
    {
        [tvReply setHidden:YES];
    }
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyEvaluationForNewsReplyTableViewCellReuseIdentifier];
    if ( !cell)
    {
        cell = [[LyReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyEvaluationForNewsReplyTableViewCellReuseIdentifier];
    }
    [cell setReply:[arrReply objectAtIndex:[indexPath row]]];
    
    if ( !flagSetTvReply)
    {
        if ( [indexPath row] < [arrReply count]-1)
        {
            heightSetTvReply += [cell height];
        }
        else
        {
            flagSetTvReply = YES;
            heightSetTvReply += [cell height];
            
            [tvReply setFrame:CGRectMake( horizontalSpace, tvContent.frame.origin.y+CGRectGetHeight(tvContent.frame)+verticalSpace, rcellWidth, heightSetTvReply)];
            
            
            _height = [tvReply frame].origin.y + CGRectGetHeight(tvReply.frame) +verticalSpace;
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
    LyReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyEvaluationForNewsReplyTableViewCellReuseIdentifier];
    if ( !cell)
    {
        cell = [[LyReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyEvaluationForNewsReplyTableViewCellReuseIdentifier];
    }
    [cell setReply:[arrReply objectAtIndex:[indexPath row]]];
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
