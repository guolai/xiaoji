//
//  DeleteBtn.h
//  M6s
//
//  Created by Apple on 13-5-28.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeleteBtnDelegate <NSObject>
- (void)deleteBtnDidTaped:(NSString *)str;
@end

@interface DeleteBtn : UIView
@property (nonatomic, assign) id<DeleteBtnDelegate> btnDelegate;
@property (nonatomic, retain) NSString *strPath;
- (id)initWithImage:(UIImage *)img andPath:(NSString *)str;
@end


@protocol SaveimageDelegate <NSObject>

- (void)saveImageCompleted:(NSString *)str;
- (void)saveImageBegin:(NSString *)str;

@end

@interface  SelectedImageScrollView: UIView<DeleteBtnDelegate>
{
    int iMax_;
    UILabel *lblMax_;
    UIScrollView *scrView_;
}

- (id)initWithFrame:(CGRect)frame maxCount:(int)max;
@property (nonatomic, retain)NSMutableArray *arrayImg;
@property (nonatomic, retain)NSMutableArray *arrayView;
@property (nonatomic, assign)id<SaveimageDelegate> saveDelegate;


- (NSString *)checkIsSaved:(NSString *)strName;
- (BOOL)addImage:(UIImage *)img thumbnail:(UIImage *)thumbImage bigImageData:(NSData *)data andName:(NSString *)strName toPath:(NSString *)strPath;


- (void)saveAllImage;
@end