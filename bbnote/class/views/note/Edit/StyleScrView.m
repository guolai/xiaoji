//
//  StyleScrView.m
//  Zine
//
//  Created by bob on 9/4/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import "StyleScrView.h"
#import "NSString+UIColor.h"


@implementation StyleImageView
@synthesize strStyle;

- (void)dealloc
{
    self.strStyle = nil;
}

- (void)setFontName:(NSString *)strText localName:(NSString *)strLocal
{
    float fW = self.frame.size.width;
    float fH = self.frame.size.height;
    UIFont *font = [UIFont fontWithName:strText size:15*_scale];
    NSString *strRealText = NSLocalizedString(strText, nil);
    if (!ISEMPTY(strLocal))
    {
        strRealText = strLocal;
    }
    if(!font)
    {
        font = [UIFont systemFontOfSize:15*_scale];
    }
    CGSize size = [strRealText sizeWithFont:font constrainedToSize:CGSizeMake(fW, 100) lineBreakMode:NSLineBreakByTruncatingTail];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, (fH - size.height) / 2, fW, size.height)];
    [lbl setFont:font];
    [lbl setText:strRealText];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl  setBackgroundColor:[UIColor clearColor]];
    [self addSubview:lbl];
    
}

- (void)setFontSize:(NSString *)strText
{
    float fW = self.frame.size.width;
    float fH = self.frame.size.height;
    float fSize = 15*_scale;

    UIFont *font = [UIFont systemFontOfSize:fSize];
    fSize += 4;
    CGSize size = [strText sizeWithFont:font constrainedToSize:CGSizeMake(fW, fSize) lineBreakMode:NSLineBreakByTruncatingTail];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, (fH - size.height) / 2, fW, size.height)];
    [lbl setFont:font];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl  setText:[NSString stringWithFormat:@"%d", (int)([strText floatValue])]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl  setBackgroundColor:[UIColor clearColor]];
    [self addSubview:lbl];
}

- (void)setStringColor:(NSString *)strColor
{
    float fW = self.frame.size.width;
    float fH = self.frame.size.height;
    UIColor *fColor = [strColor getColorFromRGBA];

    float colorW = 23*_scale;
    float colorH = 13*_scale;
    UIView *lbl = [[UIView alloc] initWithFrame:CGRectMake((fW - colorW)/2, (fH - colorH)/2, colorW, colorH)];
    [lbl setBackgroundColor:fColor];
    [self addSubview:lbl];
}

- (void)setStyleImg:(NSString *)strName
{
    UIImage* img = [UIImage imageNamed:strName];
    CGSize imgSize = img.size;
    
    float fW = self.frame.size.width;
    float fH = self.frame.size.height;
    CGRect rect = CGRectMake((fW - imgSize.width)/2, (fH - imgSize.height)/2, imgSize.width, imgSize.height);
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:rect];
    imgView.image = img;
    [self addSubview:imgView];
}

@end


@implementation StyleScrView
@synthesize textStyleDelegate;
@synthesize strStyleType;
@synthesize strCurStyle;

- (void)dealloc
{
    AudioServicesDisposeSystemSoundID(_soundID);
    self.strCurStyle = nil;
    self.strStyleType = nil;
}


- (id)initWithFrame:(CGRect)frame array:(NSArray *)array width:(float)fW height:(float)fH type:(T_BaseView)type
{
    
    self = [super initWithFrame:frame];
    if (self) {
  
        [self createSound];
        
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        _type = type;
        _fH = fH;
        _fW = fW;
        _imgStoreArray = [[NSMutableArray alloc] init];
        float fMargin = 1.0;
        _iCount = array.count;
        _bShouldCallDelegate = NO;
        float scale = 1.0;
        if (ISiPhone6Plus || ISiPhone6)
        {
            scale = ((SCR_WIDTH-8)/4.0)/78.0;
        }
        
        if(array.count > 0)
        {
            for ( int i = 0; i < array.count * 5; i++) {
                NSDictionary *dic = [array objectAtIndex:i % array.count];
                StyleImageView *imgView = [[StyleImageView alloc] initWithFrame:CGRectMake(i * _fW + fMargin, (self.frame.size.height - fH) / 2 + fMargin, _fW - fMargin * 2, _fH - fMargin * 2)];
                imgView.scale = scale;
                [imgView setBackgroundColor:[UIColor whiteColor]];
                if (_type == e_BV_Text)
                {
                    [imgView setFontName:[dic objectForKey:@"name"] localName:[dic objectForKey:@"localname"]];
                }
                else if(_type == e_BV_Size)
                {
                    [imgView setFontSize:[dic objectForKey:@"name"]];
                }
                else if(_type == e_BV_Color)
                {
                    [imgView setStringColor:[dic objectForKey:@"name"]];
                }
                
                imgView.strStyle = [dic  objectForKey:@"name"];
                [self addSubview:imgView];
                [_imgStoreArray addObject:imgView];
            }
        }
        self.contentSize = CGSizeMake(_imgStoreArray.count * _fW, self.frame.size.height);
        
        _iVisibleCount = (SCR_WIDTH + _fW / 2) / _fW;
        float fMid = array.count * 2 *_fW;
        [self setContentOffset:CGPointMake(fMid, 0)];
        self.delegate = self;
        [self stopAnimation];
    }
    return self;
}

