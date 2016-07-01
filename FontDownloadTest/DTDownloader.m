//
//  DTDownloader.m
//  FontDownloadTest
//
//  Created by EdenLi on 2016/7/1.
//  Copyright © 2016年 Darktt. All rights reserved.
//

#import "DTDownloader.h"

@import UIKit;

@interface DTDownloader () <NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@property (retain, nonatomic) NSURL *currenURL;

@property (retain, nonatomic) NSURLSessionDownloadTask *downloadTask;

@end

@implementation DTDownloader

+ (instancetype)downloaderWithURL:(NSURL *)URL
{
    DTDownloader *downloader = [[DTDownloader alloc] initWithURL:URL];
    
    return [downloader autorelease];
}

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self == nil) return nil;
    
    [self setCurrenURL:URL];
    
    return self;
}

#pragma mark - Public Methods

- (void)startDownload
{
    UIApplication *application = [UIApplication sharedApplication];
    [application setNetworkActivityIndicatorVisible:YES];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:operationQueue];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:self.currenURL];
    
    [self setDownloadTask:downloadTask];
    [self.downloadTask resume];
}

- (void)startNextWithURL:(NSURL *)URL
{
    if (self.downloadTask.state == NSURLSessionTaskStateRunning && self.downloadTask != nil) {
        
        NSLog(@"Downloader is running, current URL: %@", self.currenURL);
        return;
    }
    
    [self setCurrenURL:URL];
    [self startDownload];
}

- (void)cancel
{
    [self.downloadTask cancel];
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    if (!self.allowInsecureSSLCertificate) {
        
        completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
        return;
    }
    
    NSURLProtectionSpace *protectionSpace = challenge.protectionSpace;
    NSString *authenticationMethod = protectionSpace.authenticationMethod;
    
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        SecTrustRef serverTrust = protectionSpace.serverTrust;
        NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        
        return;
    }
    
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    UIApplication *application = [UIApplication sharedApplication];
    [application setNetworkActivityIndicatorVisible:NO];
    
    [self setDownloadTask:nil];
    
    if (error == nil) {
        return;
    }
    
    if (self.completionHandler == nil) {
        return;
    }
    
    self.completionHandler(self, nil, error);
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    UIApplication *application = [UIApplication sharedApplication];
    [application setNetworkActivityIndicatorVisible:NO];
    
    [self setDownloadTask:nil];
    if (self.completionHandler != nil) self.completionHandler(self, location, nil);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (self.progressHandler == nil) {
        
        return;
    }
    
    float percentage = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    
    self.progressHandler(percentage);
}

@end
