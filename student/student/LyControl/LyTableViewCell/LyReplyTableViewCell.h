//
//  LyReplyTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/29.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


#define rcellWidth            (SCREEN_WIDTH-horizontalSpace*2)



@class LyAboutMe;
@class LyReply;


@interface LyReplyTableViewCell : UITableViewCell

@property ( assign, nonatomic)      CGFloat             height;
@property ( retain, nonatomic)      LyAboutMe           *aboutMe;

@property ( retain, nonatomic)      LyReply             *reply;

@end
