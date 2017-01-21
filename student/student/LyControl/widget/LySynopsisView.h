//
//  LySynopsisView.h
//  LyStudyDrive
//
//  Created by Junes on 16/7/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LySynopsisView : UIView

@property (retain, nonatomic)           NSString            *content;
@property (retain, nonatomic)           NSString            *title;

+ (instancetype)synopsisViewWithContent:(NSString *)content withTitle:(NSString *)title;

- (instancetype)initWithContent:(NSString *)content withTitle:(NSString *)title;

- (void)show;

- (void)hide;

@end
