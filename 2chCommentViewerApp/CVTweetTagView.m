//
//  CVTweetTagView.m
//  2chCommentViewerApp
//
//  Created by hiroki on 13/06/30.
//  Copyright (c) 2013年 unkoCopratiion. All rights reserved.
//

#import "CVTweetTagView.h"

@interface CVTweetTagView ()

@end

@implementation CVTweetTagView

@synthesize accountId = _accountId;
@synthesize detailView = _detailView;
@synthesize accountStore = _accountStore;
@synthesize grantedAccounts = _grantedAccounts;
@synthesize firstLoad = _firstLoad;
@synthesize accessToken = _accessToken;

@synthesize tableView;
@synthesize hashTag;

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
    //検索するハッシュタグを設定
    //test code
    hashTag = @"あまちゃん";
    
    // サービスからアプリ用に割り当てられたKeyとSecret を設定
    NSString* kTwitterConsumerKey = @"aovoz75XqdBMGxj3F1dfg";
    NSString* kTwitterConsumerSecret = @"8UsZnHi2R2jJ8VVYmaGaMq1J0s0q7GFuqNeknQbY";

    consumer = [[OAConsumer alloc] initWithKey:kTwitterConsumerKey
                                                    secret:kTwitterConsumerSecret];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token&=aovoz75XqdBMGxj3F1dfg"];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil
                                                                      realm:nil
                                                          signatureProvider:nil];
    
    //test
//    NSString *address = @"https://api.twitter.com/oauth/request_token&=aovoz75XqdBMGxj3F1dfg";
//    NSURL *urlRequest = [NSURL URLWithString:address];
//    NSMutableURLRequest *request = [NSURLRequest requestWithURL:urlRequest];
    
    NSLog(@"%@",request);
    
    [request setHTTPMethod:@"POST"];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
//    consumer = [[OAConsumer alloc] initWithKey:kTwitterConsumerKey
//                                         secret:kTwitterConsumerSecret];
//    
//    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
//    
//    OAMutableURLRequest *request =[[OAMutableURLRequest alloc]
//      initWithURL:url
//      consumer:consumer
//      token:nil
//      realm:nil
//      signatureProvider:nil];
//    
//    NSLog(@"%@",request);
//    
//    [request setHTTPMethod:@"POST"];
//    
//    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
//    
//    [fetcher fetchDataWithRequest:request
//                         delegate:self
//                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
//                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];

    //twitterハッシュタグ検索結果を取得
    //[self loadTagTweet:hashTag];
    //[self tweetOAuth:hashTag];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    self.title = @"検索画面";
    
//    [self loadTagTweet:hashTag];
}

//
- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
//    if (ticket.didSucceed) {
//        NSString *responseBody =[[NSString alloc] initWithData:data
//                               encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",data);
//        NSLog(@"%@",responseBody);
//        
//        requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
//        NSLog(@"%@",requestToken);
//        
//        
//        NSString *urlString =
//        [NSString stringWithFormat:
//         @"https://api.twitter.com/oauth/authorize?oauth_token=%@",requestToken.key];
//        
//        NSURLRequest *urlRequest =
//        [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//        
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//        
//        webView.delegate = self;
//        [webView loadRequest:urlRequest];
//        [self.view addSubview:webView];
//    }
    if (ticket.didSucceed)
    {
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        NSLog(@"%@",data);
        NSLog(@"%@",responseBody);
        
        _accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        NSLog(@"%@",_accessToken);
        
        NSString *address = [NSString stringWithFormat:
                             @"https://api.twitter.com/oauth/authorize?oauth_token=%@",
                             _accessToken.key];
        
        NSURL *url = [NSURL URLWithString:address];
//        [[NSWorkspace sharedWorkspace] openURL:url];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];

        webView.delegate = self;
        [webView loadRequest:urlRequest];
        [self.view addSubview:webView];

        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)requestTokenTicket:(OAServiceTicket *)ticket
//         didFinishWithData:(NSData *)data {
//    NSString *response = [[NSString alloc] initWithData:data
//                                               encoding:NSUTF8StringEncoding];
//    NSLog(@"Response: %@", response);
//}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error {
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

// WebViewのデリゲートを設定しておいてください
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
//    if (_firstLoad) {
//        [webView performSelector:@selector(stringByEvaluatingJavaScriptFromString:)
//                      withObject: @"window.scrollBy(0,200)"
//                      afterDelay: 0];
//        _firstLoad = NO;
//    } else {
//        NSString *authPin = [self _getAuthPinInWebView:webView];
//        
//        if (authPin.length) {
//            requestToken.verifier = authPin;
//            [self _getAccessToken];
//            return;
//        }
//    }
}


