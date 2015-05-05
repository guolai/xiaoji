//
//  TimeLimeCell.m
//  Zine
//
//  Created by bob on 9/21/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import "TimeLimeCell.h"
#import "NSDate+String.h"
#import "FileManagerController.h"
#import "DataModel.h"
#import "UIImage+Extensions.h"
#import "BBUserDefault.h"


#define TIMELINE_TABLEVIEW_INSETS UIEdgeInsetsMake(2, 0, 2, 0);
#define TIMELINE_VIEW_PADDING 14
#define kTIMELINE_SELECTED @"isTimeSelected"




@implementation ActivityCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIActivityIndicatorView *newSpin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [newSpin startAnimating];
        [newSpin setFrame:CGRectMake( (SCR_WIDTH - 20) / 2, (40  - 20) / 2, 20, 20)];
        [self addSubview:newSpin];
    }
    return self;
}

@end





@implementation BBRiefsCell
@synthesize delegate;
@synthesize arrayViews;
@synthesize cellStyle;

- (void)dealloc
{
//    BBDEALLOC();
    [self stopObserving];
    self.arrayViews = nil;
    self.delegate = nil;
}

- (id)initWithReuseIdentifier:strIndefi
{
    if((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndefi]))
    {
//        BBDEALLOC();
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        [self initColums];
    }
    return self;
}



- (void)initColums
{
    int iAssetsPerRow = self.frame.size.width / TIMELINE_SELECT_RECT.size.width;
    self.arrayViews = [NSMutableArray arrayWithCapacity:iAssetsPerRow];
    float fContainerWidth = iAssetsPerRow * TIMELINE_SELECT_RECT.size.width + (iAssetsPerRow - 1) * TIMELINE_VIEW_PADDING;
    
    CGRect containerFrame;
    containerFrame.origin.x = (self.frame.size.width - fContainerWidth) / 2;
    containerFrame.origin.y = 2;
    containerFrame.size.width = fContainerWidth;
    containerFrame.size.height = TIMELINE_SELECT_RECT.size.height;

    CGRect rct = TIMELINE_SELECT_RECT;
    rct.origin.x = containerFrame.origin.x;
    rct.origin.y = containerFrame.origin.y;
    
    for(int i = 0; i < iAssetsPerRow; i++)
    {
        BBRiefViewColumn *briefViewColumn = [[BBRiefViewColumn alloc] initWithFrame:TIMELINE_SELECT_RECT];
        briefViewColumn.frame = rct;
        briefViewColumn.column = i;
        [briefViewColumn addObserver:self forKeyPath:kTIMELINE_SELECTED options:NSKeyValueObservingOptionNew context:NULL];
        briefViewColumn.delegate = self;
        [self addSubview:briefViewColumn];
        [self.arrayViews addObject:briefViewColumn];
        rct.origin.x = rct.origin.x + rct.size.width + TIMELINE_VIEW_PADDING;
    }
}

- (void)stopObserving
{
    for (BBRiefViewColumn *briefViewColumn in self.arrayViews) {
        [briefViewColumn removeObserver:self forKeyPath:kTIMELINE_SELECTED context:NULL];
        //[briefViewColumn removeFromSuperview];
    }
}

