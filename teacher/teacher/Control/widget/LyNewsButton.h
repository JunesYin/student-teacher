//
//  LyNewsButton.h
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LyNewsButtonNumFont                     [UIFont systemFontOfSize:12]
UIKIT_EXTERN CGFloat const LyNewsButtonHorizontalMargin;



typedef NS_ENUM( NSInteger, LyNewsButtonMode) {
    LyNewsButtonMode_praise,
    LyNewsButtonMode_evaluation,
    LyNewsButtonMode_transmit
};


@interface LyNewsButton : UIButton

@property ( assign, nonatomic, readonly)        BOOL                            isPraised;
@property ( assign, nonatomic)                  LyNewsButtonMode                mode;
@property ( strong, nonatomic)                  UIImage                         *imageIcon;
@property ( assign, nonatomic)                  NSInteger                       number;

- (void)praise:(BOOL)praiseFlag;

@end
