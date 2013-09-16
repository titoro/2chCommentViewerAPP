//
//  CVAppController.m
//  2chCommentViewerApp
//
//  Created by hiro kumagawa on 13/03/31.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//
//#import "CVAppController.h"

//#import "CVChannelListController.h"
//#import "CVChannelListController.m"

/*アプリコントローラ*/
@interface CVAppController : NSObject{
}

//初期化
+(CVAppController *) sharedController;

@end

@implementation CVAppController
//CVAppControllerの参照を入れておく共有static変数
static CVAppController* _sharedInstance = nil;
+(CVAppController *) sharedController{
    //共有static変数を返す
    return _sharedInstance;
}

-(id)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    //共有static変数に、参照を設定する
    _sharedInstance = self;
    return self;
}

-(void)applicationDidFinishLaunching:(UIApplication *)application{
    //アプリの初期化処理を記述
    
    //チャンネルリストコントローラを作成する
    //_cvChannelListController = [[CVChannelListController alloc] init];
    
}

@end