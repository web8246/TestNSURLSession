//
//  SessionTaskDelegateVC.m
//  TestURLSession
//
//  Created by dean on 2016/5/13.
//  Copyright © 2016年 dean. All rights reserved.
//




/*
 delegate 方法可以表明一个网络请求已经结束:     
 
          NSURLSessionTaskDelegate 的 -URLSession:task:didCompleteWithError:
 
       SURLSession 中表示传输多少字节的参数类型现在改为 int64_t
 
 
 
 NSURLSessionTaskDelegate 的 -URLSession:task:didReceiveChallenge:completionHandler: 方法来举例，completionHandler 接受两个参数：NSURLSessionAuthChallengeDisposition 和 NSURLCredential，前者为应对鉴权查询的策略，后者为需要使用的证书（仅当前者——应对鉴权查询的策略为使用证书，即 NSURLSessionAuthChallengeUseCredential 时有效，否则该参数为 NULL）
 
 
 
 
 NSURLSessionDataDelegate:
 
 
 - URLSession:dataTask:didReceiveResponse:completionHandler:
 - URLSession:dataTask:didBecomeDownloadTask:
 - URLSession:dataTask:didBecomeStreamTask:
 - URLSession:dataTask:didReceiveData:
 - URLSession:dataTask:willCacheResponse:completionHandler:

 
 
 */

#import "SessionTaskDelegateVC.h"

@interface SessionTaskDelegateVC ()<NSURLSessionDataDelegate,NSURLSessionTaskDelegate>
{
    NSMutableData *receivedData;
}

@end

@implementation SessionTaskDelegateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self getWithRequest];
    [self post3];
//    [self sendHTTPPost];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Get

#pragma mark - Get

-(void)getWithRequest
{
    
    NSURL *url = [NSURL URLWithString:@"http://120.2"];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
//    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];//要記得delegate
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    
    [dataTask resume];
}



#pragma mark - Post
//Post

-(void) sendHTTPPost
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];//要記得delegate
    
    NSURL * url = [NSURL URLWithString:@"http://ha"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * params =@"name=Ravi&loc=India&age=31&submit=true";
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask * dataTask = [delegateFreeSession dataTaskWithRequest:urlRequest];
    [dataTask resume];
    
    
}

#define Post_Url_String @"http://10"
-(void)post3
{
    
    NSURL *url = [NSURL URLWithString:Post_Url_String];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.timeoutInterval = 10.0;
    request.HTTPMethod = @"POST";
    
    NSDictionary *parametersDict = @{@"a":@"1",@"D":@"5",@"m":@"1",@"r":@"3",@"y":@"8"};
    
    NSMutableString *parameterString = [NSMutableString string];
    
    for (NSString *key in parametersDict.allKeys) {
        // 拼接字符串
        [parameterString appendFormat:@"%@=%@&", key, parametersDict[key]];
    }
    NSLog(@"parameterString: %@",parameterString);
    
    NSData *parametersData = [[parameterString substringToIndex:parameterString.length - 1] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    request.HTTPBody = parametersData;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    

    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];//要記得delegate
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    

    [task resume];
    
    
}

//统一配置NSURLSession
//-(NSURLSession *)session
//{
//    if (_session == nil) {
//        
//        //创建NSURLSessionConfiguration
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        
//        //设置请求超时为10秒钟
//        config.timeoutIntervalForRequest = 10;
//        
//        //在蜂窝网络情况下是否继续请求（上传或下载）
//        config.allowsCellularAccess = NO;
//        
//        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    }
//    return _session;
//}


#pragma mark - Delegate

// NSURLSessionDataDelegate

//取得檔案長度
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSLog(@"didReceiveResponse");
    NSLog(@"response: %@",response);
    receivedData=nil;
    receivedData=[[NSMutableData alloc] init];
    [receivedData setLength:0];
    
    completionHandler(NSURLSessionResponseAllow);
}

//取得收到的資料，data是片段的，所以必須組合，也可以在這邊做下載進度的計算
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    [receivedData appendData:data];
    NSLog(@"receivedData: %@",receivedData);
    
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received String %@",str);
}

//NSURLSessionTaskDelegate
//得知是否已經下載好了
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError");
    NSError *tempError = error;
    if (error) {
        // Handle error
        NSLog(@"error: %@",error);
    }
    else {
        NSDictionary* response=(NSDictionary*)[NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&tempError];
        NSLog(@"response: %@",response);
        // perform operations for the  NSDictionary response
    }
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"bytesSent: %lld",bytesSent);
    NSLog(@"totalBytesSent: %lld",totalBytesSent);
    NSLog(@"%.2f",1.0 * totalBytesSent/totalBytesExpectedToSend);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
