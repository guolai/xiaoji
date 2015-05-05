//
//  FileManagerController.m
//  MobileLastFM
//
//  Created by hb on 12-6-13.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FileManagerController.h"


@implementation FileManagerController


+ (NSString *)documentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
// strpath = aa/bb/cc/dd.txt
+ (BOOL) documentCreateDirectoryPath:(NSString *)strPath
{
    if(!strPath || [strPath isEqualToString:@""])
        return NO;
    NSArray *array = [strPath componentsSeparatedByString:@"/"];
    if(array.count < 1)
        return NO;
    NSLog(@"%@", array);
    NSString *strSubPath = @"";
    for(int i = 0; i <= array.count - 1; i++)
    {
        NSLog(@"1111111111111 %@", [array objectAtIndex:i]);
        if( i > 0)
        {
            strSubPath = [strSubPath stringByAppendingPathComponent:[array objectAtIndex:i]];
            if(![self createDirectoryAtPath:[[self documentPath] stringByAppendingPathComponent:strSubPath]])
            {
                // NSLog(@"createfile failed at path %@", [[FileManagerController documentPath] stringByAppendingPathComponent:strSubPath]);
            }
        }
        else
        {
            strSubPath = [array objectAtIndex:0];
            if(![self createDirectoryAtPath:[[self documentPath] stringByAppendingPathComponent:[array objectAtIndex:0]]])
            {
                // NSLog(@"createfile failed at path %@", [[FileManagerController documentPath] stringByAppendingPathComponent:[array objectAtIndex:0]]);
            }
        }
        
    }
    return YES;
}


+ (NSString *)resourcesPath
{
    return [[NSBundle mainBundle] resourcePath];
}

+ (NSArray *)allFilesInFolder:(NSString *)floderName
{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[self libraryPath] stringByAppendingPathComponent:floderName] error:nil];
}

+ (NSArray *) allContentsInPath:(NSString *)directoryPath
{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
}

+ (NSArray *)allFilesInPathAndItsSubpaths:(NSString *)directoryPath
{
    NSMutableArray *allContentsPathArray = [[[NSFileManager defaultManager] subpathsAtPath:directoryPath] mutableCopy];
    BOOL isDir = NO;
    for( int i = [allContentsPathArray count] - 1; i>=0; i--)
    {
        NSString *path = [allContentsPathArray objectAtIndex:i];
        if(![[NSFileManager defaultManager] fileExistsAtPath:[directoryPath stringByAppendingPathComponent:path] isDirectory:&isDir] || isDir)
        {
            [allContentsPathArray removeObject:path];
        }
    }
    return allContentsPathArray;
}

+ (NSString *)libraryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)tempPath
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,  NSUserDomainMask, YES);
//    return [paths objectAtIndex:0];
    
    return [NSString stringWithFormat:@"%@/tmp", NSHomeDirectory()];
}


+ (BOOL) createDirectoryAtPath: (NSString *)filePath
{
    return [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];

}
+ (BOOL) libraryCreateDirectory:(NSString *)dirctoryName
{
    NSString *strDocumentDirectory = [[self libraryPath] stringByAppendingPathComponent:dirctoryName];
    return [[NSFileManager defaultManager] createDirectoryAtPath:strDocumentDirectory withIntermediateDirectories:NO attributes:nil error:nil];
}

+ (BOOL) tempCreateDirectory:(NSString *)dirctoryName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,  NSUserDomainMask, YES);
    NSString *strDocumentDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:dirctoryName];
    return [[NSFileManager defaultManager] createDirectoryAtPath:strDocumentDirectory withIntermediateDirectories:NO attributes:nil error:nil];
}

