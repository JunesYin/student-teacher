//
//  LyEvaluationForTeacherTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyEvaluationForTeacherTableViewCell.h"
#import "LyEvaluationForTeacher.h"
#import "LyReplyTableViewCell.h"

#import "LyUserManager.h"
#import "LyReply.h"

#import "LyUtil.h"


#define ecdtcWidth                          SCREEN_WIDTH
//CGFloat const ecdtcHeight = 60.0f;


CGFloat const ecdtcHorizontalSpace = 10.0f;
CGFloat const ecdtcVerticalSpace = 10.0f;

//头像
CGFloat const ecdtcIvAvatarWidth = 40.0f;
CGFloat const ecdtcIvAvatarHeight = ecdtcIvAvatarWidth;

//姓名
#define ecdtcLbNameWidth
CGFloat const ecdtcLbNameHeight = 15.0f;
#define ecdtcLbNameFont                     LyFont(16)

//时间
#define ecdtcLbTimeWidth
CGFloat const ecdtcLbTimeHeight = ecdtcLbNameHeight;
#define ecdtcLbTimeFont                     LyFont(13)

//评分文字
CGFloat const ecdtcLbScoreWidth = 35.0f;
CGFloat const ecdtcLbScoreHeight = ecdtcLbNameHeight;
#define ecdtcLbScoreFont                    LyFont(13)

//评分图像
CGFloat const ecdtcIvScoreHeight = ecdtcLbNameHeight;
#define ecdtcIvScoreWidth                   (ecdtcIvScoreHeight*6)

//内容
#define ecdtcTvContentWidth                 (ecdtcWidth-ecdtcHorizontalSpace*2)
#define ecdtcTvContentFont                  LyFont(14)

CGFloat const ecdtcLbReplyCountHeight = 20.0;
#define ecdtcLbReplyCountFont               LyFont(14)




@interface LyEvaluationForTeacherTableViewCell () <UITableViewDelegate, UITableViewDataSource>
{
    UIImageView     *ivAvatar;
    UILabel     *lbName;
    UILabel     *lbTime;
    UILabel     *lbScore;
    UIImageView     *ivScore;
    UITextView      *tvContent;
    
    
    float       heightForCell;
    int     indexForCell;
    BOOL        flagForResetHeight;
}

@property (strong, nonatomic)       UITableView     *tableView;

@property (strong, nonatomic)       UILabel     *lbReplyCount;

@end


@implementation LyEvaluationForTeacherTableViewCell

static NSString *const lyEvaluationForTeacherReplyTableViewCellReuseIdentifier = @"lyEvaluationForTeacherReplyTableViewCellReuseIdentifier";

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
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //头像
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( ecdtcHorizontalSpace, ecdtcVerticalSpace, ecdtcIvAvatarWidth, ecdtcIvAvatarHeight)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [[ivAvatar layer] setCornerRadius:ecdtcIvAvatarWidth/2.0f];
    [ivAvatar setClipsToBounds:YES];
    [self addSubview:ivAvatar];
    
    //姓名
    lbName = [UILabel new];
    [lbName setTextColor:LyBlackColor];
    [lbName setFont:ecdtcLbNameFont];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbName];
    
    //时间
    lbTime = [UILabel new];
    [lbTime setTextColor:LyBlackColor];
    [lbTime setFont:ecdtcLbTimeFont];
    [lbTime setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbTime];
    
    //评分图像
    ivScore = [[UIImageView alloc] initWithFrame:CGRectMake(ecdtcWidth-ecdtcHorizontalSpace-ecdtcIvScoreWidth, ivAvatar.frame.origin.y, ecdtcIvScoreWidth, ecdtcIvScoreHeight)];
    [ivScore setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:ivScore];
    
    //评分文字
    lbScore = [[UILabel alloc] initWithFrame:CGRectMake(ivScore.frame.origin.x - 3 - ecdtcLbScoreWidth, ivScore.frame.origin.y, ecdtcLbScoreWidth, ecdtcLbScoreHeight)];
    [lbScore setTextColor:Ly517ThemeColor];
    [lbScore setFont:ecdtcLbScoreFont];
    [lbScore setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbScore];
    
    
    //内容
    tvContent = [UITextView new];
    [tvContent setTextColor:LyBlackColor];
    [tvContent setFont:ecdtcTvContentFont];
    [tvContent setTextAlignment:NSTextAlignmentLeft];
    [tvContent setScrollEnabled:NO];
    [tvContent setEditable:NO];
    [tvContent setSelectable:NO];
    tvContent.userInteractionEnabled = NO;
    
    [self addSubview:tvContent];
    [self addSubview:self.tableView];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake( tvContent.frame.origin.x, tvContent.frame.origin.y + tvContent.frame.size.height + verticalSpace, ecdtcTvContentWidth, 0)
                                                  style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:LyWhiteLightgrayColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBounces:YES];
        [_tableView setScrollEnabled:NO];
        _tableView.userInteractionEnabled = NO;
    }
    
    return _tableView;
}

- (UILabel *)lbReplyCount {
    if (!_lbReplyCount) {
        _lbReplyCount = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, SCREEN_WIDTH - horizontalSpace * 2, ecdtcLbReplyCountHeight)];
        _lbReplyCount.font = ecdtcLbReplyCountFont;
        _lbReplyCount.textColor = [UIColor grayColor];
        _lbReplyCount.textAlignment = NSTextAlignmentLeft;
    }
    
    return _lbReplyCount;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setEva:(LyEvaluationForTeacher *)eva
{
    if ( !eva) {
        return;
    }
    
    _eva = eva;
    
    LyUser *evaMaster = [[LyUserManager sharedInstance] getUserWithUserId:[_eva masterId]];

    if ( ![evaMaster userAvatar]) {
//        if (LyUserType_normal == evaMaster.userType)
//        {
            [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[_eva masterId]]
                        placeholderImage:[LyUtil defaultAvatarForStudent]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   if (image)
                                   {
                                       [evaMaster setUserAvatar:image];
                                   }
                                   else
                                   {
                                       [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:_eva.masterId]
                                                           placeholderImage:[LyUtil defaultAvatarForStudent]
                                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                      if (image)
                                                                      {
                                                                          [evaMaster setUserAvatar:image];
                                                                      }
                                                                  }];
                                   }
                               }];
