//
//  CVTweetManager.h
//  2chCommentViewerApp
//
//  Created by hiroki on 13/09/01.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTableViewController.h"

//CVTweet関連の親クラス
@interface CVTweetManager : UIViewController{
    NSString* touched;
    BOOL _isFinish;
    NSArray *_namesArray;
    
    //PullRefreshTableViewController用（一時的）
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
}

@property NSString* touchedCell;
@property (nonatomic, assign) BOOL isFinish;        //引き継ぎ完了フラグ
@property (nonatomic, retain) NSArray *namesArray;  //配列を使った処理用　使用時名前変更

-(void)setTouchedCell:(NSString *)text;
- (id)initWithNone;

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

///PullRefreshTableViewController用（一時的）
- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;

@end
