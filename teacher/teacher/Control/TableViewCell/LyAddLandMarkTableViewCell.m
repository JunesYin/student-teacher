//
//  LyAddLandMarkTableViewCell.m
//  teacher
//
//  Created by Junes on 16/8/11.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyAddLandMarkTableViewCell.h"

#import "LyLandMark.h"

#import "LyUtil.h"


CGFloat const almtcellHeight = 40.0f;

CGFloat const almLbIsAddedWidth = 40.0f;

CGFloat const almIvPickedSize = 20.0f;

@interface LyAddLandMarkTableViewCell ()
{
    UILabel                 *lbConent;
    UILabel                 *lbIsAdded;
    
    UIImageView             *ivPicked;
}
@end


@implementation LyAddLandMarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        lbConent = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, SCREEN_WIDTH*2/3.0f, almtcellHeight)];
        [lbConent setFont:[UIFont systemFontOfSize:14]];
        [lbConent setTextColor:[UIColor blackColor]];
        [lbConent setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:lbConent];
        
        
        lbIsAdded = [[UILabel alloc] initWithFrame:CGRectMake(lbConent.ly_y + CGRectGetWidth(lbConent.frame) + horizontalSpace, 0, almLbIsAddedWidth, almtcellHeight)];
        [lbIsAdded setFont:LyFont(12)];
        [lbIsAdded setTextColor:[UIColor lightGrayColor]];
        [lbIsAdded setTextAlignment:NSTextAlignmentCenter];
        [lbIsAdded setText:@"已添加"];
        [self addSubview:lbIsAdded];
        
        
        ivPicked = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-horizontalSpace-almIvPickedSize, almtcellHeight/2.0f-almIvPickedSize/2.0f, almIvPickedSize, almIvPickedSize)];
        [ivPicked setImage:[LyUtil imageForImageName:@"landMark_btn_add" needCache:NO]];
        [self addSubview:ivPicked];
        
//        [lbConent setUserInteractionEnabled:YES];
//        [ivPicked setUserInteractionEnabled:YES];
        
        [lbIsAdded setHidden:YES];
        [ivPicked setHidden:YES];
    }
    
    return self;
}


- (void)setLandMark:(LyLandMark *)landMark added:(BOOL)added choosed:(BOOL)choosed {
    
    [self setLandMark:landMark];
    [self setAdded:added];
    [self setChoosed:choosed];
}


- (void)setLandMark:(LyLandMark *)landMark {
    if (!landMark) {
        return;
    }
    
    _landMark = landMark;
    
    [lbConent setText:landMark.lmName];
}

- (void)setAdded:(BOOL)added {
    [lbIsAdded setHidden:!added];
}


- (void)setChoosed:(BOOL)choosed {
    _choosed = choosed;
    [ivPicked setHidden:!_choosed];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
