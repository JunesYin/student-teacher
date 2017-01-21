//
//  LyLandMarkManageCollectionReusableView.m
//  teacher
//
//  Created by Junes on 16/8/11.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyLandMarkManageCollectionReusableView.h"
#import "LyUtil.h"


@interface LyLandMarkManageCollectionReusableView ()
{
    UILabel             *lbTitle;
    
    UIButton            *btnAdd;
}
@end

@implementation LyLandMarkManageCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(horizontalSpace, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        [lbTitle setFont:[UIFont systemFontOfSize:16]];
        [lbTitle setTextColor:LyBlackColor];
        [lbTitle setTextAlignment:NSTextAlignmentLeft];
        
        [self addSubview:lbTitle];
    }
    return self;
}


- (void)setTitle:(NSString *)title
{
    [lbTitle setText:title];
}

@end
