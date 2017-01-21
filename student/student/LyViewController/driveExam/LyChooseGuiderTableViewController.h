//
//  LyChooseGuiderTableViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/17.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>




@class LyGuider;
@class LyChooseGuiderTableViewController;

@protocol LyChooseGuiderTableViewControllerDelegate <NSObject>

- (NSString *)obtainAddressByChooseGuiderTableViewController:(LyChooseGuiderTableViewController *)aChooseGuider;

- (void)onSelectedGuiderByChooseGuiderTableViewController:(LyChooseGuiderTableViewController *)aChooseGuider andGuider:(LyGuider *)guider;

@end


@interface LyChooseGuiderTableViewController : UITableViewController

@property ( retain, nonatomic)      NSString            *address;

@property ( weak, nonatomic)        id<LyChooseGuiderTableViewControllerDelegate>           delegate;



@end
