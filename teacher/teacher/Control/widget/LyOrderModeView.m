//
//  LyOrderModeView.m
//  student
//
//  Created by Junes on 2016/12/1.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyOrderModeView.h"
#import "LyOrderKindTableViewCell.h"


#import "LyUtil.h"


CGFloat const okKindCount = 4;


CGFloat const okTableViewTopMargin = 10.0f;

#define okTableViewWidth                oktcellWidth
#define okTableViewHeight               (oktcellHeight * okKindCount + okTableViewTopMargin)



@interface LyOrderModeView () <UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (strong, nonatomic)       UITableView         *tableView;

@end


@implementation LyOrderModeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


static NSString *const lyOrderKindTableViewCellReuseIdentifier = @"lyOrderKindTableViewCellReuseIdentifier";

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self initAndLayoutSubviews];
    }
    
    return self;
}

- (void)initAndLayoutSubviews {
    [self setBackgroundColor:LyMaskColor];
    
    [self addSubview:self.tableView];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - okTableViewWidth, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, okTableViewWidth, okTableViewHeight)
                                                  style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setBackgroundView:({
            UIImageView *iv = [[UIImageView alloc] initWithFrame:_tableView.bounds];
            [iv setContentMode:UIViewContentModeScaleAspectFill];
            [iv setImage:[LyUtil imageForImageName:@"orderKindsMask" needCache:NO]];
            iv;
        })];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, okTableViewWidth, okTableViewTopMargin)]];
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setScrollsToTop:NO];
        [_tableView setScrollEnabled:NO];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        
        [_tableView registerClass:[LyOrderKindTableViewCell class] forCellReuseIdentifier:lyOrderKindTableViewCellReuseIdentifier];
    }
    
    return _tableView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}


- (void)setOrderMode:(LyOrderMode)orderMode {
    _orderMode = orderMode;
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_orderMode - 1 inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionNone];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return oktcellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    
    _orderMode = indexPath.row + 1;
    [_delegate orderModeView:self didSelectedOrderMode:_orderMode];
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return okKindCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyOrderKindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyOrderKindTableViewCellReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LyOrderKindTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyOrderKindTableViewCellReuseIdentifier];
    }
    
    [cell setMode:indexPath.row+1];
    
    return cell;
}


@end
