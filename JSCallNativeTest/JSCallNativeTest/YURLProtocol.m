//
//  YURLProtocol.m
//  JSCallNativeTest
//
//  Created by 杨世昌 on 16/2/2.
//  Copyright © 2016年 杨世昌. All rights reserved.
//

#import "YURLProtocol.h"

// Contains a set of NSNumbers of addresses of controllers. It doesn't store
// the actual pointer to avoid retaining.
static NSMutableSet* gRegisteredControllers = nil;

@implementation YURLProtocol

// Called to register the URLProtocol, and to make it away of an instance of
// a ViewController.
+ (void)registerViewController:(UIViewController *)viewController
{
    if (gRegisteredControllers == nil) {
        [NSURLProtocol registerClass:[YURLProtocol class]];
        gRegisteredControllers = [[NSMutableSet alloc] initWithCapacity:8];
    }
    
    @synchronized(gRegisteredControllers) {
        [gRegisteredControllers addObject:viewController];
    }
}

+ (void)unregisterViewController:(UIViewController*)viewController
{
    @synchronized(gRegisteredControllers) {
        [gRegisteredControllers removeObject:viewController];
    }
}

+(BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSString *url = request.URL.absoluteString;
    if([url containsString:@"!test_exec"]){
        //do something
        
        NSLog(@" receieve something from js \n header: %@ ;\n body: %@ ; \n request:%@ ",request.allHTTPHeaderFields,request.HTTPBody,request);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HA HA" message:@"receieve something from js" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
            [alert show];
            
            NSString *message = request.allHTTPHeaderFields[@"rc"];
            [gRegisteredControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
                UIViewController *vc = obj;
                if ([vc respondsToSelector:@selector(receiveMessageFromJS:)]) {
                    [vc performSelector:@selector(receiveMessageFromJS:) withObject:message];
                }
            }];
        });
    }
    /*
     // 这个类不处理任何请求，所以返回 NO，如果返回 YES，则代表这个类要处理这个request，则要实现下面的几个方法。
     + (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
     + (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a
     toRequest:(NSURLRequest *)b
     - (void)startLoading
     - (void)stopLoading
     等等
     */
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a
                       toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}
- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
//    [YURLProtocol applyCustomHeaders:mutableReqeust];
    [NSURLProtocol setProperty:@(YES)
                        forKey:@"YXURLProtocolHandled"
                     inRequest:mutableReqeust];
    
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust
                                                    delegate:self];
}
- (void)stopLoading
{
    [self.connection cancel];
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [self.client URLProtocol:self
            didFailWithError:error];
}
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if (response != nil)
    {
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
    return request;
}
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}
- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [self.client URLProtocol:self
didReceiveAuthenticationChallenge:challenge];
}
- (void)connection:(NSURLConnection *)connection
didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [self.client URLProtocol:self
didCancelAuthenticationChallenge:challenge];
}
- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    [self.client URLProtocol:self
          didReceiveResponse:response
          cacheStoragePolicy:[[self request] cachePolicy]];
}
- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self
                 didLoadData:data];
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}
@end
