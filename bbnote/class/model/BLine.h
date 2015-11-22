//
//  BLine.h
//  bbnote
//
//  Created by bob on 11/22/15.
//  Copyright © 2015 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BB_BBLine;
@interface BLine : NSObject<NSCoding>
@property (nonatomic, assign) NSUInteger line;
@property (nonatomic, assign) NSUInteger run;
@property (nonatomic, assign) NSUInteger location;
@property (nonatomic, assign) NSUInteger length;
@property (nullable, nonatomic, retain) NSString *fontname;
@property (nullable, nonatomic, retain) NSString *fontsize;
@property (nullable, nonatomic, retain) NSString *forcolor;
@property (nullable, nonatomic, retain) NSString *bgcolor;
@property (nullable, nonatomic, strong) NSString *text;

//img
@property (nullable, nonatomic, strong) NSString *fileName;
@property (nonatomic, assign)double displaySizeW;
@property (nonatomic, assign)double displaySizeH;
@property (nonatomic, assign)double orgiSizeW;
@property (nonatomic, assign)double orgiSizeH;
@property (nonatomic, assign)CGSize displaySize;
@property (nonatomic, assign)CGSize orgiSize;

- (instancetype _Nonnull)initWithBBLine:(BB_BBLine * _Nonnull)bbline;
- (NSAttributedString * _Nonnull )geneAttributedStringFromDir:(NSString * _Nonnull)strDir;
@end
