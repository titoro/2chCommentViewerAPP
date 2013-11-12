//
//  CVTweetTagView.h
//  2chCommentViewerApp
//
//  Created by hiroki on 13/06/30.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AppDelegate.h"
#import "Social/Social.h"
#import "CVChannelListController.h"
#import "CVTweetTableViewController.h"
#import <Twitter/TWRequest.h>
#import <Twitter/TWTweetComposeViewController.h>
#import "OAuthConsumer.h"
#import "CVTweetManager.h"
#import <objc/runtime.h>
#import "PullRefreshTableViewController.h"

//クラス変数
@class CVTweetTagView;

@interface CVTweetTagView : CVTweetManager<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>{
    CVTweetTableViewController *cvTweetTabSle;
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
    CVTweetManager* cvTweetManager;
    
}
@property (strong,nonatomic) id touchedCellId;
@property (strong,nonatomic) NSString *tag;             //検索単語（検索文字、ハッシュタグ文字)
@property (strong,nonatomic) CVTweetTagView *detailView;
@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) ACAccountStore *accountStore;
@property (strong,nonatomic) NSArray *grantedAccounts;
@property (atomic,retain)    NSString *accountId;
@property (atomic) BOOL firstLoad;
@property (strong,nonatomic) OAToken *accessToken;
@property (strong,atomic) NSString *touchedCell;

@property (nonatomic, copy) NSString *textPull; // for "Pull down to refresh…"
@property (nonatomic, copy) NSString *textRelease; // for "Release to refresh…"
@property (nonatomic, copy) NSString *textLoading; // for "Loading..."

-(void)reloadTweet;          //リロード処理　データを新規取得し追加格納
-(void)arraySort;            //配列の重複要素を削除（時間で自動的にソートされている為ソートはしない）
- (UIImage *) makeThumbnailOfSize:(CGSize)size;
//不要？
@property (strong, nonatomic) NSString *touchedTableTweet;
@property (nonatomic, retain) CVTweetManager *cvTweetManager;
- (id)initWithDataManager:(CVTweetManager *)argcvTweetManager;
@end