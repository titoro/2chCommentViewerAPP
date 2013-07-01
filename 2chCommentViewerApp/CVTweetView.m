//
//  CVTweetView.m
//  2chCommentViewerApp
//
//  Created by hiro kumagawa on 13/05/22.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import "CVTweetView.h"

extern NSString *touchedTable;
@interface CVTweetView ()

@end
@implementation CVTweetView

@synthesize accountId = _accountId;
@synthesize detailView = _detailView;
@synthesize accountStore = _accountStore;
@synthesize grantedAccounts = _grantedAccounts;
@synthesize tableView;
//@synthesize tweetArray;

- (id)initWithStyle:(UITableViewStyle)theStyle
{
    self = [super init];    // xib ファイルは使わないと仮定。
    if (self != nil) {
        style = theStyle;
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

-(void)loadView{
    //twitterタイムラインを取得
    [self loadTimelineTweet];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    firstloaded = NO;
    tweetreloaded = NO;
    
    userNameArray = [[NSMutableArray alloc] initWithCapacity:0];
    tweetTextArray = [[NSMutableArray alloc] initWithCapacity:0];
    tweetIconArray = [[NSMutableArray alloc]initWithCapacity:0];
    
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
    
    //タイトルの設定
    self.title = @"タイムライン";
    
    //Interval after timeline reload
    //リロード自動で行うための処理
    //リロード機能未実装の為、現在コメントアウト
//    reloadIntarval = 30;
//   [NSTimer scheduledTimerWithTimeInterval:(reloadIntarval) target:self selector:@selector(reloadTweet)
//                                   userInfo:nil repeats:YES];
}

//soial.frameworkを使ってツイート
//ツイッター表示画面からのツイートに使用する予定
//クラス構造考える必要がある
-(void)tweetMessage{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) { //利用可能チェック
        NSString *serviceType = SLServiceTypeTwitter;
        SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone) {
                //投稿成功時の処理
            }
        }];
        [self presentViewController:composeCtl animated:YES completion:nil];
    }
}

//twitter OAuth Request
-(void)tweetOAuth:(NSString *)message{
    NSURL *url = [NSURL URLWithString:@"http://twitter.com/statuses/update.json"];
    
    // サービスからアプリ用に割り当てられたKeyとSecret
    NSString* consumerKey = @"aovoz75XqdBMGxj3F1dfg";
    NSString* consumerSecret = @"8UsZnHi2R2jJ8VVYmaGaMq1J0s0q7GFuqNeknQbY";
    
    // API問い合わせにつかうクライアント単位のKeyとSecret
    NSString* tokenKey = nil;
    NSString* tokenSecret = nil;
    
    OAConsumer *consumer = [[OAConsumer alloc]
                             initWithKey:consumerKey secret:consumerSecret];
    OAToken* token = tokenKey ? [[OAToken alloc]
                                  initWithKey:tokenKey secret:tokenSecret]  : nil;
    
    // リクエストを生成する
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc]
                                     initWithURL:url consumer:consumer
                                     token:token realm:nil signatureProvider:nil];
    
    // リクエストを実行する
    OADataFetcher* fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];

    [request setHTTPMethod:@"GET"];
    NSString *bodyString = [NSString stringWithFormat:@"status=%@",
                            (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(  
                                                                                kCFAllocatorDefault,
                                                                                (__bridge CFStringRef)message,
                                                                                NULL,
                                                                                NULL,
                                                                                kCFStringEncodingUTF8)];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",request);
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket
         didFinishWithData:(NSData *)data {
    NSString *response = [[NSString alloc] initWithData:data
                                                encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@", response);
}
- (void)requestTokenTicket:(OAServiceTicket *)ticket
          didFailWithError:(NSError*)error {
    NSLog(@"Error: %@", error);
}

- (void)ticket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data: %@", dataString);
}

- (void)ticket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//セクション数 1セクションのみ
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

//セクションの行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //タイムライン２０件取得し表示する
    return 20;
}

