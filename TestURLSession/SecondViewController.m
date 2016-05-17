//
//  SecondViewController.m
//  TestURLSession
//
//  Created by dean on 2016/5/13.
//  Copyright © 2016年 dean. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (strong,nonatomic)UIImageView * imageview;
@property (strong,nonatomic)NSURLSession * session;
@property (strong,nonatomic)NSURLSessionDataTask * dataTask;
@property (weak, nonatomic) IBOutlet UIProgressView *progressview;
@property (nonatomic)NSUInteger expectlength;
@property (strong,nonatomic) NSMutableData * buffer;


@end
static NSString * imageURL = @"http://f12.tg";
@implementation SecondViewController
//属性全部采用惰性初始化
#pragma mark - lazy property
-(UIImageView *)imageview{
    if (!_imageview) {
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(40,40,300,200)];
        _imageview.backgroundColor = [UIColor lightGrayColor];
        _imageview.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageview;
}
-(NSMutableData *)buffer{
    if (!_buffer) {
        _buffer = [[NSMutableData alloc] init];
    }
    return _buffer;
}
-(NSURLSession*)session{
    if (!_session) {
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
-(NSURLSessionDataTask *)dataTask{
    if (!_dataTask) {
        _dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:imageURL]];
    }
    return _dataTask;
}
#pragma mark - life circle of viewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageview];
    [self.dataTask resume];//Task要resume彩绘进行实际的数据传输
    [self.session finishTasksAndInvalidate];//完成task就invalidate
}
#pragma mark - target-action
//注意判断当前Task的状态
- (IBAction)pause:(UIButton *)sender {
    if (self.dataTask.state == NSURLSessionTaskStateRunning) {
        [self.dataTask suspend];
    }
}

- (IBAction)cancel:(id)sender {
    switch (self.dataTask.state) {
        case NSURLSessionTaskStateRunning:
        case NSURLSessionTaskStateSuspended:
            [self.dataTask cancel];
            break;
        default:
            break;
    }
}
- (IBAction)resume:(id)sender {
    if (self.dataTask.state == NSURLSessionTaskStateSuspended) {
        [self.dataTask resume];
    }
}

#pragma mark -  URLSession delegate method
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    NSUInteger length = [response expectedContentLength];
    if (length != -1) {
        self.expectlength = [response expectedContentLength];//存储一共要传输的数据长度
        completionHandler(NSURLSessionResponseAllow);//继续数据传输
    }else{
        completionHandler(NSURLSessionResponseCancel);//如果Response里不包括数据长度的信息，就取消数据传输
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"error"
                                                         message:@"Do not contain property of expectedlength"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.buffer appendData:data];//数据放到缓冲区里
    self.progressview.progress = [self.buffer length]/((float) self.expectlength);//更改progressview的progress
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (!error) {
        dispatch_async(dispatch_get_main_queue(), ^{//用GCD的方式，保证在主线程上更新UI
            UIImage * image = [UIImage imageWithData:self.buffer];
            self.imageview.image = image;
            self.progressview.hidden = YES;
            self.session = nil;
            self.dataTask = nil;
        });
        
    }else{
        NSDictionary * userinfo = [error userInfo];
        NSString * failurl = [userinfo objectForKey:NSURLErrorFailingURLStringErrorKey];
        NSString * localDescription = [userinfo objectForKey:NSLocalizedDescriptionKey];
        if ([failurl isEqualToString:imageURL] && [localDescription isEqualToString:@"cancelled"]) {//如果是task被取消了，就弹出提示框
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                             message:@"The task is canceled"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [alert show];
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Unknown type error"//其他错误，则弹出错误描述
                                                             message:error.localizedDescription
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [alert show];
        }
        self.progressview.hidden = YES;
        self.session = nil;
        self.dataTask = nil;
    }
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
