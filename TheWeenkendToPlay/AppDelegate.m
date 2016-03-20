//
//  AppDelegate.m
//  TheWeenkendToPlay
//
//  Created by scjy on 16/1/14.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"
#import <BmobSDK/Bmob.h>
//1.引入定位所需的框架
#import <CoreLocation/CoreLocation.h>
//5.引入定位代理，遵循
@interface AppDelegate ()<CLLocationManagerDelegate>
{
    //2.创建定位定位所需的类的实例对象
    CLLocationManager *_locationManager;
    //创建地理编码对象1
    CLGeocoder *_geocoder;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //3.初始化定位对象
    _locationManager = [[CLLocationManager alloc] init];
    //初始化地理编码对象
    _geocoder = [[CLGeocoder alloc] init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        QJZLog(@"用户位置服务不可用!");
    }
    
    //4.如果没有授权，则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        //4.1设置代理
        _locationManager.delegate = self;
        //4.2设置定位精度。精度越高越耗电
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //4.3定位频率，每隔多少米定位一次
        CLLocationDistance distance = 100.0;
        _locationManager.distanceFilter = distance;
        //4.4启动定位服务
        [_locationManager startUpdatingLocation];
    }
    
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    [WXApi registerApp:kWeixinAppSecret];
    [Bmob registerWithAppKey:kBmobAppkey];
    
    
    //UITableBarController
    UITabBarController *tablBarVC = [[UITabBarController alloc] init];
    //创建被tabBarVC管理的视图控制器
    
    //主页
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *mainNav = mainStoryBoard.instantiateInitialViewController;
    mainNav.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic.png"];
    
    UIImage *mainselectImage = [UIImage imageNamed:@"ft_home_selected_ic"];
    //tabBar设置选中图片按照图片原始状态显示
    mainNav.tabBarItem.selectedImage = [mainselectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //调整tabBar图片显示位置：按照上，下，左，右的顺序设置
    mainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
    //发现
    UIStoryboard *discoverStoryBoard = [UIStoryboard storyboardWithName:@"DiscoverStoryboard" bundle:nil];
    UINavigationController *discoverNav = discoverStoryBoard.instantiateInitialViewController;
    discoverNav.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic.png"];
    
    UIImage *discoverselectImage = [UIImage imageNamed:@"ft_found_selected_ic"];
    //tabBar设置选中图片按照图片原始状态显示
    discoverNav.tabBarItem.selectedImage = [discoverselectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    discoverNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
    //我的
    UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    UINavigationController *mineNav = mineStoryBoard.instantiateInitialViewController;
    mineNav.tabBarItem.image = [UIImage imageNamed:@"ft_person_normal_ic.png"];
    
    UIImage *mineselectImage = [UIImage imageNamed:@"ft_person_selected_ic"];
    //tabBar设置选中图片按照图片原始状态显示
    mineNav.tabBarItem.selectedImage = [mineselectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    mineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    tablBarVC.tabBar.barTintColor = [UIColor whiteColor];
    //添加被管理的试图控制器
    tablBarVC.viewControllers = @[mainNav,discoverNav,mineNav];
    self.window.rootViewController = tablBarVC;
    

    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark ------- shareWeibo
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
    return  [WXApi handleOpenURL:url delegate:self];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
    
    return [WeiboSDK handleOpenURL:url delegate:self];
    
    
}


#pragma  mark -------- CLLocationManagerDelegeter
/*!
 定位协议代理方法
 @param manager  当前使用的定位对象
 @param location 返回定位的数据，是一个数组对象，数组里面的元素是CLLocation类型
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    QJZLog(@"%@",locations);
    //从数组中取出一个定位的信息
    CLLocation *location = [locations firstObject];
    //从CLLocation中获取坐标
    //CLLocationCoordinate2D 坐标系，里边包含经度和纬度
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"lat"];
    [userDefault setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"lng"];
    [userDefault synchronize];
    QJZLog(@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lat"],[[NSUserDefaults standardUserDefaults] valueForKey:@"lng"]);
    
    QJZLog(@"经度：%f 维度：%f 海拔：%f 航向：%f 行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        [[NSUserDefaults standardUserDefaults] setObject:placeMark.addressDictionary[@"City"] forKey:@"city"];
        //保存
        [userDefault synchronize];
    }];
    
    //如果不需要使用定位服务的时候，及时关闭定位服务
    QJZLog(@"%@ %@",_locationManager,manager);
    [_locationManager stopUpdatingLocation];
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

@end
