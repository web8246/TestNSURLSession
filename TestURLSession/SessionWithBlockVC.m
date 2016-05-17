//
//  SessionWithBlockVC.m
//  TestURLSession
//
//  Created by dean on 2016/5/13.
//  Copyright © 2016年 dean. All rights reserved.
//




//*************************************講解*******************************************

//NSURLSessionConfiguration（工作模式）
/*
 NSURLSessionConfiguration 有三种模式
 1.     defaultSessionConfiguration
 默认模式，和 NSURLConnection 类似，使用全局单例，通过 Cache 和 Cookie 存储对象
 
 2.     ephemeralSessionConfiguration
 及时模式，不能持续使用 Cache 和 Cookie 存储对象
 
 3.     backgroundSessionConfiguration
 后台模式，可以在后台完成上传下载，创建 configuration 的时候，需要有一个 identifier，用于 session 在后台工作的时候，确定是哪一个 session 完成的
 
 下载一般会去自定义 session，同时设置代理，并且如果设置了代理，block 就不会再起作用
 NSURLSessionDownloadTask 会把下载的文件放到 tmp 文件夹里面，记得自己去做存储
 
 原文链接：http://www.jianshu.com/p/d5e3175de12b
 
 
 
 對task（任務）可以做三種處理
 star：[_downloadTask resume];
 cancel：  [_downloadTask cancel];
 suspend：[_downloadTask suspend];
 
 */





#import "SessionWithBlockVC.h"




@interface SessionWithBlockVC ()

@end

@implementation SessionWithBlockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //    [self getWithURL];
    //    [self getWithRequest];
    //    [self post2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//****************************************Get****************************************

//NSURLSessionDataTask:適合小數據：（JSON or Plist or HTML or XML or 小圖片）P.S.(Postscript)

//Get:有兩種方式去處理NSURLSessionDataTask，一種是dataTaskWithURL，另外一種是用request (使用block時)

//使用block方式：不注重過程，只看結果，使用簡單

-(void)getWithURL
{
    NSURL *url = [NSURL URLWithString:@"http://"];
    // data 或者 request 都是可以的
    NSURLSessionDataTask *taskGET = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && data.length > 0) {
            NSLog(@"data -- %@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
        } else {
            NSLog(@"error -- %@", error);
            NSLog(@"response -- %@", response);
        }
    }];
    [taskGET resume];
}

-(void)getWithRequest
{
    //对请求路径的说明
    //http://120.25.226.186:32812/login?username=520it&pwd=520&type=JSON
    //协议头+主机地址+接口名称+？+参数1&参数2&参数3
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)+？+参数1(username=520it)&参数2(pwd=520)&参数3(type=JSON)
    //GET请求，直接把请求参数跟在URL的后面以？隔开，多个参数之间以&符号拼接
    
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.2"];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"Success%@",dic);
            NSLog(@"Success:L%@",dict);
        } else {
            NSLog(@"Error: %@",error);
            NSLog(@"ErrorLL: %@",error.localizedDescription);
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}





//****************************************post****************************************
-(void)post
{
    NSURL *url = [NSURL URLWithString:@"http://12"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSData *requestBody = [@"username=username&password=pwd" dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBody;
    NSURLSessionDataTask *taskPOST = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && data.length > 0) {
            NSLog(@"data -- %@", data);
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"result -- %@", result);
        } else {
            NSLog(@"error -- %@", error);
            NSLog(@"response -- %@", response);
        }
    }];
    [taskPOST resume];
}

-(void)post2
{
    //POST方式
    NSString *urlString = @"http://kai";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request setHTTPMethod:@"POST"];
    NSString *httpBodyString = @"page=1&catid=4";
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"Success%@",dic);
        }else{
            NSLog(@"Error: %@",error.localizedDescription);
        }
    }];
    [task resume];
}


#define Post_Url_String @"http://"
-(void)post3
{
    // 1、创建URL资源地址
    NSURL *url = [NSURL URLWithString:Post_Url_String];
    // 2、创建Reuest请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 3、配置Request
    request.timeoutInterval = 10.0;
    request.HTTPMethod = @"POST";
    // 4、构造请求参数
    // 4.1、创建字典参数，将参数放入字典中，可防止程序员在主观意识上犯错误，即参数写错。
    NSDictionary *parametersDict = @{@"apikey":@"1",@"D":@"77",@"or":@"99",@"or":@"99",@"y":@"77"};
    // 4.2、遍历字典，以“key=value&”的方式创建参数字符串。
    NSMutableString *parameterString = [NSMutableString string];
    
    for (NSString *key in parametersDict.allKeys) {
        // 拼接字符串
        [parameterString appendFormat:@"%@=%@&", key, parametersDict[key]];
    }
    NSLog(@"parameterString: %@",parameterString);
    // 4.3、截取参数字符串，去掉最后一个“&”，并且将其转成NSData数据类型。
    NSData *parametersData = [[parameterString substringToIndex:parameterString.length - 1] dataUsingEncoding:NSUTF8StringEncoding];
    
    // 5、设置请求报文
    request.HTTPBody = parametersData;
    // 6、构造NSURLSessionConfiguration
    //    NSURLSessionConfiguration *cc = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    //    NSURLSessionConfiguration *cc = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@""];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 7、创建网络会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    //    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:<#(nullable NSOperationQueue *)#> ];
    // 8、创建会话任务
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error: %@",error);
        } else {
            NSLog(@"Success: %@",[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error]);
        }
        
        // 10、判断是否请求成功
        //        if (error) {
        //            NSLog(error.localizedDescription);
        //        }else {
        //            // 如果请求成功，则解析数据。
        //            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        //            // 11、判断是否解析成功
        //            if (error) {
        //                NSLog(error.localizedDescription);
        //            }else {
        //                // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
        //                NSLog(object);
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    // 刷新界面...
        //                });
        //            }
        //        }
        
    }];
    // 9、执行任务
    [task resume];
    
    
}
//******************************************NSURLSessionUploadTask**************************************

