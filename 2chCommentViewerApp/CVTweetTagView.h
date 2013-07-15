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
#import "OAuthConsumer.h"
//クラス変数
@class CVTweetTagView;

@interface CVTweetTagView : UIViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>{
    CVTweetTableViewController *cvTweetTable;
    NSMutableArray *userNameArray;
    NSMutableArray *tweetTextArray;
    NSMutableArray *tweetIconArray;
    ACAccount *account;
    UIImage *tweetIcon;
    UITableViewStyle style;
    BOOL tweetreloaded;         //ツイートロードフラグ
    BOOL firstloaded;           //ロードの初期化フラグ
    int reloadIntarval;
    int adjestAtIndex;
    
    OAConsumer *consumer;
    OAToken *requestToken;
    UIWebView *webTweetView;
//    NSString *kTwitterConsumerKey;
//    NSString *kTwitterConsumerSecret;
}
@property (strong,nonatomic) NSString *hashTag;
@property (strong,nonatomic) CVTweetTagView *detailView;
@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) ACAccountStore *accountStore;
@property (strong,nonatomic) NSMutableArray *grantedAccounts;
@property (atomic,retain)    NSString *accountId;
@property (atomic) BOOL firstLoad;
@property (strong,nonatomic) OAToken *accessToken;

- (UIImage *) makeThumbnailOfSize:(CGSize)size;
@end