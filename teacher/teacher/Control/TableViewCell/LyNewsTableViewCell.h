//
//  LyNewsTableViewCell.h
//  teacher
//
//  Created by Junes on 2016/10/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM( NSInteger, LyNewsTableViewCellMode) {
    LyNewsTableViewCellMode_community,
    LyNewsTableViewCellMode_detail,
};

UIKIT_EXTERN CGFloat const ntcVerticalSpace;
UIKIT_EXTERN CGFloat const ntcBtnFuncHeight;


@class LyNews;
@protocol LyNewsTableViewCellDelegate;


@interface LyNewsTableViewCell : UITableViewCell

@property (nonatomic, weak) id<LyNewsTableViewCellDelegate>     delegate;

@property (nonatomic, assign, readonly) LyNewsTableViewCellMode mode;

@property (nonatomic, retain, readonly) LyNews                  *news;

@property (nonatomic, assign)   CGFloat                         cellHeight;


- (void)setNews:(LyNews *)news mode:(LyNewsTableViewCellMode)mode;

@end


@protocol LyNewsTableViewCellDelegate <NSObject>

@required
- (void)onClickedForPraiseByNewsTVC:(LyNewsTableViewCell *)aCell;

- (void)onClickedForEvaluateByNewsTVC:(LyNewsTableViewCell *)aCell;

- (void)onCLickedForTransmitByNewsTVC:(LyNewsTableViewCell *)aCell;

- (void)onClickedForDetailByNewsTVC:(LyNewsTableViewCell *)aCell;

@optional
- (void)onClickedForUserByNewsTVC:(LyNewsTableViewCell *)aCell;

- (void)onClickedForDeleteByNewsTVC:(LyNewsTableViewCell *)aCell;



@end
