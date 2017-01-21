//
//  LyImageView.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/2.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  LyImageViewDelegate;

@interface LyImageView : UIView

@property ( strong, nonatomic)                      UIImage                         *image;
@property ( strong, nonatomic)                      UIButton                        *btnDelete;
@property ( assign, nonatomic)                      NSInteger                       lineIndex;
@property ( strong, nonatomic)                      id<LyImageViewDelegate>         delegate;

@end



@protocol  LyImageViewDelegate <NSObject>

@required
- (void)onClickForBtnDelete:(NSInteger)tag;

@end
