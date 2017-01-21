//
//  LyAddTrainClassViewController.h
//  teacher
//
//  Created by Junes on 16/8/4.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyTrainClass;
@class LyAddTrainClassViewController;


typedef NS_ENUM(NSInteger, LyAddTrainClassMode)
{
    LyAddTrainClassMode_add,
    LyAddTrainClassMode_modify
};


@protocol AddTrainClassDelegate <NSObject>

@optional
- (void)addDoneByLyAddTrainClassViewController:(LyAddTrainClassViewController *)aAddTrainClassVC;

@end

@interface LyAddTrainClassViewController : UIViewController


//@property (retain, nonatomic)       LyTrainClass                        *trainClass;
@property (assign, nonatomic)       LyAddTrainClassMode                 mode;
@property (weak, nonatomic)         id<AddTrainClassDelegate>           delegate;

+ (instancetype)addTrainClassViewControllerWithMode:(LyAddTrainClassMode)mode;

- (instancetype)initWithMode:(LyAddTrainClassMode)mode;

@end
