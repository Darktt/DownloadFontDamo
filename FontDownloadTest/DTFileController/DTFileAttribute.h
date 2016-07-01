//
//  DTFileAttribute.h
//
// Copyright © 2013 Darktt Personal Company. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface DTFileAttribute : NSObject

@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) NSString *filePathExtension;
@property (nonatomic, readonly) NSNumber *fileSize;
@property (nonatomic, readonly) NSDate *fileCreationDate;
@property (nonatomic, readonly) NSDate *fileModificationDate;

+ (instancetype)fileAttributeWithPath:(NSString *)filePath;
+ (instancetype)fileAttributeWithURL:(NSURL *)fileURL;

- (instancetype)initWithPath:(NSString *)filePath;
- (instancetype)initWithURL:(NSURL *)fileURL;

@end

NS_ASSUME_NONNULL_END