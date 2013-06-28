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
//@synthesize tableView;

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
    //この下にビューの初期化処理
    //今はテスト
    //ビューのインスタンスを取得する
    //UIView* view = [[UIView alloc]initWithFrame:CGRectZero];
    
    //タイムラインを取得
    [self loadTimelineTw];
    
    // view の frame は親に追加された時に調整されるので、何でも良い。
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    // tableView の frame は view.bounds 全体と仮定。他の UI 部品を配置する場合は要調整。
    UITableView *tableView = [[UITableView alloc] initWithFrame:view.bounds style:style];
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
    
//    UIViewController *viewController = [[CVTweetTableViewController alloc] init];
//	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//    
//    [self.view addSubview:[navigationController view]];
    
    // サイズを指定した生成例
    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,30)];
    
    //アプリケーションデリゲートから値を取り出す
    /*
    AppDelegate *appDelegate;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    label.text = appDelegate.touchedTableTweet;
    */
    
    /**** test code  ****/
//    label.text = touchedTable;
//    [self.view addSubview:label];
    /***             ***/
    
    //twitterのタイムラインの情報の取得
    //accountStore = [[ACAccountStore alloc] init];
    //accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //test
    //[self tweet:@"2ch"];
    
    userNameArray = [[NSMutableArray alloc] initWithCapacity:0];
    tweetTextArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    accountStore = [[ACAccountStore alloc]init];
	accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	
//	[accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
//		if(granted)
//		{
//			NSArray *accounts = [accountStore accountsWithAccountType:accountType];
//			if([accounts count] > 0)
//			{
//				account = [accounts objectAtIndex:0];
//				self.accountId = account.identifier;
//                NSLog(@"%@",account);
//			}
//		}
//	}];
    
    //test
    //[self tweetMessage];
    
    self.title = @"タイムライン";
    
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
-(void)tweet:(NSString *)message{
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
    
//    OAConsumer *consumer =
//    [[OAConsumer alloc] initWithKey:@"aovoz75XqdBMGxj3F1dfg"
//                              secret:@"8UsZnHi2R2jJ8VVYmaGaMq1J0s0q7GFuqNeknQbY"];
//    OAToken *accessToken =
//    [[OAToken alloc] initWithKey:@"215992182-56ELH2oBtBmYqltZHIwEk31ieF70e2YDii5RpHIX"
//                           secret:@"oGxMWDDJ0mtE0uzpukeb15pHP6W8iJjijmSUKUAYecI"];
    
    
//    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
//                                                                    consumer:consumer
//                                                                       token:accessToken
//                                                                       realm:nil
//                                                           signatureProvider:nil];

    [request setHTTPMethod:@"POST"];
    NSString *bodyString = [NSString stringWithFormat:@"status=%@",
                            (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(  
                                                                                kCFAllocatorDefault,
                                                                                (__bridge CFStringRef)message,
                                                                                NULL,
                                                                                NULL,
                                                                                kCFStringEncodingUTF8)];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",request);
//    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
//    [fetcher fetchDataWithRequest:request
//                         delegate:self
//                didFinishSelector:@selector(ticket:didFinishWithData:)
//                  didFailSelector:@selector(ticket:didFailWithError:)];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSLog(@"%@",userNameArray);
    NSLog(@"%@",tweetTextArray);
    cell.textLabel.text = [userNameArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [tweetTextArray objectAtIndex:indexPath.row];
//    
//    return cell;
    
    return cell;

}

//twitteAccountの取得
//- (NSArray *)fetchAccounts
//{
////    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
////    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
////        
////    NSArray *accounts = [NSArray array];
////    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:
////     ^(BOOL granted, NSError *error) {
////         if (granted) {
////             account = [accountStore accountsWithAccountType:accountType];
////         }
////     }];
////    NSLog(@"%@",account);
////    return account;
//}

//画面の初期化終了、ユーザ定義を行う
//twitterのタイムラインの取得
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    ACAccountStore *accountStoreTw = [[ACAccountStore alloc]init];
    ACAccountType *accountTypeTw = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStoreTw requestAccessToAccountsWithType:accountTypeTw options:nil completion:^(BOOL granted, NSError *error) {
        if(granted){
            NSArray *accounts = [self->accountStore accountsWithAccountType:accountType];
            
            if (accounts != nil && [accounts count] != 0) {
                ACAccount *twAccount = [accounts objectAtIndex:0];
                NSURL *url = [NSURL URLWithString:@"http://twitter.com/1/statuses/public_timeline.format"];
                    NSDictionary *params = [NSDictionary dictionaryWithObject:@"1" forKey:@"include_entities"];
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
                request.account = twAccount;
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if (urlResponse){
                        NSError *jsonError;
                        NSArray *timeline = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
                        if(timeline){
//                            NSString *output = [NSString stringWithFormat:@"HTTP response status: %ld",[urlResponse statusCode]];
//                            NSLog(@"%@", output);
                            NSLog(@"%@",timeline);
                        }else{
                            NSLog(@"error: %@",jsonError);
                        }
                    }
                }];
            }
        }
    }];
}

