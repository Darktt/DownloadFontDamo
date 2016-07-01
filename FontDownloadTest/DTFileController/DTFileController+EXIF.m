//
//  DTFileController+EXIF.m
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

@import ImageIO;

#import "DTFileController+EXIF.h"

static CFDictionaryRef GetImagePropertysWithPath(CFURLRef pathURL) {
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL(pathURL, NULL);
    
    const void *keys[1] = {kCGImageSourceShouldCache};
    const void *values[1] = {kCFBooleanTrue};
    
    CFDictionaryRef options = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 1, NULL, NULL);
    
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, options);
    CFRelease(imageSource);
    CFRelease(options);
    
    return CFAutorelease(imageProperties);
}

@implementation DTFileController (EXIF)

- (NSDictionary *)imagePropertiesWithPath:(NSString *)path
{
    NSURL *imageFileURL = [NSURL fileURLWithPath:path];
    
    NSDictionary *imageProperties = (NSDictionary *)GetImagePropertysWithPath((CFURLRef)imageFileURL);
    
    return imageProperties;
}

- (NSDictionary *)EXIFInformationWithPath:(NSString *)path
{
    NSDictionary *imageProperties = [self imagePropertiesWithPath:path];
    
    NSString *exifDictionaryKey = (NSString *)kCGImagePropertyExifDictionary;
    
    NSDictionary *EXIF = imageProperties[exifDictionaryKey];
    
    return EXIF;
}

@end
