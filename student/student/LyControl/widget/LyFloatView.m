//
//  LyFloatView.m
//  student
//
//  Created by Junes on 2016/10/24.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyFloatView.h"

#import "LyBottomControl.h"
#import "LyUtil.h"


CGFloat const LyFloatViewDefaultSize = 50.0f;


CGFloat const fvAndOtherMargin = 5.0f;

CGFloat const fvOffsetMin = 15.0f;






@interface LyFloatView ()
{
    BOOL                moveFlag;
    UIImageView         *ivIcon;
    
    
    BOOL                moveFlagForBC;
    CGPoint             centerBeforeMove;
}
@end


@implementation LyFloatView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



+ (instancetype)floatViewWithIconMap:(UIImage *)iconMap iconList:(UIImage *)iconList {
    LyFloatView *floatView = [[LyFloatView alloc] initWithIconMap:iconMap iconList:iconList];
    
    return floatView;
}


- (instancetype)initWithIconMap:(UIImage *)iconMap iconList:(UIImage *)iconList {
    if (self = [super init]) {
        _iconMap = iconMap;
        _iconList = iconList;
        
        [self initSubviews];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [ivIcon setFrame:self.bounds];
}

- (void)initSubviews {
    
    switch (_defaultMode) {
        case LyFloatViewMode_map:
            ivIcon = [[UIImageView alloc] initWithImage:_iconList highlightedImage:_iconMap];
            break;
        case LyFloatViewMode_list: {
            ivIcon = [[UIImageView alloc] initWithImage:_iconMap highlightedImage:_iconList];
            break;
        }
    }
    
    [ivIcon setFrame:self.bounds];
    [self addSubview:ivIcon];
    
    [[LyBottomControl sharedInstance] addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)setDefaultMode:(LyFloatViewMode)defaultMode {
    _defaultMode = defaultMode;
    
    switch (_defaultMode) {
        case LyFloatViewMode_map: {
            [ivIcon setImage:_iconList];
            [ivIcon setHighlightedImage:_iconMap];
            break;
        }
        case LyFloatViewMode_list: {
            [ivIcon setImage:_iconMap];
            [ivIcon setHighlightedImage:_iconList];
            break;
        }
    }
}



- (void)resetCenter:(CGPoint)pointDes {
    
    if ( self.center.y < STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT + CGRectGetHeight(self.bounds)/2 ) {
        pointDes.y = STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT + CGRectGetHeight(self.bounds)/2 + fvAndOtherMargin;
    } else if ( self.center.y > SCREEN_HEIGHT-CGRectGetHeight([[LyBottomControl sharedInstance] frame])-CGRectGetHeight(self.bounds)/2 ) {
        pointDes.y = SCREEN_HEIGHT - CGRectGetHeight([[LyBottomControl sharedInstance] frame]) - CGRectGetHeight(self.bounds)/2 - fvAndOtherMargin;
    } else {
        pointDes.y = self.center.y;
    }
    
    
    [LyUtil startAnimationWithView:self
                 animationDuration:LyAnimationDuration
                      initialPoint:self.center
                  destinationPoint:pointDes
                        completion:^(BOOL finished) {
                            ;
                        }];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    NSLog(@"touchesBegan");
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //    NSLog(@"touchesCancelled");
    CGPoint pointDes;
    
    if ( self.center.x < SCREEN_WIDTH/2 ) {
        pointDes.x = 0 + CGRectGetWidth(self.bounds)/2;
    } else {
        pointDes.x = SCREEN_WIDTH - CGRectGetHeight(self.bounds)/2;
    }
    
    [self resetCenter:pointDes];
    
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint curCenter = self.center;
    CGPoint newCenter = [touch locationInView:[self superview]];
    
    if (fabs(newCenter.x - curCenter.x) > fvOffsetMin ||
        fabs(newCenter.y - curCenter.y) > fvOffsetMin)
    {
        moveFlag = YES;
    }
    
    if (moveFlag) {
        [self setCenter:newCenter];
    }
    
}




- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ( moveFlag) {
        
        moveFlag = NO;
        CGPoint pointDes;
        
        if ( self.center.x < SCREEN_WIDTH/2 ) {
            pointDes.x = 0 + CGRectGetWidth(self.bounds)/2;
        } else {
            pointDes.x = SCREEN_WIDTH - CGRectGetWidth(self.bounds)/2;
        }
        
        [self resetCenter:pointDes];
        
    } else {
        
        [ivIcon setHighlighted:!ivIcon.isHighlighted];
        
        [_delegate onClicked];
    }
    
}



#pragma mark -KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        
        BOOL flag = NO;
        
        CGRect frame = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        if (self.frame.origin.y + CGRectGetHeight(self.bounds) + fvAndOtherMargin > frame.origin.y) {
            moveFlagForBC = YES;
            centerBeforeMove = self.center;
            
            flag = YES;
            
            [super setFrame:CGRectMake(self.frame.origin.x, frame.origin.y - fvAndOtherMargin - CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        }
        
        
        if (moveFlagForBC && !flag) {
            moveFlagForBC = NO;
            [super setCenter:centerBeforeMove];
        }
        
    }
}






@end
