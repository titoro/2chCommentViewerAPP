//
//  CVChannelListController.m
//  2chCommentViewerApp
//
//  Created by hiro kumagawa on 13/03/30.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import "CVChannelListController.h"
//グローバル関数
//値受け渡しに書き換える
NSString *touchedTable;
//画面間のデータの受け渡しに関連参照
//その為のキー
static char selectedCellKey; //選択されたセルの値を保持するキー
@interface CVChannelListController ()

@end

@implementation CVChannelListController

@synthesize tableView;
//不要？
@synthesize touchedTableTweet = _touchedTableTweet;
@synthesize cvTweetManager = _cvTweetManager;

// 必要に応じて、初期化メソッドを追加または変更。
- (id)initWithStyle:(UITableViewStyle)theStyle
{
    self = [super init];    // xib ファイルは使わないと仮定。
    if (self != nil) {
        style = theStyle;
    }
    return self;
}

//初期化
-(id)initWithDataManager:(CVTweetManager *)argcvTweetManager{
    self = [super init];
    if (self) {
        
        self.cvTweetManager = argcvTweetManager;
        
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//関連参照用のメソッド
//現在使用していない
//わかったら使用するか、削除するか判断
// 選択されたセルの値の保持
- (void)setSeletedCellKey:(NSString*)selectcell
{
    objc_setAssociatedObject(self, &selectedCellKey, selectcell,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)loadView{
    //この下にビューの初期化処理
    //今はテスト
    //ビューのインスタンスを取得する
    //UIView* view = [[UIView alloc]initWithFrame:CGRectZero];
    
    // view の frame は親に追加された時に調整されるので、何でも良い。
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    // tableView の frame は view.bounds 全体と仮定。他の UI 部品を配置する場合は要調整。
    tableView = [[UITableView alloc] initWithFrame:view.bounds style:style];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.dataSource = self;
    tableView.delegate = self;
    [view addSubview:tableView];
    
    // 必要に応じて、ここで他の UI 部品を生成。
    
    //viewプロパティに設定
    self.view = view;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // view をロードした時の処理。self.title = @"タイトル"; など。
    
    //タイトルの設定
    self.title = @"チャンネル一覧";
    
    //ナビゲーションバーに次へボタンの追加
    UIBarButtonItem* next = [[UIBarButtonItem alloc] initWithTitle:@"次へ" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnClick)];
    [self.navigationItem setRightBarButtonItem:next animated:NO];
    
    // 編集ボタンを追加。
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

// UINavigationController の中で使う場合、viewWillAppear: メソッドを追加。
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // detail から master に戻ってきた場合に、選択された行のハイライトを消す。
    NSIndexPath *indexPath = tableView.indexPathForSelectedRow;
    if (indexPath != nil) {
        [tableView deselectRowAtIndexPath:indexPath animated:animated];
    }
}

// そのまま。
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //テストの為この値を使用
    return 1;
}

// セクションの中の行数を指定。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //テスト
    CVChannel *cvChannel = [[CVChannel alloc]init];
    int channelCount = cvChannel.channels.count;
//    NSLog(@"%d",cvChannel.channels.count);
    return channelCount;
}

// そのまま。
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // cell の内容を設定。
    //test code
    CVChannel *cvChannel = [[CVChannel alloc]init];
    cell.textLabel.text = [cvChannel.channels objectAtIndex:indexPath.row];
    
    return cell;
}

// そのまま。
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //test
    //NSString* touched = @"テレビ東京";
    
    //アプリケーションデリゲートで値の渡し
    /*
    AppDeleg *appDelegate;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.touchedTableTweet = touched;
    */
    // 定義した画面へ遷移する。スライドアニメーションはなし。
    
    UITableViewCell *cell = [theTableView cellForRowAtIndexPath:indexPath];
    //セルの情報の中から文字列を取り出す
    NSString* str = cell.textLabel.text;
    
    //Twitterタイムライン
    NSString* twitterTimeline = @"ツイッター タイムライン";
    
    //タッチされたセルの文字列を設定
    touchedTable = str;
    
    //Twitterタイムラインセル選択時タイムライン表示画面へ
    if ([str isEqualToString:twitterTimeline]) {
        // 行が選択された場合の処理。
        CVTweetView *cvTweetView = [[CVTweetView alloc]init];
        //Managerクラスへ選択されたセルの文字列を格納
        _cvTweetManager.touchedCell =  cell.textLabel.text;
        
        //AppDelegateへ格納
//        AppDelegate *appDelegate;
//        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//        appDelegate.touchedCell = cell.textLabel.text;
        
        
//        CVTweetDelegate* cv = [[CVTweetDelegate alloc]init];
//        //[cv touchedCell:cell.textLabel.text];
        
        [self.navigationController pushViewController:cvTweetView animated:YES];
    }else{
        //Tweeterタイムラインセル選択時以外はタグ検索画面へ
        CVTweetTagView *cvTweetTagView = [[CVTweetTagView alloc]init];
        cvTweetTagView.touchedCell = cell.textLabel.text;
        
        [self.navigationController pushViewController:cvTweetTagView animated:YES];
    }
}

//編集ボタンの場合
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    // UITableView の setEditing:animated: メソッドを呼ぶ。
    [self.tableView setEditing:editing animated:animated];
}

// その他のメソッドはそのまま。

/* セクション名の設定（セクションを増やす場合に設定するように記述。今は使わない）
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0: // 1個目のセクションの場合
            return @"セクションその1";
            break;
        case 1: // 2個目のセクションの場合
            return @"セクションその2";
            break;
    }
    return nil; //ビルド警告回避用
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end