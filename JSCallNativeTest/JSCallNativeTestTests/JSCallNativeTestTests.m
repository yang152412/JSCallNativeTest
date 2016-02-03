//
//  JSCallNativeTestTests.m
//  JSCallNativeTestTests
//
//  Created by 杨世昌 on 15/12/3.
//  Copyright © 2015年 杨世昌. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface JSCallNativeTestTests : XCTestCase

@end

@implementation JSCallNativeTestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void)testAtrue {
    NSLog(@"0000000000000000000000");
    XCTAssert(1, @"Can not be zero");
}

- (void)testFetchUserRemoveUid
{
    NSMutableArray *_needFetchUsers = [[NSMutableArray alloc] initWithObjects:@"1",@"2", nil];
    NSInteger uid = 1;
    NSString *uidStr = [NSString stringWithFormat:@"%d",uid];
    for (NSString *string in _needFetchUsers) {
        if ([string isEqualToString:uidStr]) {
            [_needFetchUsers removeObject:string];
            break;
        }
    }
}

@end