// Twitter-OAuth-iPhoneから引用させていただきました
- (NSString *)_getAuthPinInWebView: (UIWebView *) theWebView {
    // Look for either 'oauth-pin' or 'oauth_pin' in the raw HTML
    NSString *js = @"var d = document.getElementById('oauth-pin'); if (d == null) d = document.getElementById('oauth_pin'); if (d) d = d.innerHTML; d;";
    NSString *pin = [[theWebView stringByEvaluatingJavaScriptFromString: js] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (pin.length == 7) {
        return pin;
    } else {
        // New version of Twitter PIN page
        js = @"var d = document.getElementById('oauth-pin'); if (d == null) d = document.getElementById('oauth_pin'); " \
        "if (d) { var d2 = d.getElementsByTagName('code'); if (d2.length > 0) d2[0].innerHTML; }";
        pin = [[theWebView stringByEvaluatingJavaScriptFromString: js] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (pin.length == 7) {
            return pin;
        }
    }
    
    return nil;
}

- (void)_getAccessToken {
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc]
                                     initWithURL:url
                                     consumer:consumer
                                     token:requestToken
                                     realm:nil
                                     signatureProvider:nil];
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSString *responseBody =
        [[NSString alloc] initWithData:data
                               encoding:NSUTF8StringEncoding];
        
        _accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        NSLog(@"%@",_accessToken);
        
    }
    
}

//twitter OAuth Request
-(void)tweetOAuth:(NSString *)message{
    //Current code is test
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    
    // サービスからアプリ用に割り当てられたKeyとSecret
    NSString* consumerKey = @"aovoz75XqdBMGxj3F1dfg";
    NSString* consumerSecret = @"8UsZnHi2R2jJ8VVYmaGaMq1J0s0q7GFuqNeknQbY";
    
    // API問い合わせにつかうクライアント単位のKeyとSecret
    NSString* tokenKey = nil;
    NSString* tokenSecret = nil;
    
    OAConsumer *consumerL = [[OAConsumer alloc]
                            initWithKey:consumerKey secret:consumerSecret];
    OAToken* token = tokenKey ? [[OAToken alloc]
                                 initWithKey:tokenKey secret:tokenSecret]  : nil;
    
    // リクエストを生成する
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc]
                                    initWithURL:url consumer:consumerL
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
    //２０件取得し表示する
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

//Twitterのタグ検索を取得する
-(void)loadTagTweet:(NSString *)str{
    
    //リロードフラグをNOにする
    if (tweetreloaded) {
        tweetreloaded = NO;
    }
    
    //ACAccountStoreオブジェクトを生成
    _accountStore = [[ACAccountStore alloc] init];
    
    //TwitterのACAccountTypeオブジェクトを取得し、それを元にアカウントを取得
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *accounts = [_accountStore accountsWithAccountType:accountType];
    NSLog(@"%@",accounts);
    if (accounts.count == 0) {
        NSLog(@"Please add twitter account on Settings");
        return;
    }
    
    [_accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted){
            NSArray *accounts = [self->_accountStore accountsWithAccountType:accountType];
            
            if (accounts != nil && [accounts count] != 0) {
                ACAccount *twAccount = [accounts objectAtIndex:0];
                NSString *string1 = @"https://api.twitter.com/1.1/search/tweets.json?q=";
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",string1,hashTag];
                NSLog(@"%@",urlStr);
                NSURL *url = [NSURL URLWithString:urlStr];
                NSDictionary *params = [NSDictionary dictionaryWithObject:@"1" forKey:@"include_entities"];
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
                request.account = twAccount;
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSLog(@"%@",urlResponse);
                    if (urlResponse){
                        NSError *jsonError;
                        NSArray *timeline = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
                        if(timeline){
                            NSString *output = [NSString stringWithFormat:@"HTTP response status: %ld",(long)[urlResponse statusCode]];
                            NSLog(@"%@", output);
                            NSLog(@"%@",urlResponse);
                            //NSLog(@"%@",timeline);
                            for (NSDictionary *tweet in timeline) {
                                [tweetTextArray addObject:[tweet objectForKey:@"text"]];
                                NSDictionary *user = [tweet objectForKey:@"user"];
                                [userNameArray addObject:[user objectForKey:@"screen_name"]];
                                [tweetIconArray addObject:[user objectForKey:@"profile_image_url"]];
                                // つぶやきダンプ
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


//アイコン画像のリサイズ用
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

@end
