//
//  LyReplyTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/29.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyReplyTableViewCell.h"

#import "LyUserManager.h"
#import "LyAboutMeManager.h"
#import "LyReplyManager.h"

#import "LyUtil.h"



#define lbContentFont           LyFont(12)



@interface LyReplyTableViewCell ()
{
    UILabel             *lbContent;
}
@end


@implementation LyReplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        lbContent = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, 0, rcellWidth, 20)];
        [lbContent setTextColor:LyBlackColor];
        [lbContent setFont:lbContentFont];
        [lbContent setTextAlignment:NSTextAlignmentLeft];
        lbContent.numberOfLines = 0;
        
        [self addSubview:lbContent];
    }
    
    return self;
}


- (void)setAboutMe:(LyAboutMe *)aboutMe
{
    if ( !aboutMe)
    {
        return;
    }
    _aboutMe = aboutMe;
    
    
    NSMutableAttributedString *strText;
    switch ( [_aboutMe amMode]) {
        case LyAboutMeMode_praise: {
            
            break;
        }
        case LyAboutMeMode_transmit: {
            
            break;
        }
        case LyAboutMeMode_evaluate: {
            NSString *strMasterName = [[LyUserManager sharedInstance] getUserNameWithId:[_aboutMe amMasterId]];
            NSString *strTextTmp = [[NSString alloc] initWithFormat:@"%@：%@", strMasterName, [_aboutMe amContent]];
            strText = [[NSMutableAttributedString alloc] initWithString:strTextTmp];
            [strText addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strTextTmp rangeOfString:strMasterName]];
            break;
        }
        case LyAboutMeMode_reply: {
            NSString *strMasterName = [[LyUserManager sharedInstance] getUserNameWithId:[_aboutMe amMasterId]];
            NSString *strObjectName = [[LyUserManager sharedInstance] getUserNameWithId:[_aboutMe amObjectId]];
            NSString *strTextTmp = [[NSString alloc] initWithFormat:@"%@回复%@：%@", strMasterName, strObjectName, [_aboutMe amContent]];
            strText = [[NSMutableAttributedString alloc] initWithString:strTextTmp];
            if ([strMasterName isEqualToString:strObjectName])
            {
                [strText addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strTextTmp rangeOfString:strMasterName]];
                [strText addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strTextTmp rangeOfString:strObjectName options:NSCaseInsensitiveSearch range:NSMakeRange(strMasterName.length, strTextTmp.length-strMasterName.length)]];
            }
            else
            {
                [strText addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strTextTmp rangeOfString:strMasterName]];
                [strText addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strTextTmp rangeOfString:strObjectName]];
            }
            break;
        }
    }
    
    [lbContent setAttributedText:strText];
    CGFloat fHeightLb = [lbContent sizeThatFits:CGSizeMake( rcellWidth, 100.0f)].height;
    
    _height = fHeightLb + horizontalSpace;
    
    [lbContent setFrame:CGRectMake( horizontalSpace, 0, rcellWidth, _height)];
    
    
}



- (void)setReply:(LyReply *)reply
{
    if ( !reply)
    {
        return;
    }
    _reply = reply;
    
    
    NSMutableAttributedString *strText;

    NSString *strMasterName = [[LyUserManager sharedInstance] getUserNameWithId:[_reply masterId]];
    NSString *strObjectName = [[LyUserManager sharedInstance] getUserNameWithId:[_reply objectId]];
    NSString *strTextTmp = [[NSString alloc] initWithFormat:@"%@回复%@：%@", strMasterName, strObjectName, [_reply content]];
    strText = [[NSMutableAttributedString alloc] initWithString:strTextTmp];
//    [strText addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strTextTmp rangeOfString:strMasterName]];
//    [strText addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strTextTmp rangeOfString:strObjectName]];
    if ([strMasterName isEqualToString:strObjectName])
    {
        [strText addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strTextTmp rangeOfString:strMasterName]];
        [strText addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strTextTmp rangeOfString:strObjectName options:NSCaseInsensitiveSearch range:NSMakeRange(strMasterName.length, strTextTmp.length-strMasterName.length)]];
    }
    else
    {
        [strText addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strTextTmp rangeOfString:strMasterName]];
        [strText addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strTextTmp rangeOfString:strObjectName]];
    }

    
    [lbContent setAttributedText:strText];
    CGFloat fHeightLb = [lbContent sizeThatFits:CGSizeMake(rcellWidth, 100.0f)].height;
    
    _height = fHeightLb + horizontalSpace;
    
    [lbContent setFrame:CGRectMake(horizontalSpace, 0, rcellWidth, _height)];
    
    reply.height = _height;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
