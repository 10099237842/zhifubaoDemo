//
//  AppDelegate.m
//  zhifubaoTest
//
//  Created by 合一网络 on 16/1/13.
//  Copyright © 2016年 合一网络. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    RootViewController * rootVC = [RootViewController new];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:rootVC];
    self.window.rootViewController = nav;

    return YES;
}


#pragma mark  程序外app回调
//程序外app回调都在这一个代理方法里面写 ,比如微信支付 ,友盟分享等
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //支付宝回调
    if ([url.host isEqualToString:@"safepay"]) {
        //这个是进程KILL掉之后也会调用，这个只是第一次授权回调，同时也会返回支付信息
        [[AlipaySDK defaultService]processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSString * str = resultDic[@"result"];
            NSLog(@"result = %@",str);
        }];
        //跳转支付宝钱包进行支付，处理支付结果，这个只是辅佐订单支付结果回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            //结果
            NSString * message;
            switch([resultDic[@"resultStatus"] integerValue])
            {
                case 9000:message = @"订单支付成功";
                    break;
                case 8000:message = @"正在处理中";
                    break;
                case 4000:message = @"订单支付失败";
                    break;
                case 6001:message = @"用户中途取消";
                    break;
                case 6002:message = @"网络连接错误";
                    break;
                default:message = @"未知错误";
            }
        }];
    }
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

@end
