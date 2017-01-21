//
//  LyOrderKindTableViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/6/7.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyOrderKindTableViewCell.h"
#import "LyUtil.h"



CGFloat const oktcellWidth = 120.0f;
CGFloat const oktcellHeight = 30.0f;

#define ivIconWidth                         oktcellWidth
#define ivIconHeight                        oktcellHeight

@interface LyOrderKindTableViewCell ()
{
    UIImageView         *ivIcon;
}
@end


@implementation LyOrderKindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setBackgroundView:nil];
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, ivIconWidth, ivIconHeight)];
        [ivIcon setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:ivIcon];
    }
    
    return self;
}


- (void)setMode:(LyOrderKindTableViewCellMode)mode
{
    NSMutableString *strImageName = [[NSMutableString alloc] initWithCapacity:1];
    
//    _mode = ( LyOrderKindTableViewCellMode_guider == mode) ? LyOrderKindTableViewCellMode_reservation : mode;
    _mode = mode;
    
    switch ( _mode) {
        case LyOrderKindTableViewCellMode_driveSchool: {
            [strImageName appendString:@"orderKindMode_school"];
            break;
        }
        case LyOrderKindTableViewCellMode_coach: {
            [strImageName appendString:@"orderKindMode_coach"];
            break;
        }
        case LyOrderKindTableViewCellMode_guider: {
            [strImageName appendString:@"orderKindMode_guider"];
            break;
        }
        case LyOrderKindTableViewCellMode_reservation: {
            [strImageName appendString:@"orderKindMode_reservation"];
            break;
        }
        case LyOrderKindTableViewCellMode_mall: {
            [strImageName appendString:@"orderKindMode_mall"];
            break;
        }
        case LyOrderKindTableViewCellMode_game: {
            [strImageName appendString:@"orderKindMode_game"];
            break;
        }
    }
    
    if ( [super isSelected])
    {
        [strImageName appendString:@"_h"];
    }
    else
    {
        [strImageName appendString:@"_n"];
    }
    
    [ivIcon setImage:[LyUtil imageForImageName:strImageName needCache:NO]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected stat
    [self setMode:_mode];
}

@end
