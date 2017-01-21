//
//  LyPayTableViewCell.h
//  student
//
//  Created by Junes on 2016/11/21.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const ptcHeight;


@interface LyPayTableViewCell : UITableViewCell

//- (void)setCellInfo:(UIImage *)icon title:(NSString *)title isRecommend:(BOOL)isRecommend;

- (void)setCellInfo:(UIImage *)icon title:(NSString *)title detail:(NSString *)detail additaionalImage:(UIImage *)additionalImage isRecommend:(BOOL)isRecommend;

@end



