//
//  YURLProtocol.h
//  JSCallNativeTest
//
//  Created by 杨世昌 on 16/2/2.
//  Copyright © 2016年 杨世昌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YURLProtocol : NSURLProtocol<UIAlertViewDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

+ (void)registerViewController:(UIViewController *)viewController;
+ (void)unregisterViewController:(UIViewController*)viewController;

@end
