//
//  LyTableViewFooterView.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/14.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const tvFooterViewDefaultHeight;


typedef NS_ENUM( NSInteger, LyTableViewFooterViewStatus)
{
    LyTableViewFooterViewStatus_normal,
    LyTableViewFooterViewStatus_disable,
    LyTableViewFooterViewStatus_isAnimation,
    LyTableViewFooterViewStatus_error
};



@class LyTableViewFooterView;

@protocol LyTableViewFooterViewDelegate <NSObject>

@required
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView;

@end


@interface LyTableViewFooterView : UIView

@property ( assign, nonatomic)      id<LyTableViewFooterViewDelegate>       delegate;

@property ( assign, nonatomic)      LyTableViewFooterViewStatus     status;

@property ( strong, nonatomic)      NSString                        *title;

@property ( strong, nonatomic)      NSString                        *titleForDisable;

@property ( assign, nonatomic)      UIActivityIndicatorViewStyle    style;

@property ( strong, nonatomic)      UIColor                         *tintColor;
@property ( strong, nonatomic)      UIFont                          *font;

@property ( assign, nonatomic, getter=isAnimating)      BOOL                            animation;

+ (instancetype)tableViewFooterViewWithDelegate:(id<LyTableViewFooterViewDelegate>)deledate;

- (instancetype)initWithDelegate:(id<LyTableViewFooterViewDelegate>)delegate;

- (void)startAnimation;

- (void)stopAnimation;




@end
