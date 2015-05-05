//
//  BBMisc.h
//  bbnotes
//
//  Created by bob on 5/27/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BImage.h"
#import "BVideo.h"
#import "BAudio.h"
//#import "BRecord.h"
#import "BBRecord.h"
#import "BBContent.h"


@interface BBMisc : NSObject
+ (CGFloat)screenHeight;

+ (CGFloat)scrrenScaleSize;
+ (CGSize)scaledSizeFromSize:(CGSize)fromSize toSize:(CGSize)toSize;

+ (NSString *)saveImageToSandBox:(UIImage *)img;
+ (NSString *)saveVideoToSandBox:(NSData *)data;
+ (NSString *)saveAudioToSandBox:(NSData *)data;
+ (NSString *)getAudioPath;
+ (void)saveAudioToSandBox:(NSData *)data toPath:(NSString*)strPath;
// save image
+ (BImage *)saveAssetImageToSand:(NSData *)bigData smlImag:(UIImage *)smlImage path:(NSString *)strPath isContent:(BOOL)bContent;
+ (CGRect)getRect:(float)fX withPosY:(float)fY withwidth:(float)fW withHeight:(float)fH;

+ (UIImage *)createImageForBigWeibo:(BBRecord *)record;
+ (UIImage *)createImageForRecord:(BBRecord *)record;

//delete image of coredata file
+ (void)deleteImageFileOfCoredata:(BImage *)bimg;
+ (void)deleteRecordFileOfCoredata:(BBRecord *)brecord;


+ (void)addToolBar:(NSString *)strTitle normalImg:(NSString *)strNormal hlImg:(NSString *)strHl rect:(CGRect)rct titleHeight:(float)fH inView:(UIView *)view withTag:(int)iTag action:(SEL)action target:(id)controler;
+ (id)getANoNullObject:(id)aobject;
+ (void)logSubviews:(UIView *)superview leve:(int)iLvl;
@end
