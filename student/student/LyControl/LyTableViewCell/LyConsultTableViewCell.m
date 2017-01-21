//
//  LyConsultTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/15.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyConsultTableViewCell.h"
#import "LyReplyTableViewCell.h"


#import "LyUserManager.h"
#import "LyConsult.h"
#import "LyReply.h"

#import "LyUtil.h"


#define contcWidth                                  SCREEN_WIDTH


CGFloat const ctcIvAvatarSize = 40.0f;

CGFloat const ctcLbNameHeight = 20.0f;
#define lbNameFont                                  LyFont(16)

CGFloat const ctcLbTimeHeight = ctcLbNameHeight;
#define lbTimeFont                                  LyFont(13)

#define ctcTvContentWidth                           (contcWidth-horizontalSpace*2)
CGFloat const ctcTvContentHeight = 0.0f;
#define tvContentFont                               LyFont(14)

#define ctcTvEvalutionWidth                         ctcTvContentWidth
CGFloat const ctcTvEvalutionHeight = 0.0f;

CGFloat const ctcLbReplyCountHeight = 20.0f;
#define ctcLbReplyCountFont                         LyFont(14)



@interface LyConsultTableViewCell () < UITableViewDelegate, UITableViewDataSource>
{
    UIImageView     *ivAvatar;
    UILabel     *lbName;
    UILabel     *lbTime;
    
    UITextView      *tvContent;
    
    float       heightForCell;
    int     indexForCell;
    BOOL        flagForResetHeight;
}

@property (strong, nonatomic)       UITableView     *tableView;

@property (strong, nonatomic)       UILabel     *lbReplyCount;

@end

@implementation LyConsultTableViewCell


