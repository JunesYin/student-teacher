//
//  LyEvaluationTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyEvaluationTableViewCell.h"
#import "LyEvaluationManager.h"
#import "LyUserManager.h"
#import "UIViewController+Utils.h"
#import "LyUtil.h"





#define evaWidth                                CGRectGetWidth(self.frame)

#define tvContentWidth                          (evaWidth-horizontalSpace*4)
#define tvContentFont                           LyFont(13)


@interface LyEvaluationTableViewCell ()
{
    UITextView              *tvContent;
    
    LyUser                  *evaMaster;
}
@end


@implementation LyEvaluationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initAndAddSubView];
    }
    
    
    return self;
}


- (void)initAndAddSubView
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    tvContent = [[UITextView alloc] init];
    [tvContent setFont:tvContentFont];
    [tvContent setTextColor:LyDarkgrayColor];
    [tvContent setBackgroundColor:[UIColor clearColor]];
    [tvContent setTextAlignment:NSTextAlignmentLeft];
    [tvContent setEditable:NO];
    [tvContent setScrollEnabled:NO];
    
    [self addSubview:tvContent];
    
}



- (void)setEvalution:(LyEvaluation *)evalution
{
    _evalution = evalution;
    
    if ( !_evalution)
    {
        return;
    }
    
    evaMaster = [[LyUserManager sharedInstance] getUserWithUserId:[_evalution masterId]];
    NSString *strTvContentTmp = [[NSString alloc] initWithFormat:@"%@：%@", [evaMaster userName], [_evalution content]];
    NSMutableAttributedString *strTvContent = [[NSMutableAttributedString alloc] initWithString:strTvContentTmp];
    [strTvContent addAttribute:NSForegroundColorAttributeName value:Ly517ThemeColor range:[strTvContentTmp rangeOfString:[evaMaster userName]]];
    
    [tvContent setAttributedText:strTvContent];
    CGFloat fHeightTvContent =  [tvContent sizeThatFits:CGSizeMake(tvContentWidth, MAXFLOAT)].height;
    [tvContent setFrame:CGRectMake( evaWidth/2-tvContentWidth/2, 0, tvContentWidth, fHeightTvContent)];
    
    
    _height = tvContent.frame.origin.y+tvContent.frame.size.height;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
