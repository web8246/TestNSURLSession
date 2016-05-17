//
//  ViewController.m
//  TestURLSession
//
//  Created by dean on 2016/5/12.
//  Copyright © 2016年 dean. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDownloadDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//****************************************NSURLSessionDelegate****************************************

//Session被 invalide得到的事件
-(void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    
}
//Session层次收到了授权，证书等问题
-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    
}


//***************************************NSURLSessionTaskDelegate*****************************************
//NSURLSessionTaskDelegate是使用代理的时候，任何种类task都要实现的代理
//Task完成的事件
//3.当请求完成(成功|失败)的时候会调用该方法，如果请求失败，则error有值
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError--%@",[NSThread currentThread]);
    
    //    if(error == nil)
    //    {
    //        //解析数据,JSON解析请参考http://www.cnblogs.com/wendingding/p/3815303.html
    //        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:nil];
    //        NSLog(@"%@",dict);
    //    }
}

//Task层次收到了授权，证书等问题
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,
                             NSURLCredential *credential))completionHandler
{
    
}
//将会进行HTTP，重定向
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    
}

//************************************NSURLSessionDataDelegate******************************************

//NSURLSessionDataDelegate特别用来处理dataTask的事件


//收到了Response，这个Response包括了HTTP的header（数据长度，类型等信息），这里可以决定DataTask以何种方式继续（继续，取消，转变为Download）
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    //在该方法中可以得到响应头信息，即response
    NSLog(@"didReceiveResponse--%@",[NSThread currentThread]);
    
    //注意：需要使用completionHandler回调告诉系统应该如何处理服务器返回的数据
    //默认是取消的
    /*
     59         NSURLSessionResponseCancel = 0,        默认的处理方式，取消
     60         NSURLSessionResponseAllow = 1,         接收服务器返回的数据
     61         NSURLSessionResponseBecomeDownload = 2,变成一个下载请求
     62         NSURLSessionResponseBecomeStream        变成一个流
     63      */
    
    completionHandler(NSURLSessionResponseAllow);
}

//DataTask已经转变成DownloadTask
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    
}

//每收到一次Data时候调用
//2.接收到服务器返回数据的时候会调用该方法，如果数据较大那么该方法可能会调用多次
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData--%@",[NSThread currentThread]);
    
    //拼接服务器返回的数据
//    [self.responseData appendData:data];
}

//是否把Response存储到Cache中
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    
}


@end