- (void)setCellSmartObjectsArray:(NSArray *)cellBriefViewsArray
{
    NSAssert(cellBriefViewsArray.count <= self.arrayViews.count, @"error");
    int iIndex = 0;
    for(SmartObject *smartobject in cellBriefViewsArray)
    {
        BBRiefViewColumn *briefViewColumn = (BBRiefViewColumn *)[self.arrayViews objectAtIndex:iIndex];
        [briefViewColumn setSmarbObjet:smartobject];
        briefViewColumn.hidden = NO;
        iIndex ++;
    }
    for (int i =iIndex; i < self.arrayViews.count; i++) {
        BBRiefViewColumn *briefViewColumn = (BBRiefViewColumn *)[self.arrayViews objectAtIndex:i];
        briefViewColumn.hidden = YES;
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([object isMemberOfClass:[BBRiefViewColumn class]])
    {
        BBRiefViewColumn *column = (BBRiefViewColumn *)object;
        if (self.cellStyle == e_Cell_Brief) {
            if([self.delegate respondsToSelector:@selector(briefsTableViewCell:didSelectAsset:atColumn:)])
            {
                [self.delegate briefsTableViewCell:self didSelectAsset:YES atColumn:column.column];
            }
        }
        else if(self.cellStyle == e_Cell_Guide)
        {
            if([self.delegate respondsToSelector:@selector(briefsGuideTableViewCell:didSelectAsset:atColumn:)])
            {
                [self.delegate briefsGuideTableViewCell:self didSelectAsset:YES atColumn:column.column];
            }
        }
        
    }
}

@end



@implementation BBRiefViewColumn
@synthesize column = _column;
@synthesize selected = _selected;
@synthesize smarbObjet = _smarbObjet;
//@synthesize cHotColor;
//@synthesize arrayColor;



- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor clearColor]];
        //[self setBackgroundColor:[UIColor colorWithRed:197.0/255.0 green:144.0/255.0 blue:192.0/255.0 alpha:1.0]];
        //        self.layer.cornerRadius=3;
        //self.clipsToBounds = YES;
        //        [self.layer setShadowColor:[UIColor grayColor].CGColor];
        //        [self.layer setShadowOffset:CGSizeMake(3, 3)];
        //        [self.layer setShadowOpacity: 0.7];
        //        [self.layer setShadowRadius: 3.0];
        //        [self.layer setShadowPath:[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 137-4, 155-4)].CGPath];
        
        UIImageView *bgImgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_bg"]];
        CGRect bgRct = bgImgview.bounds;
        bgRct.origin.x -= 2;
        bgRct.origin.y -= 2.3;
        bgRct.size.width += 1;
        bgRct.size.height += 3;
        [bgImgview setFrame:bgRct];
        [self addSubview:bgImgview];
        _bgImageView = bgImgview;
        
        _fSpace = 6;
        _fCmtWidth = TIMELINE_SELECT_RECT.size.width - _fSpace * 2;
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TIMELINE_SELECT_RECT.size.width, TIMELINE_IMAGE_HEIGHT)];
        _imgView.clipsToBounds  = YES;
        [_imgView setContentMode:UIViewContentModeTop];
        [self addSubview:_imgView];
        
        UIFont *font = [UIFont boldSystemFontOfSize:11 * fScr_Scale];
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(_fSpace, 0, _fCmtWidth, 20 * fScr_Scale)];
        [_lblTitle setTextColor:[UIColor colorWithRed:35.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0]];
        [_lblTitle setBackgroundColor:[UIColor clearColor]];
        [_lblTitle setFont:[UIFont fontWithName:NSLocalizedString(@"Title font", nil) size:12]];
        [_lblTitle setTextAlignment:NSTextAlignmentLeft];
        [_lblTitle setLineBreakMode:NSLineBreakByTruncatingTail];
        [_lblTitle setNumberOfLines:2];
        [self addSubview:_lblTitle];
        
        //font = [UIFont systemFontOfSize:10];
        _lblBrief = [[UILabel alloc] initWithFrame:CGRectMake(_fSpace + 4, 0, _fCmtWidth, 76)];
        [_lblBrief setTextColor:[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0]];
        [_lblBrief setBackgroundColor:[UIColor clearColor]];
        //[_lblBrief setFont:font];
        [_lblBrief setFont: [UIFont fontWithName:NSLocalizedString(@"Abstract font", nil) size:10 * fScr_Scale]];
        [_lblBrief setTextAlignment:NSTextAlignmentLeft];
        [_lblBrief setLineBreakMode:NSLineBreakByTruncatingTail];
        [_lblBrief setNumberOfLines:0];
        [self addSubview:_lblBrief];
        
        float fLeft = TIMELINE_SELECT_RECT.size.width - _fSpace;
        fLeft -= 25;
        font = [UIFont systemFontOfSize:10 * fScr_Scale];
        _lblReadCount = [[UILabel alloc] initWithFrame:CGRectMake(fLeft - _fSpace - 10, TIMELINE_SELECT_RECT.size.height - 15, 40, 14 * fScr_Scale)];
        [_lblReadCount setBackgroundColor:[UIColor clearColor]];
        [_lblReadCount setTextColor:[UIColor clearColor]];
        [_lblReadCount setTextAlignment:NSTextAlignmentRight];
        [_lblReadCount setFont:[UIFont fontWithName:@"Libian SC" size:12 * fScr_Scale]];
        [self addSubview:_lblReadCount];
        
        fLeft -= 19;
        _imgViewReadCount = [[UIImageView alloc] initWithFrame:CGRectMake(fLeft, TIMELINE_SELECT_RECT.size.height - 15, 19, 14)];
        _imgViewReadCount.alpha = 0.5;
        [self addSubview:_imgViewReadCount];
        
        _lblDate = [[UILabel alloc] initWithFrame:CGRectMake(_fSpace, _lblReadCount.frame.origin.y- 10, _fCmtWidth, 10 * fScr_Scale)];
        [_lblDate setBackgroundColor:[UIColor clearColor]];
        [_lblDate setTextColor:[UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:1.0]];
        [_lblDate setFont:font];
        [self addSubview:_lblDate];
        
        _confictView = [[UIImageView alloc] initWithFrame:CGRectMake(_fSpace + _fCmtWidth, _lblDate.frame.origin.y, 4, 10)];
        [_confictView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_confictView];
        _confictView.hidden = YES;
        
        _shareView = [[UIView alloc] initWithFrame:CGRectMake(_fSpace, _imgViewReadCount.frame.origin.y, _fCmtWidth - 30, 12)];
        [self addSubview:_shareView];
        
        _imgViewUploading = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_uploading.png"]];
        [_imgViewUploading setFrame:CGRectMake(TIMELINE_SELECT_RECT.size.width - 13, 4, 10, 10)];
        _imgViewUploading.hidden = YES;
        [self addSubview:_imgViewUploading];
        
        UITapGestureRecognizer *tapGst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTapAction:)];
        [self addGestureRecognizer:tapGst];
    }
    return self;
}



