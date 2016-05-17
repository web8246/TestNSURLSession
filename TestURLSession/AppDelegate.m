//
//  AppDelegate.m
//  TestURLSession
//
//  Created by dean on 2016/5/12.
//  Copyright © 2016年 dean. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<NSURLSessionDataDelegate,NSURLSessionDelegate>

@end

@implementation AppDelegate

//當app進入背景進行網路活動，當task完成之後：會利用這個delegate回傳
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    /*
     
     Store the completion handler. The completion handler is invoked by the view controller's checkForAllDownloadsHavingCompleted method (if all the download tasks have been completed).
     
     */

    NSLog(@"Save completionHandler");
    self.completionHandler = completionHandler;
    //Save completionHandler;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"Launching Applictions");
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






-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
}
-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    if (appDelegate.backgroundSessionCompletionHandler) {
//        
//        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
//        
//        appDelegate.backgroundSessionCompletionHandler = nil;
//        
//        completionHandler();
//        
//    }
    
    
    
    NSLog(@"All tasks are finished");
    

}


@end
