//
//  DownloadTaskWithDelegateVC.m
//  TestURLSession
//
//  Created by dean on 2016/5/13.
//  Copyright © 2016年 dean. All rights reserved.
//

#import "DownloadTaskWithDelegateVC.h"

#define URL_LARGE_IMAGE_1   @"http://edmu"

@interface DownloadTaskWithDelegateVC ()<NSURLSessionDownloadDelegate>

@end

@implementation DownloadTaskWithDelegateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.allowsCellularAccess = NO;
    
    // Other options for configuration, if needed. I dont need them for this test
    //    [configuration setHTTPAdditionalHeaders:some dictionary values];
    //    configuration.timeoutIntervalForRequest = 30.0;
    //    configuration.timeoutIntervalForResource = 60.0;
    //    configuration.HTTPMaximumConnectionsPerHost = 1;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:self
                                                     delegateQueue:nil];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:URL_LARGE_IMAGE_1]];
    [task resume];
    
    NSLog(@"URL = %@", URL_LARGE_IMAGE_1);
    
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSData *imageData = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       
                       NSLog(@"location%@", location);
                       NSLog(@"imageData: %@",imageData);
                       
//                       self.label_savedLocation.text = [NSString stringWithFormat:@"%@", location];   // too much text for 1 label
//                       self.imageView.image = [UIImage imageWithData:imageData];
                   });
    
    
    NSLog(@"Temporary File :%@\n", location);
    NSError *err = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    NSURL *docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"out1.zip"]];
    if ([fileManager moveItemAtURL:location
                             toURL:docsDirURL
                             error: &err])
    {
        NSLog(@"File is saved to =%@",docsDir);
    }
    else
    {
        NSLog(@"failed to move: %@",[err userInfo]);
    }

}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    long percentage = (totalBytesWritten * 100) / totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       NSLog(@"percentage :%ld",percentage);
//                       self.label_bytesExpected.text = [NSString stringWithFormat:@"Expected = %lld", totalBytesExpectedToWrite];
//                       self.label_bytesWritten.text = [NSString stringWithFormat:@"Received = %lld (%ld%%)", totalBytesWritten, percentage];
                   });
    
    
    float progress = totalBytesWritten*1.0/totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(),^ {
//        [self.progress setProgress:progress animated:YES];
    });
    NSLog(@"Progress =%f",progress);
    NSLog(@"Received: %lld bytes (Downloaded: %lld bytes)  Expected: %lld bytes.\n",
          bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
    
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
