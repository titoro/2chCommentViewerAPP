//
//  CVTweetTagView.h
//  2chCommentViewerApp
//
//  Created by hiroki on 13/06/30.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Social/Social.h"
#import "CVChannelListController.h"
#import "CVTweetTableViewController.h"
#import <Twitter/TWRequest.h>
#import <Twitter/TWTweetComposeViewController.h>
#import "OAMutableURLRequest.h"
#import "OARequestParameter.h"
#import "OAServiceTicket.h"
#import "OADataFetcher.h"
#import "OAConsumer.h"

//こっちはクラス変数
@class CVTweetTagView;

@interface CVTweetTagView : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    CVTweetTableViewController *cvTweetTable;
    NSMutableArray *userNameArray;
    NSMutableArray *tweetTextArray;
    NSMutableArray *tweetIconArray;
    ACAccount *account;
    UIImage *tweetIcon;
    UITableViewStyle style;
    BOOL tweetreloaded;
    BOOL firstloaded;
    int reloadIntarval;
    int adjestAtIndex;
}

@property (strong,nonatomic) CVTweetView *detailView;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) ACAccountStore *accountStore;
@property (strong,nonatomic) NSMutableArray *grantedAccounts;
@property (atomic,retain) NSString *accountId;


@end