//Cell
- (UITableViewCell *)tableView:(UITableView *)tableViewc cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableViewc dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //NSLog(@"%@",userNameArray);
    //NSLog(@"%@",tweetTextArray);
    //cell.textLabel.text = @"test";
    if(!tweetreloaded){
        return cell;
        
    }
    //cell.textLabel.text = [tweetTextArray objectAtIndex:indexPath.row];
    cell.textLabel.font =[UIFont systemFontOfSize:11];
    cell.textLabel.numberOfLines = 0;
    adjestAtIndex += 20;
  
    int userNameAtIndex = indexPath.row;
    int tweetTextAtIndex = indexPath.row;
    int tweetIconAtIndex = indexPath.row;
    if (tweetreloaded == YES && [userNameArray count] >= 20 +adjestAtIndex
        && [tweetTextArray count] >= 20 +adjestAtIndex && [tweetIconArray count] >= 20 +adjestAtIndex) {
        userNameAtIndex =indexPath.row + adjestAtIndex;
        tweetTextAtIndex =indexPath.row + adjestAtIndex;
        tweetIconAtIndex =indexPath.row + adjestAtIndex;
    }
    
    //ユーザ名を設定
    cell.detailTextLabel.text = [userNameArray objectAtIndex:indexPath.row];
    //つぶやきを設定
    cell.textLabel.text = [tweetTextArray objectAtIndex:indexPath.row];
    
    //アイコン画像を設定
    NSString* iconPath = [tweetIconArray objectAtIndex:indexPath.row];
    NSURL* url = [NSURL URLWithString:iconPath];
    NSData* data = [NSData dataWithContentsOfURL:url];
    cell.imageView.contentMode = UIViewContentModeLeft;
    UIImage* img = [[UIImage alloc] initWithData:data];
//    UIImage *img = [orgImg makeThumbnailOfSize:CGSize(50,50)];
    cell.imageView.image = img;
    
    return cell;

}

// セルの高さを返す. セルが生成される前に実行されるので独自に計算する必要がある
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	if(!tweetreloaded){
        return 50;
    }
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
	CGSize bounds = CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.height);
    //textLabelのサイズ
 	CGSize size = [cell.textLabel.text sizeWithFont:cell.textLabel.font
                                  constrainedToSize:bounds
                                      lineBreakMode:NSLineBreakByCharWrapping];
    //detailTextLabelのサイズ
	CGSize detailSize = [cell.detailTextLabel.text sizeWithFont: cell.detailTextLabel.font
                                              constrainedToSize: bounds
                                                  lineBreakMode: NSLineBreakByCharWrapping];
    //サイズ調整用
    int sizeAdjustment = 35;
    
    return size.height + detailSize.height + sizeAdjustment;
}

//画面の初期化終了後の処理
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    //
    
}

