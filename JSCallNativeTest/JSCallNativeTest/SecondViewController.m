//
//  SecondViewController.m
//  JSCallNativeTest
//
//  Created by 杨世昌 on 16/1/19.
//  Copyright © 2016年 杨世昌. All rights reserved.
//

#import "SecondViewController.h"
#import "INTULocationManager.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*
     default frame:
     2016-01-23 15:45:27.192 JSCallNativeTest[36859:3230125]  button imageView frame: {{102.5, 2}, {40, 40}} , label frame: {{143, 13}, {54.5, 18}},
     2016-01-23 15:45:27.193 JSCallNativeTest[36859:3230125]  button1 imageView frame: {{91.5, 2}, {40, 40}} , label frame: {{131.5, 13}, {77, 18}},
     2016-01-23 15:45:27.194 JSCallNativeTest[36859:3230125]  button2 imageView frame: {{49.5, 2}, {40, 40}} , label frame: {{90, 13}, {160.5, 18}},
     */
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(15, 30 + 64, 300, 44);
    [button setImage:[UIImage imageNamed:@"btn_icon_normal"] forState:UIControlStateNormal];
    [button setTitle:@"location" forState:UIControlStateNormal];
    button.titleLabel.backgroundColor = [UIColor lightGrayColor];
    button.imageView.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    NSLog(@" button imageView frame: %@ , label frame: %@,  ",
          NSStringFromCGRect(button.imageView.frame),NSStringFromCGRect(button.titleLabel.frame));
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.backgroundColor = [UIColor greenColor];
    button1.frame = CGRectMake(15, CGRectGetMaxY(button.frame) + 30, 300, 44);
    [button1 setImage:[UIImage imageNamed:@"btn_icon_normal"] forState:UIControlStateNormal];
    [button1 setTitle:@"location" forState:UIControlStateNormal];
    button1.titleLabel.backgroundColor = [UIColor lightGrayColor];
    button1.imageView.backgroundColor = [UIColor yellowColor];
    button1.imageEdgeInsets = UIEdgeInsetsMake(0, button1.titleLabel.frame.size.width*2, 0, 0);
    button1.titleEdgeInsets = UIEdgeInsetsMake(0, -button1.imageView.frame.size.width * 2, 0, 0);
    // or
//    button1.imageEdgeInsets = UIEdgeInsetsMake(0, button1.titleLabel.frame.size.width, 0, -button1.titleLabel.frame.size.width);
//    button1.titleEdgeInsets = UIEdgeInsetsMake(0, -button1.imageView.frame.size.width, 0, button1.imageView.frame.size.width);
    
    [button1 addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    NSLog(@" button1 imageView frame: %@ , label frame: %@,  ",
          NSStringFromCGRect(button1.imageView.frame),NSStringFromCGRect(button1.titleLabel.frame));
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.backgroundColor = [UIColor greenColor];
    button2.frame = CGRectMake(15, CGRectGetMaxY(button1.frame) + 30, 300, 44);
    [button2 setImage:[UIImage imageNamed:@"btn_icon_normal"] forState:UIControlStateNormal];
    [button2 setTitle:@"location 123412341234" forState:UIControlStateNormal];
    button2.titleLabel.backgroundColor = [UIColor lightGrayColor];
    button2.imageView.backgroundColor = [UIColor yellowColor];
    button2.imageEdgeInsets = UIEdgeInsetsMake(0, -button2.imageView.frame.origin.x, 0, button2.imageView.frame.origin.x);
    button2.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
   
    [button2 addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    NSLog(@" button2 imageView frame: %@ , label frame: %@,  ",
          NSStringFromCGRect(button2.imageView.frame),NSStringFromCGRect(button2.titleLabel.frame));
    
//    [self addSubview];
    
    [self changeButtonPosition];
}

- (void)addSubview {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 140, 300, 44)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    UIImage *image = [UIImage imageNamed:@"btn_icon_normal"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(102.5, 2, 40, 40);
    imageView.backgroundColor = [UIColor yellowColor];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(143, 13, 54.8, 18)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = @"location";
    [view addSubview:label];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@" %@ ",self.navigationItem.backBarButtonItem);
    self.navigationItem.backBarButtonItem.tintColor = [UIColor yellowColor];
    self.navigationController.navigationBar.backItem.leftBarButtonItem.tintColor = [UIColor yellowColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)buttonPressed {
    __weak __typeof(self) weakSelf = self;
    INTULocationManager *manager = [INTULocationManager sharedInstance];
    [manager requestLocationWithDesiredAccuracy:INTULocationAccuracyHouse timeout:5.0 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        __typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"\n location:%@; \n accuracy:%d;\n status: %d \n",currentLocation,achievedAccuracy,status);
    }];
}

- (void)changeButtonPosition {
    NSArray *titles = @[@"location",@"location 34",@"location 123412341234"];
    NSArray *images = @[@"btn_icon_normal",@"btn_icon_normal",@"btn_icon_normal"];
    CGFloat top = 330;
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    CGFloat minLeft = 300/2.0;// 距离 button 左边最小距离，默认居中
    for (int i = 0; i<titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.backgroundColor = [UIColor greenColor];
        button.frame = CGRectMake(15, top, 300, 44);
        button.titleLabel.backgroundColor = [UIColor lightGrayColor];
        button.imageView.backgroundColor = [UIColor yellowColor];
        
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        NSLog(@" \n button imageView frame: %@ , label frame: %@, \n ",
              NSStringFromCGRect(button.imageView.frame),NSStringFromCGRect(button.titleLabel.frame));
        
        CGRect imageViewFrame = button.imageView.frame;
        if (imageViewFrame.origin.x < minLeft) {
            minLeft = imageViewFrame.origin.x;
        }
        
        [buttons addObject:button];
        top += (30 + 44);
    }
    // image 和 title 间距10，image 左移5，title 右移5；
    [buttons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = obj;
        CGRect imageViewFrame = button.imageView.frame;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, (minLeft -imageViewFrame.origin.x - 5)*2 , 0, 0);
        
        // title 跟着 image 移动，只不过要少移 5
//        CGRect titleLabelFrame = button.titleLabel.frame;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, (minLeft -imageViewFrame.origin.x + 5)*2 , 0, 0);
        
        NSLog(@" \n button edgeInsets imageView frame: %@ , label frame: %@, \n ",
              NSStringFromUIEdgeInsets(button.imageEdgeInsets),NSStringFromUIEdgeInsets(button.titleEdgeInsets));
        
        NSLog(@" \n button imageView frame: %@ , label frame: %@, \n ",
              NSStringFromCGRect(button.imageView.frame),NSStringFromCGRect(button.titleLabel.frame));
        
        [button setNeedsLayout];
    }];
}

@end
