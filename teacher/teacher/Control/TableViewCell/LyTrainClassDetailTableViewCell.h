//
//  LyTrainClassDetailTableViewCell.h
//  teacher
//
//  Created by Junes on 16/8/25.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const tcdcellHeight;

@interface LyTrainClassDetailTableViewCell : UITableViewCell
{
    UILabel             *lbTitle;
    UILabel             *lbContent;
    
    BOOL                flagInclude;
}


//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isInclude:(BOOL)isInclude;

- (void)setCellInfo:(NSString *)title content:(NSString *)content;


@end