// strpath = aa/bb/cc/dd.txt
+ (BOOL) libraryCreateDirectoryPath:(NSString *)strPath
{
    if(!strPath || [strPath isEqualToString:@""])
        return NO;
    NSArray *array = [strPath componentsSeparatedByString:@"/"];
    if(array.count < 1)
        return NO;
    //BBINFO(@"%@", array);
    NSString *strSubPath = @"";
    for(int i = 0; i < array.count - 1; i++)
    {
        //BBINFO(@"1111111111111 %@", [array objectAtIndex:i]);
        if( i > 0)
        {
            strSubPath = [strSubPath stringByAppendingPathComponent:[array objectAtIndex:i]];
            if(![self createDirectoryAtPath:[[self libraryPath] stringByAppendingPathComponent:strSubPath]])
            {
                // BBINFO(@"createfile failed at path %@", [[FileManagerController documentPath] stringByAppendingPathComponent:strSubPath]);
            }
        }
        else
        {
            strSubPath = [array objectAtIndex:0];
            if(![self createDirectoryAtPath:[[self libraryPath] stringByAppendingPathComponent:[array objectAtIndex:0]]])
            {
                // BBINFO(@"createfile failed at path %@", [[FileManagerController documentPath] stringByAppendingPathComponent:[array objectAtIndex:0]]);
            }
        }
        
    }
    return YES;
}

+ (BOOL) tempCreateDirectoryPath:(NSString *)strPath
{
    if(!strPath || [strPath isEqualToString:@""])
        return NO;
    NSArray *array = [strPath componentsSeparatedByString:@"/"];
    if(array.count < 1)
        return NO;
    //BBINFO(@"%@", array);
    NSString *strSubPath = @"";
    for(int i = 0; i < array.count - 1; i++)
    {
        //BBINFO(@"1111111111111 %@", [array objectAtIndex:i]);
        if( i > 0)
        {
            strSubPath = [strSubPath stringByAppendingPathComponent:[array objectAtIndex:i]];
            if(![self createDirectoryAtPath:[[self tempPath] stringByAppendingPathComponent:strSubPath]])
            {
                // BBINFO(@"createfile failed at path %@", [[FileManagerController documentPath] stringByAppendingPathComponent:strSubPath]);
            }
        }
        else
        {
            strSubPath = [array objectAtIndex:0];
            if(![self createDirectoryAtPath:[[self tempPath] stringByAppendingPathComponent:[array objectAtIndex:0]]])
            {
                // BBINFO(@"createfile failed at path %@", [[FileManagerController documentPath] stringByAppendingPathComponent:[array objectAtIndex:0]]);
            }
        }
        
    }
    return YES;
}

+ (BOOL) fileExist:(NSString *) fullFileName
{
	return [[NSFileManager defaultManager] fileExistsAtPath:fullFileName];
}

+ (BOOL)copyItem:(NSString *)strFrom toItem:(NSString *)strTo
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager copyItemAtPath:strFrom  toPath:strTo error:&error];
    if(error)
    {
        BBINFO(@"copy %@ to %@ failed, error:%@", strFrom, strTo, error.description);
        return NO;
    }
    return YES;
}

+ (BOOL)removeFile:(NSString *)strFullpath
{
    if(![self fileExist:strFullpath])
    {
        return NO;
    }
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:strFullpath error:&error];
    if(error)
    {
        BBINFO(@"remove file %@ failed ! error %@ ", strFullpath, error);
        return NO;
    }
    return YES;
}

+ (BOOL)moveFile:(NSString *)fromPath toPath:(NSString *)toPath
{
    if(![self fileExist:fromPath])
    {
        return NO;
    }
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager moveItemAtPath:fromPath toPath:toPath error:&error];
    if(error)
    {
        BBINFO(@"copy %@ to %@ failed, error:%@", fromPath, toPath, error.description);
        return NO;
    }
    return YES;
}

+ (BOOL)isDirPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    return [fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir;
}

+ (void)removeAllFilesInDoucumentDir:(NSString *)strDir withPathComponet:(NSString *)strExtension
{
    if(![self isDirPath:strDir])
        return;
    NSArray *contents = [self allContentsInPath:strDir];
    BBINFO(@"%@", contents);
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        NSString *strPath = [strDir stringByAppendingPathComponent:filename];
        BBINFO(@"%@", strPath);
        if ([[filename pathExtension] isEqualToString:strExtension]) {
            
            [self removeFile:strPath];
        }
        else
        {
            [self removeAllFilesInDoucumentDir:strPath withPathComponet:strExtension];
        }
    }
}

@end