//Twitterのタイムラインを取得する
-(void)loadTimelineTweet{
    
//未認可のリクエストトークンをtwitterから取得
//現在は使用していないためコメントアウト
/******************************************************************/
//        OAConsumer *consumer =
//        [[OAConsumer alloc] initWithKey:@"aovoz75XqdBMGxj3F1dfg"
//                                secret:@"8UsZnHi2R2jJ8VVYmaGaMq1J0s0q7GFuqNeknQbY"];
//        OAToken *accessToken =
//            [[OAToken alloc] initWithKey:@"215992182-56ELH2oBtBmYqltZHIwEk31ieF70e2YDii5RpHIX"
//                            secret:@"oGxMWDDJ0mtE0uzpukeb15pHP6W8iJjijmSUKUAYecI"];
    
//        NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1.1/statuses/firehose"];
//    
//        OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
//                                                                     consumer:consumer
//                                                                        token:accessToken
//                                                                        realm:nil
//                                                            signatureProvider:nil];
//    
//        [request setHTTPMethod:@"GET"];
    
//        OADataFetcher *fetcher = [[OADataFetcher alloc] init];
//    
//        [fetcher fetchDataWithRequest:request
//                             delegate:self
//                    didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
//                      didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
//    
//    
//        accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
//    
//    	[accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
//    		if(granted)
//    		{
//    			NSArray *accountstores = [accountStore accountsWithAccountType:accountType];
//    			if([accountstores count] > 0)
//    			{
//    				account = [accountstores objectAtIndex:0];
//    				self.accountId = account.identifier;
//    			}
//    		}
//    }];
/************************************************************************/
    //リロードフラグをNOにする
    if (tweetreloaded == YES) {
        tweetreloaded = NO;
    }
    
    //ACAccountStoreオブジェクトを生成
    _accountStore = [[ACAccountStore alloc] init];
    
    //TwitterのACAccountTypeオブジェクトを取得し、それを元にアカウントを取得
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *accounts = [_accountStore accountsWithAccountType:accountType];
    if (accounts.count == 0) {
        NSLog(@"Please add twitter account on Settings");
        return;
    }
    
/**  ユーザ認証の機能は追加する  **/
//    ACAccountStore *accountStoreTw = [[ACAccountStore alloc]init];
//    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //ユーザに認証してもらう
//    [_accountStore requestAccessToAccountsWithType:accountType
//                                           options:nil
//                                        completion:^(BOOL granted, NSError *error) {
//                                            dispatch_async(dispatch_get_main_queue(), ^{
//                                                if (granted) {
////                                                    //grantedAccounts
////                                                    _grantedAccounts = [_accountStore accountsWithAccountType:accountType];
//                                                } else {
//                                                    NSLog(@"User denied to access twitter account.");
//                                                }
//                                            });
//                                        }];
//    /***************************/
//    
//    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
//    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
//                                            requestMethod:SLRequestMethodGET
//                                                      URL:url
//                                               parameters:nil];
//    
//    // とりあえず取得したアカウントの一番最初のものを使う
//    [request setAccount:[_grantedAccounts objectAtIndex:0]];
//    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSUInteger statusCode = urlResponse.statusCode;
//            if (200 <= statusCode && statusCode < 300) {
//                // JSONをパース
//                NSArray *tweets = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
//                // APIから取得した
//                
//            } else {
//                // エラー時の処理
//            }
//        });
//    }];
    
/*************************************************************************************/
    
    [_accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted){
            NSArray *accounts = [self->_accountStore accountsWithAccountType:accountType];
            
            if (accounts != nil && [accounts count] != 0) {
                ACAccount *twAccount = [accounts objectAtIndex:0];
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
                NSDictionary *params = [NSDictionary dictionaryWithObject:@"1" forKey:@"include_entities"];
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
                request.account = twAccount;
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if (urlResponse){
                        NSError *jsonError;
                        NSArray *timeline = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
                        if(timeline){
                            NSString *output = [NSString stringWithFormat:@"HTTP response status: %ld",(long)[urlResponse statusCode]];
                            NSLog(@"%@", output);
                            //NSLog(@"%@",timeline);
                            for (NSDictionary *tweet in timeline) {
                                [tweetTextArray addObject:[tweet objectForKey:@"text"]];
                                NSDictionary *user = [tweet objectForKey:@"user"];
                                [userNameArray addObject:[user objectForKey:@"screen_name"]];
                                [tweetIconArray addObject:[user objectForKey:@"profile_image_url"]];
                                // つぶやきとユーザ名をダンプ
                                NSLog(@"%@",tweet);
                                NSLog(@"%@",[user objectForKey:@"screen_name"]);
                                NSLog(@"%@",[user objectForKey:@"profile_image_url"]);
                                NSLog(@"%lu",(unsigned long)[tweetIconArray count]);
                            }
//                            firstloaded = YES;
                            tweetreloaded = YES;
                            [self.tableView reloadData];
                        }else{
                            NSLog(@"error: %@",jsonError);
                        }
                    }
                }];
            }
        }
    }];
}

- (UIImage *) makeThumbnailOfSize:(CGSize)size;
{
    UIGraphicsBeginImageContext(size);
    // draw scaled image into thumbnail context
    [tweetIcon drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    // pop the context
    UIGraphicsEndImageContext();
    if(newThumbnail == nil)
        NSLog(@"could not scale image");
    return newThumbnail;
}

//タイムラインのリロード処理
-(void)reloadTweet{
    [self loadTimelineTweet];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end