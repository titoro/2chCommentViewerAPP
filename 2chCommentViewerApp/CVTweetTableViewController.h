//
//  CVTweetTableViewController.h
//  2chCommentViewerApp
//
//  Created by hiro kumagawa on 13/05/24.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

@class CVTweetTableViewController;

@interface CVTweetTableViewController : UITableViewController{
    NSMutableArray *userNameArray;
    NSMutableArray *tweetTextArray;
    ACAccount *account;
    ACAccountType *accountType;
    ACAccountStore *accountStore;
}
@property (strong,nonatomic) CVTweetTableViewController *detailViewController;

- (void)loadTimeline;
@end
