//
//  AppDelegate.h
//  TheWeenkendToPlay
//
//  Created by scjy on 16/1/14.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate, WXApiDelegate>
{
    NSString *wbtoken;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarVC;
@property (strong, nonatomic) NSString *wbtoken;


@end

