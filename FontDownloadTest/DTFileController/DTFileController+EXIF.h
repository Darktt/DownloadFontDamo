//
//  DTFileController+EXIF.h
//
// Copyright © 2014 Darktt Personal Company. All rights reserved.
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

#import "DTFileController.h"

NS_ASSUME_NONNULL_BEGIN
@interface DTFileController (EXIF)

/**
 *  Get all of image property information from given path, such as EXIF information etc.
 *
 *  @param path The path of file. this path must be image file path.
 *
 *  @return The image property as NSDictionary object.
 *
 */
- (NSDictionary *)imagePropertiesWithPath:(NSString *)path NS_SWIFT_NAME(imageProperties(path:));

/**
 *  Get EXIF information from given path.
 *
 *  @param path The path of file. this path must be image file path.
 *
 *  @return nil, If not have EXIF information.
 */
- (NSDictionary *)EXIFInformationWithPath:(NSString *)path NS_SWIFT_NAME(EXIFInformation(path:));

@end
NS_ASSUME_NONNULL_END