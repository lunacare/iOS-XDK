//
//  LYRUITempFileGenerator.m
//  Layer-UI-iOS
//
//  Created by Łukasz Przytuła on 25.09.2017.
//  Copyright (c) 2017 Layer. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "LYRUITempFileGenerator.h"
#import "NSData+LYRUIMD5.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface LYRUITempFileGenerator ()

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation LYRUITempFileGenerator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}

- (NSURL *)createTempFileWithData:(NSData *)fileData {
    return [self createTempFileWithData:fileData MIMEType:nil];
}

- (NSURL *)createTempFileWithData:(NSData *)fileData MIMEType:(NSString *)MIMEType {
    NSString *tempFilePath = [self tempFilePathWithName:fileData.lyr_MD5 MIMEType:MIMEType];
    if ([self.fileManager fileExistsAtPath:tempFilePath]) {
        return [NSURL fileURLWithPath:tempFilePath];
    }
    if ([self.fileManager createFileAtPath:tempFilePath contents:fileData attributes:nil]) {
        return [NSURL fileURLWithPath:tempFilePath];
    }
    return nil;
}

- (NSURL *)createTempSymlinkToURL:(NSURL *)URL forMIMEType:(NSString *)MIMEType {
    NSString *tempFilePath = [self tempFilePathWithName:[NSUUID UUID].UUIDString MIMEType:MIMEType];
    if ([self.fileManager createSymbolicLinkAtPath:tempFilePath withDestinationPath:URL.path error:nil]) {
        return [NSURL fileURLWithPath:tempFilePath];
    }
    return nil;
}

- (NSString *)tempFilePathWithName:(NSString *)fileName MIMEType:(NSString *)MIMEType {
    NSString *fileExtension = [self fileExtensionForMimeType:MIMEType];
    if (fileExtension != nil) {
        fileName = [fileName stringByAppendingPathExtension:fileExtension];
    }
    NSString *tempFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    return tempFilePath;
}

- (NSString *)fileExtensionForMimeType:(NSString *)MIMEType {
    CFStringRef mimeType = (__bridge CFStringRef)MIMEType;
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType, NULL);
    return (__bridge NSString *)(UTTypeCopyPreferredTagWithClass(uti, kUTTagClassFilenameExtension));
}

@end