//        }
//        else
//        {
//            [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[_eva evaMasterId]]
//                        placeholderImage:[LyUtil defaultAvatarForTeacher]
//                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                   if (image)
//                                   {
//                                       [evaMaster setUserAvatar:image];
//                                   }
//                                   else
//                                   {
//                                       [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:_eva.evaMasterId]
//                                                           placeholderImage:[LyUtil defaultAvatarForTeacher]
//                                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                                                      if (image)
//                                                                      {
//                                                                          [evaMaster setUserAvatar:image];
//                                                                      }
//                                                                  }];
//                                   }
//                               }];
//        }
    }
    else
    {
        [ivAvatar setImage:[evaMaster userAvatar]];
    }
    
    
    
    //姓名
    CGSize sizeLbName = [evaMaster.userName sizeWithAttributes:@{NSFontAttributeName:ecdtcLbNameFont}];
    [lbName setFrame:CGRectMake( ivAvatar.frame.origin.x+ivAvatar.frame.size.width+ecdtcHorizontalSpace, ivAvatar.frame.origin.y+2, sizeLbName.width, ecdtcLbNameHeight)];
    [lbName setText:evaMaster.userName];
    
    //时间
    NSString *strLbTime = [LyUtil translateTime:_eva.time];
    CGFloat fWidthLbTime = [strLbTime sizeWithAttributes:@{NSFontAttributeName:ecdtcLbTimeFont}].width;
    [lbTime setFrame:CGRectMake( lbName.frame.origin.x, ivAvatar.frame.origin.y+ivAvatar.frame.size.height-2-ecdtcLbTimeHeight, fWidthLbTime, ecdtcLbTimeHeight)];
    [lbTime setText:strLbTime];
    
    
    //评分图像
    [LyUtil setScoreImageView:ivScore withScore:_eva.score];
    
    //评分文字
    [lbScore setText:[[NSString alloc] initWithFormat:@"%.1f分", _eva.score]];
    
    //内容
    [tvContent setText:[_eva content]];
    CGFloat fHeightTvContent = [tvContent sizeThatFits:CGSizeMake(ecdtcTvContentWidth, MAXFLOAT)].height;
    CGRect rectTest = CGRectMake( ecdtcHorizontalSpace, ivAvatar.frame.origin.y+ivAvatar.frame.size.height, ecdtcTvContentWidth, fHeightTvContent);
    [tvContent setFrame:rectTest];
    
    
    if (LyEvaluationForTeacherTableViewCellMode_detail == _mode) {
        [_lbReplyCount removeFromSuperview];
        [self addSubview:self.tableView];
        self.tableView.frame = CGRectMake( horizontalSpace, tvContent.frame.origin.y + CGRectGetHeight(tvContent.frame) + verticalSpace, SCREEN_WIDTH - horizontalSpace * 2, 0);
        
        if (_eva.arrReply.count > 0) {
            [self.tableView reloadData];
        }
        
        _height = self.tableView.frame.origin.y + CGRectGetHeight(self.tableView.frame) + verticalSpace;
        
    } else {
        [_tableView removeFromSuperview];
        [self addSubview:self.lbReplyCount];
        
        self.lbReplyCount.frame = CGRectMake(horizontalSpace, tvContent.frame.origin.y + CGRectGetHeight(tvContent.frame), SCREEN_WIDTH - horizontalSpace * 2, ecdtcLbReplyCountHeight);
        self.lbReplyCount.text = [[NSString alloc] initWithFormat:@"回复（%ld）", _eva.replyCount];
        
        _height = self.lbReplyCount.frame.origin.y + CGRectGetHeight(self.lbReplyCount.frame) + verticalSpace;
        
    }
    
    _eva.height = _height;
    
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    LyReply *reply = _eva.arrReply[indexPath.row];
    if (LyChatCellHeightMin > reply.height || reply.height > LyChatCellHeightMax) {
        LyReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyEvaluationForTeacherReplyTableViewCellReuseIdentifier];
        if (!cell) {
            cell = [[LyReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyEvaluationForTeacherReplyTableViewCellReuseIdentifier];
        }
        cell.reply = reply;
    }
    
    height = reply.height;
    
    if ( !flagForResetHeight) {
        if (_eva.arrReply.count > indexPath.row + 1) {
            heightForCell += height;
            
        } else {
            flagForResetHeight = YES;
            heightForCell += height;
            
            self.tableView.frame = CGRectMake( tvContent.frame.origin.x, tvContent.frame.origin.y+CGRectGetHeight(tvContent.frame), ecdtcTvContentWidth, heightForCell);
            
            _height = self.tableView.frame.origin.y + CGRectGetHeight(self.tableView.frame);
            
        }
    }
    
    return height;
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _eva.arrReply.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyEvaluationForTeacherReplyTableViewCellReuseIdentifier];
    if (!cell) {
        cell = [[LyReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyEvaluationForTeacherReplyTableViewCellReuseIdentifier];
    }
    
    cell.reply = _eva.arrReply[indexPath.row];
    
    return cell;
}



@end
