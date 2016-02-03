//
//  AppDelegate.m
//  JSCallNativeTest
//
//  Created by 杨世昌 on 15/12/3.
//  Copyright © 2015年 杨世昌. All rights reserved.
//

#import "AppDelegate.h"
#import "JPEngine.h"
#import "CocoaSecurity.h"
#import "RSA.h"
#import "JSRSA.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"js"];
//    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    
    
//    [self encryptJS];
//    
//    NSString *script = [self decryptJS];
//    if (script) {
//        [JPEngine startEngine];
//        [JPEngine evaluateScript:script];
//    }
    
//    [self testRSA];
//    [self testAES];
    [self testJSRSA];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)defaultJS {
    CocoaSecurityResult *aesDefault = [CocoaSecurity aesEncrypt:@"kelp" key:@"key"];
    
    // aesDefault.base64 = 'ez9uubPneV1d2+rpjnabJw=='
    NSLog(@" encrypt result: \n %@ \n ",aesDefault.base64);
    
    CocoaSecurityResult *result = [CocoaSecurity aesDecryptWithBase64:aesDefault.base64 key:@"key"];
    NSLog(@" decrypt result: \n %@ \n ",result.utf8String);
}

- (void)encryptJS {
    NSString *path = [NSMutableString stringWithFormat:@"%@/Documents/main.js", NSHomeDirectory()];
    NSLog(@"\n path %@\n",path);
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"js"];
//    NSData *sourceData = [NSData dataWithContentsOfFile:sourcePath];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    CocoaSecurityResult *result = [CocoaSecurity aesEncrypt:script key:@"mymain.js"];
    if (result) {
        NSLog(@" encrypt result: \n %@ \n ",result.base64);
        NSError *error;
        [result.base64 writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@" \n error %@ \n ",error);
        }
    }
}

- (NSString *)decryptJS {
    NSString *path = [NSMutableString stringWithFormat:@"%@/Documents/main.js", NSHomeDirectory()];
    NSString *desscript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    CocoaSecurityResult *result = [CocoaSecurity aesDecryptWithBase64:desscript key:@"mymain.js"];
    if (result) {
        NSLog(@" decrypt result: \n %@ \n ",result.utf8String);
        return [result.utf8String copy];
    }
    return nil;
}