#define kBoundary @"suxiaonao"
- (void)testSessionUploadTask {
    // create URL
    NSURL *url = [NSURL URLWithString:@"http://"];
    // create POST request
    // 上传一般不会用到 GET 请求
    // 首先，字面理解 POST 就更合适一些
    // 其次，GET 请求会把请求体拼接在 URL 后面，虽然 HTTP 没有限制 URL 的长度，但是，服务器和浏览器会有限制
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // request method
    request.HTTPMethod = @"POST";
    // request head setValue: forHTTPHeaderField:
    // 这儿需要设置一下 HTTPHeaderField，感觉是和 kBoundary 有关，因为后面拼接请求体的时候也是需要用到 kBoundary 的，如果我们在这儿给某个 HTTPHeaderField 赋值了，就会替换掉默认值，并且需要注意大小写敏感
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", kBoundary] forHTTPHeaderField:@"Content-Type"];
    // request body
    // connection 是把上传数据放在请求体里面，session 会把上传数据放在 uploadTaskWithRequest: 这个方法的第二个参数里面
    // session send upload
    // dataWithFieldName: 就是在做请求体拼接
    NSURLSessionUploadTask *uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:[self dataWithFieldName:@"userfile" fileName:@"cba.txt" fileContent:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"abc.txt" ofType:nil] encoding:NSUTF8StringEncoding error:NULL]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && data.length > 0) {
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"result -- %@", result);
        } else {
            NSLog(@"error -- %@", error);
        }
    }];
    
    [uploadTask resume];
}

//-----------------------------1499715155697045246716155137
//Content-Disposition: form-data; name="userfile"; filename="abc.txt"
//Content-Type: text/plain
//
//Hello!!
//-----------------------------1499715155697045246716155137--
- (NSData *)dataWithFieldName:(NSString *)fieldName fileName:(NSString *)fileName fileContent:(NSString *)fileContent {
    NSMutableString *stringM = [NSMutableString string];
    [stringM appendFormat:@"--%@\r\n", kBoundary];
    [stringM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", fieldName, fileName];
    // Content-Type 有很多，如果不确定，写 application/octet-strea 就好
    //    [stringM appendString:@"Content-Type: text/plain\r\n\r\n"];
    //    [stringM appendString:@"Content-Type: image/png\r\n\r\n"];
    [stringM appendString:@"Content-Type: application/octet-strea\r\n\r\n"];
    [stringM appendFormat:@"%@\r\n", fileContent];
    [stringM appendFormat:@"--%@--\r\n\r\n", kBoundary];
    NSData *data = [stringM.copy dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
}

-(void)testSessionUploadTask2
{
    NSString *urlString = @"";/*目标服务器url*/
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:[NSData dataWithContentsOfFile:@""]/*要上传的数据*/ completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            //TODO: 上传成功的操作
        }else{
            NSLog(@"error: %@",error.localizedDescription);
        }
    }];
    [uploadTask resume];
    
}


//******************************************NSURLSessionDownloadTask******************************************


-(void)downloadWithDownloadTask
{
    
    
    NSURL *url = [NSURL URLWithString:@"http://127."];
    // 这儿用的是 defaultSessionConfiguration
    NSURLSession *downloadSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    NSURLSessionDownloadTask *downloadTask = [downloadSession downloadTaskWithURL:url];
    [downloadTask resume];
    // 然后根据需要实现代理方法就好
    //要記得加入：<NSURLSessionDownloadDelegate>
}

-(void)downloadWithDownloadTask2
{
    NSString *urlString = @"https://www.googlei";
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            //将下载的临时数据移到本地持久化
            NSString *docpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *filePath = [docpath stringByAppendingPathComponent:[[response URL] lastPathComponent]];
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                //TODO: 更新UI
                //                self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
            });
        }else{
            NSLog(@"error: %@",error.localizedDescription);
        }
        
//        if(error == nil)
//        {
//            NSLog(@"Temporary file =%@",location);
//            
//            NSError *err = nil;
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//            
//            
//            NSURL *docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"out.zip"]];
//            if ([fileManager moveItemAtURL:location
//                                     toURL:docsDirURL
//                                     error: &err])
//            {
//                NSLog(@"File is saved to =%@",docsDir);
//            }
//            else
//            {
//                NSLog(@"failed to move: %@",[err userInfo]);
//            }
//            
//            
//        }

        
        
    }];
    [downloadTask resume];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
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