- (void)setCurrentSelectItem:(NSString *)strItem
{
    _bShouldCallDelegate = NO;
    [self setScrollEnabled:NO];
    float fMid = _iCount * 5 / 2;
    int iIndex = _iCount * 2 + _iCount / 2 - 1;
    BOOL bFind = NO;
    int iMod = ((_iCount % 2 == 0)? 0 : 1);
    for (int i = iIndex; i <= iIndex + _iCount / 2 + iMod; i++) { //先向右边查找，
        StyleImageView *imgView =[_imgStoreArray objectAtIndex:i];
        if([strItem isEqualToString:imgView.strStyle])
        {
            iIndex = i;
            bFind = YES;
            break;
        }
    }
    
    if(!bFind)
    {
        for (int i = iIndex; i > iIndex - _iCount / 2 ; i--) {//向左边查找
            StyleImageView *imgView =[_imgStoreArray objectAtIndex:i];
            if([strItem isEqualToString:imgView.strStyle])
            {
                iIndex = i;
                bFind = YES;
                break;
            }
        }
    }
    
    if(bFind)
    {
        StyleImageView *imgView =[_imgStoreArray objectAtIndex:iIndex];
        fMid = imgView.center.x;
        fMid -= (_fW - 2) / 2;
        [self setContentOffset:CGPointMake(fMid - SCR_WIDTH / 2, 0)];
        [self stopAnimation];
    }
    else
    {
        [self setScrollEnabled:YES];
        NSAssert(false, @"invalid parameters!");
    }
}

- (BOOL)isMoving
{
    //Vlog(@"%d", self.isDecelerating);
    return (_bSnapping || self.isDecelerating);
}

- (void)layoutSubviews
{
    float fSectionSize = _imgStoreArray.count / 5 * _fW;
    
    if (self.contentOffset.x <= (fSectionSize - fSectionSize/2))
    {
        self.contentOffset = CGPointMake(fSectionSize * 2 - fSectionSize/2, 0);
    } else if (self.contentOffset.x >= (fSectionSize * 3 + fSectionSize/2)) {
        self.contentOffset = CGPointMake(fSectionSize * 2 + fSectionSize/2, 0);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _fPriOffset = scrollView.contentOffset.x;
    _bShouldCallDelegate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_bShouldCallDelegate && fabs(scrollView.contentOffset.x - _fPriOffset) > _fW)
    {
        _fPriOffset = scrollView.contentOffset.x;
        [self playSound];
    }
    //Vlog(@"======== %f", scrollView.contentOffset.x);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    if (decelerate == 0 && !_bSnapping) [self stopAnimation];
    //Vlog(@"---------%f, decelerate %d", scrollView.contentOffset.x, decelerate);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!_bSnapping) [self stopAnimation];
}

- (void)stopAnimation
{
    _bSnapping = YES;
    float newX = 0;
    float fCentex = 0;
    float offset = self.contentOffset.x;
    StyleImageView *view = nil;
    if(offset >= 0) //计算中心位置，并保证中间的居中
    {
        offset += (SCR_WIDTH)/2;
        offset -= _fW / 2;
        int iIndex = offset / _fW;
        for (int i = iIndex; i < _imgStoreArray.count;)
        {
            view  = [_imgStoreArray objectAtIndex:i];
            if(view.center.x - offset >= 0)
            {
                if(view.center.x - offset <= _fW)
                {
                    iIndex = i;
                    fCentex = view.center.x;
                    break;
                }
            }
            else
            {
                i++;
            }
        }
    }
    newX = fCentex - offset - _fW / 2;

    newX = self.contentOffset.x  + newX;

    [self setScrollEnabled:NO];
    [self scrollRectToVisible:CGRectMake(newX, 0, self.frame.size.width, 1) animated:YES];
    if(_bShouldCallDelegate && newX > _fW / 4)
        [self playSound];

    [self setScrollEnabled:YES];
    _bSnapping = NO;
    self.strCurStyle = view.strStyle;//先保存样式
    if(_bShouldCallDelegate &&  self.textStyleDelegate && [self.textStyleDelegate respondsToSelector:@selector(textStyleScrollDidStop:type:)])
    {
        [self.textStyleDelegate textStyleScrollDidStop:view.strStyle type:self.strStyleType];
        _bShouldCallDelegate = NO;
    }
  
}

- (void)createSound
{
//    CFBundleRef mainBundle;
//    mainBundle = CFBundleGetMainBundle ();
//    CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle,(CFStringRef)@"set-style", CFSTR("mp3"),NULL);
//    
//    OSStatus err = AudioServicesCreateSystemSoundID((CFURLRef)soundFileURLRef, &_soundID);
//    CFRelease(soundFileURLRef);
//    if (err) {
//        BBINFO(@"Error occurred assigning system sound!");
//    }
}

- (void)playSound
{
//    AudioServicesPlaySystemSound(_soundID);
}

@end
