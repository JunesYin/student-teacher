//
//  LyFloatView.h
//  student
//
//  Created by Junes on 2016/10/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const LyFloatViewDefaultSize;


typedef NS_ENUM(NSInteger, LyFloatViewMode) {
    LyFloatViewMode_map = 0,
    LyFloatViewMode_list
};


@protocol LyFloatViewDelegate;

@interface LyFloatView : UIView

@property (weak, nonatomic)     id<LyFloatViewDelegate> delegate;

@property (assign, nonatomic)   LyFloatViewMode         defaultMode;
@property (assign, nonatomic)   LyFloatViewMode         curMode;

@property (strong, nonatomic)   UIImage                 *iconMap;
@property (strong, nonatomic)   UIImage                 *iconList;

+ (instancetype)floatViewWithIconMap:(UIImage *)iconMap iconList:(UIImage *)iconList;

@end



@protocol LyFloatViewDelegate <NSObject>

@required
- (void)onClicked;

@end