//Twitterのタイムラインを取得する
-(void)loadTimelineTw{
    ACAccountStore *accountStoreTw = [[ACAccountStore alloc]init];
    ACAccountType *accountTypeTw = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStoreTw requestAccessToAccountsWithType:accountTypeTw options:nil completion:^(BOOL granted, NSError *error) {
        if(granted){
            NSArray *accounts = [self->accountStore accountsWithAccountType:accountType];
            
            if (accounts != nil && [accounts count] != 0) {
                ACAccount *twAccount = [accounts objectAtIndex:0];
                NSURL *url = [NSURL URLWithString:@"http://twitter.com/1/statuses/public_timeline.format"];
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
                            NSLog(@"%@",timeline);
                            
                            for (NSDictionary *tweet in timeline) {
                                [tweetTextArray addObject:[tweet objectForKey:@"text"]];
                                NSDictionary *user = [tweet objectForKey:@"user"];
                                [userNameArray addObject:[user objectForKey:@"screen_name"]];
                            }
                        }else{
                            NSLog(@"error: %@",jsonError);
                        }
                    }
                }];
            }
        }
    }];
}

//twitterのタイムラインをテーブル形式で表示させる。メソッド名はあとで書き換える
- (void)loadTimeline{
	
    //未認可のリクエストトークンをtwitterから取得
    OAConsumer *consumer =
    [[OAConsumer alloc] initWithKey:@"aovoz75XqdBMGxj3F1dfg"
                            secret:@"8UsZnHi2R2jJ8VVYmaGaMq1J0s0q7GFuqNeknQbY"];
    OAToken *accessToken =
        [[OAToken alloc] initWithKey:@"215992182-56ELH2oBtBmYqltZHIwEk31ieF70e2YDii5RpHIX"
                        secret:@"oGxMWDDJ0mtE0uzpukeb15pHP6W8iJjijmSUKUAYecI"];

    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1.1/statuses/firehose"];

    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                 consumer:consumer
                                                                    token:accessToken
                                                                    realm:nil
                                                        signatureProvider:nil];
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];

    
    accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	
	[accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
		if(granted)
		{
			NSArray *accountstores = [accountStore accountsWithAccountType:accountType];
			if([accountstores count] > 0)
			{
				account = [accountstores objectAtIndex:0];
				self.accountId = account.identifier;
			}
		}
	}];
    
    
    [accountStore requestAccessToAccountsWithType:accountType
                            withCompletionHandler:^(BOOL granted, NSError *error) {
                                if (granted) {
                                    
                                    if (account == nil) {
                                        NSArray *accountArray = [accountStore accountsWithAccountType:accountType];
//                                        NSArray *accountArray = [self fetchAccounts];
                                        account = [accountArray objectAtIndex:0];
                                        NSLog(@"%@",account);
                                    }
                                    
                                    if (account != nil) {
                                        NSURL *url = [NSURL URLWithString:@"h‌ttp://api.twitter.com/1.1/statuses/home_timeline.json"];
                                        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                                        [params setObject:@"20" forKey:@"count"];
                                        [params setObject:@"1" forKey:@"include_entities"];
                                        [params setObject:@"1" forKey:@"include_rts"];
                                        
                                        //iOS6非推奨の為Social Frameworkを使ったものに変更
//                                        TWRequest *request = [[TWRequest alloc] initWithURL:url
//                                                                                 parameters:params
//                                                                              requestMethod:TWRequestMethodGET];
                                        
                                        SLRequest *request = [SLRequest requestForServiceType:
                                                                                SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodPOST
                                            URL:url
                                            parameters:params];
                                        [request setAccount:account];
                                        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                            
                                            if (responseData) {
                                                NSError *jsonError;
                                                NSArray *timeline = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                                    options:NSJSONReadingMutableLeaves error:&jsonError];
                                                NSLog(@"%@", timeline);
                                            }
                                            
                                        }];
                                    }
                                }
                            }];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end