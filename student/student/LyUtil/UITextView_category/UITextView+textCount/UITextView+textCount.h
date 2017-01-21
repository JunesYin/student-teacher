//
//  UITextView+textCount.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/22.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (textCount)

/*注意先设置textView的字体*/
@property ( assign, nonatomic)          int         textCount;

- (void)updateTextCount;

- (void)update;

@end