//- (void)setBrief:(BBrief *)bbrief
//{
//    if(ISEMPTY(bbrief.brief_img_path)) //文章简介
//    {
//        float fTop = 12;
//        [_imgView setImage:nil];
//        _lblBrief.hidden = NO;
//        CGRect rct = _lblBrief.frame;
//        rct.origin.y = fTop;
//        [_lblBrief setFrame:rct];
//        _lblBrief.text = bbrief.brief;
//        
//        fTop = _imgView.frame.size.height;
//        fTop += 2;
//        
//        rct = _lblTitle.frame;
//        rct.origin.y = fTop;
//        [_lblTitle setFrame:rct];
//        
//    }
//    else
//    {
//        _lblBrief.hidden = YES;
//        NSString *strPath = [DataModel getUserFolderPath];
//        strPath = [strPath stringByAppendingPathComponent:bbrief.key];
//        NSString *strImgPath = bbrief.brief_img_path;
//        
//        if(strImgPath)
//        {
//            strPath = [strPath stringByAppendingPathComponent:strImgPath];
//            NSData *data = [NSData dataWithContentsOfFile:strPath];
//            CGFloat scale = 1.0;
//            if([[UIScreen mainScreen]respondsToSelector:@selector(scale)])
//            {
//                CGFloat tmp = [[UIScreen mainScreen] scale];
//                if (tmp > 1.5)
//                {
//                    scale = 2.0;
//                }
//            }
//            UIImage *img = [UIImage imageWithData:data scale:scale];
//            if(img)
//            {
//                [_imgView setImage:img];
//            }
//            else
//            {
//                _lblBrief.hidden = NO;
//                [_imgView setImage:nil];
//            }
//            
//        }
//        
//        float fTop = _imgView.frame.size.height + 2;
//        CGRect rct = _lblTitle.frame;
//        rct.origin.y = fTop;
//        
//        fTop += rct.size.height;
//        [_lblTitle setFrame:rct];
//        
//    }
//    if([bbrief.is_uploaded boolValue])
//    {
//        [self hideUploadingAnimation];
//    }
//    else
//    {
//        // Vlog(@"%@", bbrief.debugDescription);
//        [self showUploadingAnimation];
//    }
//    
//    
//    _lblTitle.text = bbrief.title;
//    _lblDate.text = [bbrief.create_date qzGetDate];
//    //Vlog(@"%@,  %@, date %@, conflict type %@", bbrief.modify_date, bbrief.brief, _lblDate.text, bbrief.confilct_type);
//    if([bbrief.confilct_type intValue] == 0)
//    {
//        _confictView.hidden = YES;
//    }
//    else  if([bbrief.confilct_type intValue] >= 2)
//    {
//        _confictView.hidden = NO;
//        [_confictView setImage:[UIImage imageNamed:@"timeline_cnflct_red.png"]];
//        CGRect rct = _confictView.frame;
//        CGSize size = [_lblDate.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(_fCmtWidth, 10)];
//        rct.origin.x = _lblDate.frame.origin.x + size.width + 5;
//        _confictView.frame = rct;
//        
//    }
//    else
//    {
//        _confictView.hidden = NO;
//        [_confictView setImage:[UIImage imageNamed:@"timeline_cnflct_green.png"]];
//        CGRect rct = _confictView.frame;
//        CGSize size = [_lblDate.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(_fCmtWidth, 10)];
//        rct.origin.x = _lblDate.frame.origin.x + size.width + 5;
//        _confictView.frame = rct;
//    }
//    [_shareView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    long long int iShare = [bbrief.note.share_type longLongValue];
//    if(iShare > 0)
//    {
//        NSArray *array = @[@"s_sina.png", @"s_weixin.png", @"s_weixinfriend.png", @"s_evernote.png", @"s_dupan.png", @"s_facebook.png", @"s_twitter.png"];
//        int i = 0;
//        int iWidth = 11;
//        for (int iType = 0; iType < 7; iType++) {
//            if ((iShare >> iType) & 1) {
//                UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[array objectAtIndex:iType]]];
//                [imgview setFrame:CGRectMake(i * (iWidth + 2), 2, iWidth, iWidth)];
//                [_shareView addSubview:imgview];
//                i++;
//            }
//        }
//    }
//    
//    [_imgView setBackgroundColor:[bbrief.color getColorFromString]];
//    [self refreshReadCount:[bbrief.read_count integerValue]];
//}