- (void)testRSA {
//    NSString *pubkey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDEChqe80lJLTTkJD3X3Lyd7Fj+\nzuOhDZkjuLNPog3YR20e5JcrdqI9IFzNbACY/GQVhbnbvBqYgyql8DfPCGXpn0+X\nNSxELIUw9Vh32QuhGNr3/TBpechrVeVpFPLwyaYNEk1CawgHCeQqf5uaqiaoBDOT\nqeox88Lc1ld7MsfggQIDAQAB\n-----END PUBLIC KEY-----";
//    NSString *privkey = @"-----BEGIN RSA PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMQKGp7zSUktNOQk\nPdfcvJ3sWP7O46ENmSO4s0+iDdhHbR7klyt2oj0gXM1sAJj8ZBWFudu8GpiDKqXw\nN88IZemfT5c1LEQshTD1WHfZC6EY2vf9MGl5yGtV5WkU8vDJpg0STUJrCAcJ5Cp/\nm5qqJqgEM5Op6jHzwtzWV3syx+CBAgMBAAECgYEApSzqPzE3d3uqi+tpXB71oY5J\ncfB55PIjLPDrzFX7mlacP6JVKN7dVemVp9OvMTe/UE8LSXRVaFlkLsqXC07FJjhu\nwFXHPdnUf5sanLLdnzt3Mc8vMgUamGJl+er0wdzxM1kPTh0Tmq+DSlu5TlopAHd5\nIqF3DYiORIen3xIwp0ECQQDj6GFaXWzWAu5oUq6j1msTRV3mRZnx8Amxt1ssYM0+\nJLf6QYmpkGFqiQOhHkMgVUwRFqJC8A9EVR1eqabcBXbpAkEA3DQfLVr94vsIWL6+\nVrFcPJW9Xk28CNY6Xnvkin815o2Q0JUHIIIod1eVKCiYDUzZAYAsW0gefJ49sJ4Y\niRJN2QJAKuxeQX2s/NWKfz1rRNIiUnvTBoZ/SvCxcrYcxsvoe9bAi7KCMdxObJkn\nhNXFQLav39wKbV73ESCSqnx7P58L2QJABmhR2+0A5EDvvj1WpokkqPKmfv7+ELfD\nHQq33LvU4q+N3jPn8C85ZDedNHzx57kru1pyb/mKQZANNX10M1DgCQJBAMKn0lEx\nQH2GrkjeWgGVpPZkp0YC+ztNjaUMJmY5g0INUlDgqTWFNftxe8ROvt7JtUvlgtKC\nXdXQrKaEnpebeUQ=\n-----END RSA PRIVATE KEY-----";
    
//    NSString *pubkey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCkbLqsfGDo3Qb53kTHiMFsHjTE\nGKIbvI6zTf4mvuIcuqyi48UcpQNBYn1NCmsS0gkM1hmMHZztJL3oOV6AWsBvOWQs\nOiFNneerNrVd4octtLztlNj1BSKZOcgleyPYykvraRw+aomvEQ6LRiLj+9RbIphm\nh1WWzAA528qcwiR9XQIDAQAB\n-----END PUBLIC KEY-----";
//    NSString *privkey = @"-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKBgQCkbLqsfGDo3Qb53kTHiMFsHjTEGKIbvI6zTf4mvuIcuqyi48Uc\npQNBYn1NCmsS0gkM1hmMHZztJL3oOV6AWsBvOWQsOiFNneerNrVd4octtLztlNj1\nBSKZOcgleyPYykvraRw+aomvEQ6LRiLj+9RbIphmh1WWzAA528qcwiR9XQIDAQAB\nAoGBAIUotQlJdWZA0gx7sDH0E8kOsWb6GBbkXqDhkeko/4+KspL8aT6oeHl0XMuO\nm2ZTiRbHMUtjFBqNferawyip1lswzGuSQ5CflSeA8rA+CE5lqg4r81rb734D4hvy\nwthJBRI5o9g28RbfXf9U+XTtTWwWJjs6P5kHHnTTdhdDl/WVAkEAze9O2AMkNxkE\n3jh0JYkN0b3wNEfgN2OfPz5d9Y/Vg6HhP3CAvjVyTH1tvBo0p0qlfEjZ1bDl//Xk\nOm8RGwtFawJBAMxl+ShgbjJOVVxjnRO6g25xLwTs0862u8yDWIgxhP3Lw3LnVZJQ\nsDLIBWwp8oBlJEt6/yKy7/+5pkg7XYiDMlcCQFrwvAOeV4bRUJoFmhzdSjH+S636\ns6QiJTfbhcikLOjFOuA2AVR966ylkykG9YuO5kddMH0yck83OgMn+wjTUGMCQAK2\nn9YfYZcdXxi44c7vPOtsaTlhg3ZNCrUuUTCNp7xOxityUrp8g7pI2XmUHPoDXbX6\nzgRB59m3NzPiRd2YEEUCQD3SlCVdCvdUAssbFUUeaej/u/xt4xc1TRL3tfSOZ9lh\ndAJcTJhR+xXRAwsEUDP80hR9FnoogC/CRB/ghZly94Q=\n-----END RSA PRIVATE KEY-----";
    
//    NSString *pubkey = @"-----BEGIN PUBLIC KEY-----\nMFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALcvAzJd8PZ3YsCBi9pJlr8tcsbda4vc\nvqVziWT4eI/lGmgA+DZCVzx8YQljvsdt+dRoknqlkvCAXBGqDs9snWsCAwEAAQ==\n-----END PUBLIC KEY-----";
//    NSString *privkey = @"-----BEGIN RSA PRIVATE KEY-----\nMIIBOQIBAAJBALcvAzJd8PZ3YsCBi9pJlr8tcsbda4vcvqVziWT4eI/lGmgA+DZC\nVzx8YQljvsdt+dRoknqlkvCAXBGqDs9snWsCAwEAAQJAV5LnIVYd04ZhtIx6MqJJ\nqh3tKDtEpfmjPu/MOHQ9FvTt5q2TEo/2kDpBnEn4keADK/znYljUOq83jw6O9CiT\naQIhAOPgB9s0LlJ8uZV4QRmjR45Ox2zIp5rXqB88OSkc7L+PAiEAzcrnkpXKPkD1\nnGBAstIHUDT5hRI8A327/TaoDvIlVmUCIGk8eyRWktXxV9uZb6chathjtWGdwRmX\nYsMaEuPTwdotAiAjkJNgs95Vz+gidEf6H24AIIeWxcX1XH9mjVGR86scOQIgFu2i\niegoLWki5BcCT6ND1HFYK9855meiVjdmZAonLfM=\n-----END RSA PRIVATE KEY-----";
    
    NSString *pubkey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4yXaGa1comcbjwwAO5Ytjdl0d\n1LbMErHZfEXipIfNxxj4qzvQ6kvey8n9l9skYcrmir00hQ7dL5J0jat0qrvUfKyi\nWrMUtihPxJgCyUDr3IshQpC0OmRbvukAdq0icP/WjT5ge0Ixz6gGFgzjhpG3QkLe\nL1B2OVon0MnpTHSVbwIDAQAB\n-----END PUBLIC KEY-----";
    NSString *privkey = @"-----BEGIN RSA PRIVATE KEY-----\nMIICXgIBAAKBgQC4yXaGa1comcbjwwAO5Ytjdl0d1LbMErHZfEXipIfNxxj4qzvQ\n6kvey8n9l9skYcrmir00hQ7dL5J0jat0qrvUfKyiWrMUtihPxJgCyUDr3IshQpC0\nOmRbvukAdq0icP/WjT5ge0Ixz6gGFgzjhpG3QkLeL1B2OVon0MnpTHSVbwIDAQAB\nAoGALoDc6DUpSRlyGS2g3R7ddll6U6CNpEvsICyLNd9sIdhCK4qEUi40i8xDeCN4\nTe6ibmRp+0alF/r544UnqgOxovmAmrXqDc7m8aI40dtytaH1g6kOIw7Alfh0sHMb\nmMvtCVf1XXFVqmni/QDYdbHE05PqIdOwjebxmRkXumFNe5kCQQDeppHesl1cQCX/\nFY+TajmFq5KgD8Q6vyzldgz91O7Bxr3oS7poGZy+QD7J3XQVGK1DpOKriYWFTbk7\nRUTgSQENAkEA1HcHPavRDk3qVORwAjhXtowGbDY2z3yhBtMINlVLBWMEK9YVHzuV\nthmswgzYMibMrBexQvPR5oR5916vLbp5awJBAK/DnvPGqpzgpx4vzx/4g2BaiW2C\nBM67jJ24C5l2NuUSF2kCHy1+ypYF8Ys6HyFoUZ9M0wPHlHgfW1LG5BCKkSECQQDB\n2z0DG0MrbxIxlSFSFUCK8iZmE+1c0dVHGcQzdw11g8vph3NMRRyrw69qezfEQryb\nBR8a/Mb3MsbqWz0xVySzAkEAxZcEGLhXSjtQmVJAqMggUDzUic8Ypl/g5Gi8XzXj\n72pJCBDzGLHLzAR7sBZYGn4S/gvnKJUGBSVkqKMt4lYeIA==\n-----END RSA PRIVATE KEY-----";
    
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@" \n  start \n ");
    NSString *encryption = [RSA encryptString:script publicKey:pubkey];
    NSLog(@" \n encryption %@ \n",encryption);
    
    NSLog(@" \n  start decrypt \n ");
    NSString *dencryption = [RSA decryptString:encryption privateKey:privkey];
    NSLog(@" \n decrypt %@ \n",dencryption);
}

- (void)testAES {
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@" \n  start \n ");
    CocoaSecurityResult *result = [CocoaSecurity aesEncrypt:script key:@"mymain.js"];
    if (result) {
        NSLog(@" encrypt result: \n %@ \n ",result.base64);
        
        NSLog(@" \n  start decrypt \n ");
        CocoaSecurityResult *dresult = [CocoaSecurity aesDecryptWithBase64:result.base64 key:@"mymain.js"];
        
        NSLog(@" decrypt result: \n %@ \n ",dresult.utf8String);
    }
}

- (void)testJSRSA {
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@" \n  start \n ");
    JSRSA *rsa = [JSRSA sharedInstance];
    rsa.publicKey = @"public_key_1024.pem";
    rsa.privateKey = @"private_key_1024.pem";
    
    NSString *encryption = [rsa publicEncrypt:script];
    NSLog(@" \n encryption %@ \n",encryption);
    
    NSLog(@" \n  start decrypt \n ");
    NSString *dencryption = [rsa privateDecrypt:encryption];
    NSLog(@" \n decrypt %@ \n",dencryption);
}

@end
