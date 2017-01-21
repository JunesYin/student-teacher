//
//  LyTableViewHeaderFooterView.h
//  teacher
//
//  Created by Junes on 16/8/25.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const LyTableViewHeaderFooterViewHeight;


@interface LyTableViewHeaderFooterView : UITableViewHeaderFooterView
{
    UILabel             *lbContent;
}

@property (strong, nonatomic)           NSString            *content;

@property (strong, nonatomic)           UIFont              *font;                      //Default is [UIFont systemFontOfSize:18]

@property (strong, nonatomic)           UIColor             *contentColor;              //Default is Ly517ThemeColor


@end