- (void)refreshReadCount:(int)iCount
{
    // 根据点击量设定标示
    //    NSString *strEye = [NSString stringWithFormat:@"%@", @"timeline_eye"];
    //    if(iCount == 0){
    //        strEye = [strEye stringByAppendingString:@"_5.png"];  // 灰色
    //    }
    //    else if(iCount < 10){
    //        strEye = [strEye stringByAppendingString:@"_4.png"];  // 蓝色
    //    }
    //    else if(iCount < 30){
    //        strEye = [strEye stringByAppendingString:@"_3.png"];  // 青色
    //    }
    //    else if(iCount < 100){
    //        strEye = [strEye stringByAppendingString:@"_2.png"];  // 绿色
    //    }
    //    else if(iCount < 300){
    //        strEye = [strEye stringByAppendingString:@"_1.png"];  // 橙色
    //    }
    //    else if(iCount < 1000){
    //        strEye = [strEye stringByAppendingString:@"_0.png"];  // 红色
    //    }
    //    else{
    //        strEye = [strEye stringByAppendingString:@"_6.png"];  // 紫色
    //    }
    //    [_imgViewReadCount setImage:[UIImage imageNamed:strEye]];
    
    UIColor *color;
    if(iCount == 0){
        color = [UIColor clearColor];
    }
    else if(iCount < 10){
        color = [UIColor colorWithRed:58.0/255.0 green:118.0/255.0 blue:204.0/255.0 alpha:1.0];  // 蓝色
    }
    else if(iCount < 30){
        color = [UIColor colorWithRed:45.0/255.0 green:178.0/255.0 blue:174.0/255.0 alpha:1.0];  // 青色
    }
    else if(iCount < 100){
        color = [UIColor colorWithRed:47.0/255.0 green:172.0/255.0 blue:63.0/255.0 alpha:1.0];  // 绿色
    }
    else if(iCount < 300){
        color = [UIColor colorWithRed:240.0/255.0 green:144.0/255.0 blue:86.0/255.0 alpha:1.0];   // 橙色
    }
    else if(iCount < 1000){
        color = [UIColor colorWithRed:225.0/255.0 green:86.0/255.0 blue:86.0/255.0 alpha:1.0];    // 红色
    }
    else{
        color = [UIColor colorWithRed:159.0/255.0 green:73.0/255.0 blue:178.0/255.0 alpha:1.0];  // 紫色
    }
    _lblReadCount.textColor = color;
    
    
    // 调整点击量的显示格式
    if(iCount < 1000){
        _lblReadCount.text = [NSString stringWithFormat:@"%d", iCount];
    }
    else if(iCount >= 1000 && iCount < 1000*1000){
        _lblReadCount.text = [NSString stringWithFormat:@"%.1f k", iCount/1000.0];
        if(iCount > 10*10000){
            _lblReadCount.text = [NSString stringWithFormat:@"%.1f w", iCount/(10*1000.0)];
        }
    }
    else{
        _lblReadCount.text = [NSString stringWithFormat:@"%.1f m", iCount/(1000.0*1000.0)];
    }
    
    
}

#pragma mark setter/getter

- (void)setSelected:(BOOL)selected
{
    if(_selected != selected)
    {
        //kvo compliant notifications
        [self willChangeValueForKey:kTIMELINE_SELECTED];
        _selected = selected;
        [self didChangeValueForKey:kTIMELINE_SELECTED];
    }
    [self setNeedsDisplay];
}

#pragma mark event

- (void)userDidTapAction:(UITapGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        self.selected = !self.selected;
    }
}

@end