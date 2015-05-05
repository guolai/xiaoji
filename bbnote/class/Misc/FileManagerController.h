//
//  FileManagerController.h
//  MobileLastFM
//
//  Created by hb on 12-6-13.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileManagerController : NSObject
+ (NSString *)documentPath;
+ (BOOL) documentCreateDirectoryPath:(NSString *)strPath;
+ (BOOL) libraryCreateDirectoryPath:(NSString *)strPath;
+ (NSString *)resourcesPath;
+ (NSString *)libraryPath;
+ (NSString *)tempPath;
+ (NSArray *)allFilesInFolder:(NSString *)floderName;
+ (NSArray *)allContentsInPath:(NSString *)directoryPath;
+ (NSArray *)allFilesInPathAndItsSubpaths:(NSString *)directoryPath;

+ (BOOL)copyItem:(NSString *)strFrom toItem:(NSString *)strTo;
+ (BOOL)moveFile:(NSString *)fromPath toPath:(NSString *)toPath;
+ (BOOL) createDirectoryAtPath: (NSString *)filePath;
+ (BOOL) fileExist:(NSString *)fullFileName;

+ (BOOL)removeFile:(NSString *)strFullpath;
+ (BOOL)isDirPath:(NSString *)path;
+ (void)removeAllFilesInDoucumentDir:(NSString *)strDir withPathComponet:(NSString *)strExtension;
@end
