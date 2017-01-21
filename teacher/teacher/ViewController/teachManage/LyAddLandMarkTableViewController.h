//
//  LyAddLandMarkTableViewController.h
//  teacher
//
//  Created by Junes on 16/8/11.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>



@class LyDistrict;

@protocol LyAddLandMarkDelegate;

@interface LyAddLandMarkTableViewController : UITableViewController

@property (weak, nonatomic)         id<LyAddLandMarkDelegate>       delegate;


@property (retain, nonatomic)       LyDistrict                      *district;
@property (retain, nonatomic)       NSMutableArray                  *arrLandMarks;

@end




@protocol LyAddLandMarkDelegate <NSObject>

//- (LyDistrict *)obtainDistrictIdByAddLandMarkTVC:(LyAddLandMarkTableViewController *)aAddLandMarkTVC;
- (NSDictionary *)landMarkInfoByAddLandMarkTVC:(LyAddLandMarkTableViewController *)aAddLandMarkTVC;

- (void)onDoneAddLandMark:(LyAddLandMarkTableViewController *)aAddLandMarkVC landMarks:(NSArray *)landMarks;

@end
