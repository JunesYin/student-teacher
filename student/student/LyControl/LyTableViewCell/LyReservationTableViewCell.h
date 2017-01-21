//
//  LyReservationTableViewCell.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/18.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN CGFloat const rescellHeight;


@class LyReservation;

@interface LyReservationTableViewCell : UITableViewCell

@property ( retain, nonatomic)          LyReservation               *reservation;


@end
