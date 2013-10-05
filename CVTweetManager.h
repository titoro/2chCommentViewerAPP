//
//  CVTweetManager.h
//  2chCommentViewerApp
//
//  Created by hiroki on 13/09/01.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PullRefreshTableViewController.h"

@interface CVTweetManager : UIViewController{
    NSString* touched;
    BOOL _isFinish;
    NSArray *_namesArray;
}

@property NSString* touchedCell;
@property (nonatomic, assign) BOOL isFinish;        //引き継ぎ完了フラグ
@property (nonatomic, retain) NSArray *namesArray;  //配列を使った処理用　使用時名前変更

-(void)setTouchedCell:(NSString *)text;
- (id)initWithNone;
@end
