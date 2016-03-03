//
//  MCFilePath.h
//  Tools
//
//  Created by 常峻玮 on 15/11/9.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCFilePath : NSObject
+(NSString *)homePath;
+(NSString *)documentPath;
+(NSString *)libraryPath;
+(NSString *)cachePath;
+(NSString *)tmpPath;
+(NSString *)pathInHomeWithFileName:(NSString *)fileName;
+(NSString *)pathInDocumentWithFileName:(NSString *)fileName;
+(NSString *)pathInLibraryWithFileName:(NSString *)fileName;
+(NSString *)pathInCacheWithFileName:(NSString *)fileName;
+(NSString *)pathInTmpFileName:(NSString *)fileName;
+(NSString *)pathWithDirectoryPath:(NSString *)directoryPath andFileName:(NSString *)fileName;
+(NSString *)createDirectory:(NSString *)path;
@end
