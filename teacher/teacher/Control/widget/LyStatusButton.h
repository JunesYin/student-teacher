//
//  LyStatusButton.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/28.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


#define LyStatusButtonNumFont                   [UIFont systemFontOfSize:12]
UIKIT_EXTERN CGFloat const LyStatusButtonHorizontalMargin;


typedef NS_ENUM( NSInteger, LyStatusButtonType)
{
    statusButtonType_praise,
    statusButtonType_evalution,
    statusButtonType_transmit
};


@interface LyStatusButton : UIButton

@property ( assign, nonatomic, readonly)        BOOL                            isPraised;
@property ( assign, nonatomic)                  LyStatusButtonType              mode;
@property ( strong, nonatomic)                  UIImage                         *imageIcon;
@property ( assign, nonatomic)                  NSInteger                       number;

- (void)praise:(BOOL)praiseFlag;

@end
