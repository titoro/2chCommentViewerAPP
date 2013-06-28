//
//  CVTweetView.h
//  2chCommentViewerApp
//
//  Created by hiro kumagawa on 13/05/22.
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

//こっちはクラス変数？
@class CVTweetTableViewController;

@interface CVTweetView : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    //ここはインスタンス変数
    CVTweetTableViewController *cvTweetTable;
    NSMutableArray *userNameArray;
    NSMutableArray *tweetTextArray;
    ACAccount *account;
    ACAccountType *accountType;
    ACAccountStore *accountStore;
    
    UITableViewStyle style;
}
@property (strong,nonatomic) CVTweetView *detailView;
// 必要なら追加。
//@property (nonatomic, retain) UITableView *tableView;
//ACCount identifer Record
@property (atomic,retain) NSString *accountId;

//Tweet が可能かどうか？
//+ (BOOL)canSendTweet;

//初期のメッセージ
//- (BOOL)setInitialText:(NSString *)text;
//
////添付画像追加
//- (BOOL)addImage:(UIImage *)image;
//
////添付画像を全て削除
//- (BOOL)removeAllImages;
//
////URLを追加
//- (BOOL)addURL:(NSURL *)url;
//
////全てのURLを削除
//- (BOOL)removeAllURLs;
//
////Tweet 完了後のハンドラー
//@property (nonatomic, copy) TWTweetComposeViewControllerCompletionHandler completionHandler;

//- (NSArray *)fetchAccounts;

- (void)tweet:(NSString *)message;

- (void)loadTimeline;
@end