static NSString *lyConsultTableViewCellReuseIdentifier = @"lyConsultTableViewCellReuseIdentifier";


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
    
    ivAvatar = [[UIImageView alloc] initWithFrame:CGRectMake( horizontalSpace, verticalSpace, ctcIvAvatarSize, ctcIvAvatarSize)];
    [ivAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [ivAvatar setClipsToBounds:YES];
    [[ivAvatar layer] setCornerRadius:ctcIvAvatarSize/2.0f];
    [self addSubview:ivAvatar];
    
    
    lbName = [UILabel new];
    [lbName setFont:lbNameFont];
    [lbName setTextColor:LyBlackColor];
    [lbName setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbName];
    
    
    lbTime = [UILabel new];
    [lbTime setFont:lbTimeFont];
    [lbTime setTextColor:LyDarkgrayColor];
    [lbTime setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:lbTime];
    
    
    tvContent = [UITextView new];
    [tvContent setFont:tvContentFont];
    [tvContent setTextColor:LyBlackColor];
    [tvContent setEditable:NO];
    [tvContent setScrollEnabled:NO];
    [tvContent setSelectable:NO];
    [tvContent setTextAlignment:NSTextAlignmentLeft];
    tvContent.userInteractionEnabled = NO;
    
    [self addSubview:tvContent];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake( tvContent.frame.origin.x, tvContent.frame.origin.y + tvContent.frame.size.height + verticalSpace, ctcTvEvalutionWidth, ctcTvEvalutionHeight)
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
        _lbReplyCount = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, SCREEN_WIDTH - horizontalSpace * 2, ctcLbReplyCountHeight)];
        _lbReplyCount.font = ctcLbReplyCountFont;
        _lbReplyCount.textColor = [UIColor grayColor];
        _lbReplyCount.textAlignment = NSTextAlignmentLeft;
    }
    
    return _lbReplyCount;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setConsult:(LyConsult *)consult
{
    _consult = consult;
    if ( !_consult)
    {
        return;
    }
    
    heightForCell = 0;
    indexForCell = 0;
    
    
    LyUser *conMaster = [[LyUserManager sharedInstance] getUserWithUserId:_consult.masterId];

    if ( ![conMaster userAvatar]) {
        [ivAvatar sd_setImageWithURL:[LyUtil getUserAvatarUrlWithUserId:[_consult masterId]]
                    placeholderImage:[LyUtil defaultAvatarForStudent]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (image) {
                                   [conMaster setUserAvatar:image];
                               } else {
                                   [ivAvatar sd_setImageWithURL:[LyUtil getJpgUserAvatarUrlWithUserId:[_consult masterId]]
                                                       placeholderImage:[LyUtil defaultAvatarForStudent]
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                  if (image) {
                                                                      [conMaster setUserAvatar:image];
                                                                  }
                                                              }];
                               }
                           }];
    }
    else
    {
        [ivAvatar setImage:[conMaster userAvatar]];
    }
    

    CGFloat fWidthLbName = [conMaster.userName sizeWithAttributes:@{NSFontAttributeName:lbNameFont}].width;
    [lbName setFrame:CGRectMake(ivAvatar.frame.origin.x+ivAvatar.frame.size.width+horizontalSpace, ivAvatar.frame.origin.y, fWidthLbName, ctcLbNameHeight)];
    [lbName setText:conMaster.userName];
    
    
    NSString *strLbTime = [LyUtil translateTime:[_consult time]];
    CGFloat fWidthLbTime = [strLbTime sizeWithAttributes:@{NSFontAttributeName:lbTimeFont}].width;
    [lbTime setFrame:CGRectMake(lbName.frame.origin.x, lbName.frame.origin.y+CGRectGetHeight(lbName.frame), fWidthLbTime, ctcLbTimeHeight)];
    [lbTime setText:strLbTime];
    
    
    [tvContent setText:[_consult content]];
    CGFloat fHeightTvContent =  [tvContent sizeThatFits:CGSizeMake(ctcTvContentWidth, MAXFLOAT)].height;
    [tvContent setFrame:CGRectMake( contcWidth/2-ctcTvContentWidth/2, ivAvatar.frame.origin.y+CGRectGetHeight(ivAvatar.frame)+verticalSpace, ctcTvContentWidth, fHeightTvContent)];
    
    
    
    if (LyConsultTableViewCellMode_detail == _mode) {
        [_lbReplyCount removeFromSuperview];
        [self addSubview:self.tableView];
        self.tableView.frame = CGRectMake( tvContent.frame.origin.x, tvContent.frame.origin.y+CGRectGetHeight(tvContent.frame)+verticalSpace, ctcTvEvalutionWidth, 0);
        
        if (_consult.arrReply.count > 0) {
            [self.tableView reloadData];
        }
        
        _height = self.tableView.frame.origin.y + CGRectGetHeight(self.tableView.frame) + horizontalSpace;
        
    } else {
        [_tableView removeFromSuperview];
        [self addSubview:self.lbReplyCount];
        
        self.lbReplyCount.frame = CGRectMake(horizontalSpace, tvContent.frame.origin.y + CGRectGetHeight(tvContent.frame), SCREEN_WIDTH - horizontalSpace * 2, ctcLbReplyCountHeight);
        self.lbReplyCount.text = [[NSString alloc] initWithFormat:@"回复（%ld）", _consult.replyCount];
        
        _height = self.lbReplyCount.frame.origin.y + CGRectGetHeight(self.lbReplyCount.frame) + horizontalSpace;
        
    }

    _consult.height = _height;
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    LyReply *reply = _consult.arrReply[indexPath.row];
    if (LyChatCellHeightMin > reply.height || reply.height > LyChatCellHeightMax) {
        LyReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyConsultTableViewCellReuseIdentifier];
        if (!cell) {
            cell = [[LyReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyConsultTableViewCellReuseIdentifier];
        }
        cell.reply = reply;
    }
    
    height = reply.height;
    
    if ( !flagForResetHeight) {
        if (_consult.arrReply.count > indexPath.row + 1) {
            heightForCell += height;
            
        } else {
            flagForResetHeight = YES;
            heightForCell += height;
            
            self.tableView.frame = CGRectMake( tvContent.frame.origin.x, tvContent.frame.origin.y+CGRectGetHeight(tvContent.frame), ctcTvEvalutionWidth, heightForCell);
            
            _height = self.tableView.frame.origin.y + CGRectGetHeight(self.tableView.frame) + horizontalSpace;
            
        }
    }
    
    return height;
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _consult.arrReply.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyConsultTableViewCellReuseIdentifier];
    if (!cell) {
        cell = [[LyReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyConsultTableViewCellReuseIdentifier];
    }
    
    cell.reply = _consult.arrReply[indexPath.row];
    
    return cell;
}




@end
