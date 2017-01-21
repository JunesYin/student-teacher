//
//  LyActivity.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/5.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LySingleInstance.h"


#define svActivityWidth                                 SCREEN_WIDTH
#define svActivityHeight                                svActivityWidth/2


NS_ASSUME_NONNULL_BEGIN


@protocol LyActivityDelegate;

@interface LyActivity : UIView

@property ( assign, nonatomic)                  NSInteger                               count;

@property ( assign, nonatomic)                  NSInteger                               stopTime;

@property ( assign, nonatomic)                  id<LyActivityDelegate>                  delegate;

- (void)go;

- (void)loadData:(NSInteger)count;


lySingle_interface

@end


@protocol LyActivityDelegate <NSObject>

@optional
- (void)activitiViewHasReady:(LyActivity *)aActivity;

- (void)onClickedByActivity:(LyActivity *)activity withIndex:(NSInteger)index andUrl:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
