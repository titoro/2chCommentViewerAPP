//
//  CVChannelListController.h
//  2chCommentViewerApp
//
//  Created by hiro kumagawa on 13/03/30.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVChannelTable.h"
#import "CVChannel.h"   //test用
#import "CvTweetView.h"
#import "CVTweetTagView.h"
#import "CVTweetManager.h"
#import <objc/runtime.h>
#import "CVTweetDelegate.h"
@protocol CVTweetDelegate;

@interface CVChannelListController : CVTweetManager<UITableViewDelegate,UITableViewDataSource>{
    UITableViewStyle style;    // 実際は loadView にハードコードで構わないことが多く、不要だろう。どゆこと？
    UITableView *cvChannelTable;
    CVTweetManager* cvTweetManager;
    
    id <CVTweetDelegate> delegate;
}
// 必要なら追加。
@property (nonatomic, retain) UITableView *tableView;
//不要？
@property (strong, nonatomic) NSString *touchedTableTweet;
// style と同様。もっとましな初期化メソッドを用意すべき。
- (id)initWithStyle:(UITableViewStyle)theStyle;

@property (nonatomic, retain) CVTweetManager *cvTweetManager;
- (id)initWithDataManager:(CVTweetManager *)argcvTweetManager;
@end

//
@protocol CVTweetDelegate
-(void)touchedCellDelegate;
@end