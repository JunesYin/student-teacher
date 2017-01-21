//
//  LySearchResultTableViewController.h
//  teacher
//
//  Created by Junes on 17/10/2016.
//  Copyright © 2016 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LySearchResultTableViewControllerDelegate;


@interface LySearchResultTableViewController : UITableViewController

@property (nonatomic, weak)         id<LySearchResultTableViewControllerDelegate>   delegate;

@property (nonatomic, strong)       NSMutableArray         *arrSearchResult;

@property (nonatomic, retain)       NSString                *keyForShow;


+ (instancetype)searchResultTableViewControllerWithKeyForShow:(NSString *)keyForShow;

- (instancetype)initWithKeyForShow:(NSString *)keyForShow;

@end


@protocol LySearchResultTableViewControllerDelegate <NSObject>

@required
- (void)onSelectedItemBySearchResultTVC:(LySearchResultTableViewController *)aSearchResultTVC object:(id)object;

@end
