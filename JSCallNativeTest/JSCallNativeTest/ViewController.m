//
//  ViewController.m
//  JSCallNativeTest
//
//  Created by 杨世昌 on 15/12/3.
//  Copyright © 2015年 杨世昌. All rights reserved.
//

#import "ViewController.h"
#import "WebViewJavascriptBridge.h"
#import "SecondViewController.h"
#import "YURLProtocol.h"
#import "AFNetworking.h"

@interface ViewController ()<UIWebViewDelegate,NSURLConnectionDelegate>
@property WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) NSURLRequest *lastRequest;
@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"call view controller init");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    webView.delegate = self;
    
//    [self javascriptBridge:webView];
    
    [YURLProtocol registerViewController:self];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    [webView loadData:data MIMEType:@"html" textEncodingName:@"utf-8" baseURL:nil];
    
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [webView loadRequest:request];
    [self.view addSubview:webView];
//    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSString *string = @"http://callclient/?method=md5sign&param=%7B%22sign_json_string%22:%7B%22product_ids%22:%22%5B%7B%5C%22id%5C%22:%5C%225677b61adb26cebb488b60f0%5C%22,%5C%22sizes%5C%22:%5B%7B%5C%22title%5C%22:%5C%22%E5%8A%A0%E6%96%99%5C%22,%5C%22values%5C%22:%5B%5C%22Q%E6%9E%9C%5C%22%5D%7D,%7B%5C%22title%5C%22:%5C%22%E7%94%9C%E5%BA%A6%5C%22,%5C%22values%5C%22:%5B%5C%22%E5%85%A8%E7%B3%96%5C%22%5D%7D,%7B%5C%22title%5C%22:%5C%22%E5%A4%A7%E5%B0%8F&%E6%B8%A9%E5%BA%A6%5C%22,%5C%22values%5C%22:%5B%5C%22%E4%B8%AD%E6%9D%AF%E7%83%AD%E9%A5%AE%5C%22%5D%7D%5D%7D%5D%22,%22time%22:%221450688849640%22,%22app_client_id%22:%221%22,%22uid%22:%22563c123995f6b15fb9a61b2c%22,%22village_id%22:%225292ced01944528014c4100f%22,%22api_version%22:%225.4.0%22,%22device_id%22:%22d2585f022f20ac9876e47cb5eac2580c38436472%22%7D%7D&callback=require.callSign";
    
    /*
     http://callclient/?method=md5sign&param={"sign_json_string":{"product_ids":"[{\"id\":\"5677b61adb26cebb488b60f0\",\"sizes\":[{\"title\":\"加料\",\"values\":[\"Q果\"]},{\"title\":\"甜度\",\"values\":[\"全糖\"]},{\"title\":\"大小&温度\",\"values\":[\"中杯热饮\"]}]}]","time":"1450688849640","app_client_id":"1","uid":"563c123995f6b15fb9a61b2c","village_id":"5292ced01944528014c4100f","api_version":"5.4.0","device_id":"d2585f022f20ac9876e47cb5eac2580c38436472"}}&callback=require.callSign
     */
    NSString *decodeStr = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self jiexi:@"param" webaddress:decodeStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"\n webView should load request:%@ \n navigationType:%ld \n",request,(long)navigationType);
    self.lastRequest = request;
    if ([request.URL.scheme isEqualToString:@"jscallnative"]) {
        
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *body = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    if (body.length < 1)
    {// 空白页
        NSLog(@"Reconstructing request...  %@",self.lastRequest);
        NSString *uniqueURL = [NSString stringWithFormat:@"%@?t=%@", self.lastRequest.URL, [[NSProcessInfo processInfo] globallyUniqueString]];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:uniqueURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0]];
    }
}

- (void)showAlertInstance {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
    [alertView show];
}

+ (void)showAlertClass {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
    [alertView show];
}


-(NSString *) jiexi:(NSString *)CS webaddress:(NSString *)webaddress
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",CS];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    // NSString *webaddress=@"http://wgpc.wzsafety.gov.cn/dd/adb.htm?adc=e12&xx=lkw&dalsjd=12";
    NSArray *matches = [regex matchesInString:webaddress
                                      options:0
                                        range:NSMakeRange(0, [webaddress length])];
    for (NSTextCheckingResult *match in matches) {
        //NSRange matchRange = [match range];
        //NSString *tagString = [webaddress substringWithRange:matchRange];  // 整个匹配串
        //        NSRange r1 = [match rangeAtIndex:1];
        //        if (!NSEqualRanges(r1, NSMakeRange(NSNotFound, 0))) {    // 由时分组1可能没有找到相应的匹配，用这种办法来判断
        //            //NSString *tagName = [webaddress substringWithRange:r1];  // 分组1所对应的串
        //            return @"";
        //        }
        
        NSString *tagValue = [webaddress substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        NSLog(@"分组2所对应的串:%@\n",tagValue);
//        return tagValue;
    }
    return @"";
}

#pragma mark - JavaScriptBridge
- (void)javascriptBridge:(UIWebView *)webView {
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            responseCallback(@"Response from testObjcCallback");
        });
        
        [self gotoSecond];
    }];

    [_bridge send:@{@"uid":@"1234567890"} responseCallback:^(id responseData) {
        
    }];
    
    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" } responseCallback:^(id responseData) {
        
    }];
    
//    [_bridge send:@"A string sent from ObjC before Webview has loaded." responseCallback:^(id responseData) {
//        NSLog(@"objc got response! %@", responseData);
//    }];

}

#pragma mark - Cordova

- (void)gotoSecond {
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - XMLHTTPRequest
- (void)receiveMessageFromJS:(id)message {
    NSLog(@"%@",message);
    
    [self loadNormalRequest];
}

#pragma mark - afnetworking 
- (void)loadNormalRequest {
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    [manager GET:@"https://www.baidu.com" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@" success %@ ",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@" failed %@ ",error);
//    }];
    
    NSURL *URL = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      // ... 
                                  }]; 
    
    [task resume];
    
//    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
//    [connection start];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    
}
- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    
}

@end
