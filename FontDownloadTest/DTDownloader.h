//
//  DTDownloader.h
//
//  Created by Darktt on 16/7/1.
//  Copyright © 2016 Darktt. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN
@class DTDownloader;

typedef void (^DTDownloadProgressHandler) (DTDownloader *downloader, float percentage);
typedef void (^DTDownloadCompletionHandler) (DTDownloader *downloader, NSURL * _Nullable location, NSError * _Nullable error);

@interface DTDownloader : NSObject

@property (readonly) NSURL *currenURL;

@property (assign) BOOL allowInsecureSSLCertificate;

@property (copy, nullable) DTDownloadProgressHandler progressHandler;
@property (copy) DTDownloadCompletionHandler completionHandler;

+ (instancetype)downloaderWithURL:(NSURL *)URL;

- (void)startDownload;
- (void)startNextWithURL:(NSURL *)URL NS_SWIFT_NAME(startNext(url:));

- (void)cancel;

@end
NS_ASSUME_NONNULL_END