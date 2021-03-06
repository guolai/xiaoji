//
//  RichEditViewController.m
//  bbnote
//
//  Created by bob on 10/6/15.
//  Copyright © 2015 bob. All rights reserved.
//

#import "RichEditViewController.h"
#import "EditHeadView.h"
#import "EditAccessoryView.h"
#import "MediaSelectView.h"
#import "StyleSelect.h"
#import "AnimationHelper.h"
#import "BBAssetPickerNavigationViewController.h"
#import "BBMisc.h"
#import "BB_BBContent.h"
#import "FileManagerController.h"
#import "BRecord.h"
#import "BContent.h"
#import "NSDate+String.h"
#import "NSString+Help.h"
#import "BBUserDefault.h"
#import "BBSkin.h"
#import "BB_BBImage.h"
#import "NSDate+String.h"
#import "DataModel.h"
#import "BBNavigationViewController.h"
#import "DataManager.h"
#import "MobClick.h"
#import "UIView+Image.h"
#import "NSString+UIColor.h"
#import "UIImage+SCaleImage.h"
#import "PaperListView.h"
#import "BBTableDelegate.h"
#import "NSString+Help.h"
#import "NSMutableDictionary+SafeSet.h"
#import "BLine.h"
#import "BB_BBLine.h"


@interface RichEditViewController ()<DTRichTextEditorViewDelegate, DTAttributedTextContentViewDelegate,KeyBoardStateDelegate, MediaSelectDelegate, BBPresentViewControlerDelegate, BBPaperListDelegate>
{
    float _keyboardHeight;
    CGRect _priKbRct;
    UITextRange *_lastSelection;
}
@property (nonatomic, strong)DTRichTextEditorView *richEditor;
@property (nonatomic, strong)EditAccessoryView *accessoryView;
@property (nonatomic, strong)StyleSelectView *styleSlctView;
@property (nonatomic, strong)MediaSelectView *mediaSlectView;
@property (nonatomic, strong)PaperListView *paperListView;
@property (nonatomic, weak) UIView *keyBoardView;
@property (nonatomic, weak) id<BBPresentViewControlerDelegate> presentDelegate;

@property (nonatomic, retain)BRecord *bRecord;
@property (nonatomic, retain)BContent *bContent;
@property (nonatomic, strong)BStyle *lastStyle;
@property (nonatomic, strong)NSMutableArray *imgArray;
@property (nonatomic, strong)BB_BBRecord *bbRecored;
@property (nonatomic, strong)NSMutableDictionary *imgDic;
@property (nonatomic, retain)NSTimer *saveTimer;
@end

@implementation RichEditViewController

- (void)dealloc
{
    _richEditor.textDelegate = nil;
    _richEditor.editorViewDelegate = nil;
    _richEditor = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    if (self.isViewLoaded && !self.view.window)
    {
        BBINFO(@"%@", [self.view window]);
        [self keyboardDown];
        _richEditor.textDelegate = nil;
        _richEditor.editorViewDelegate = nil;
        _richEditor = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [_accessoryView removeFromSuperview];
        _accessoryView = nil;
        [_mediaSlectView removeFromSuperview];
        _mediaSlectView = nil;
        [_styleSlctView removeFromSuperview];
        _styleSlctView = nil;
        [_paperListView removeFromSuperview];
        _paperListView = nil;
    }
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithRecored:(BB_BBRecord *)recored
{
    if (self = [super init])
    {
        self.bbRecored = recored;
        self.bRecord = [[BRecord alloc] initWithBBrecord:recored];
        self.bContent = [[BContent alloc] initWithBBText:recored.contentInRecord];
        self.imgArray = [NSMutableArray arrayWithCapacity:10];
        NSArray *array = [self.bbRecored.imageInRecord allObjects];
        for (BB_BBImage *bbimg in array)
        {
            BImage *bime = [[BImage alloc] initWithBBImage:bbimg];
            [self.imgArray addObject:bime];
        }
        self.imgDic = [NSMutableDictionary dictionaryWithCapacity:10];
        
    }
    return self;
}

- (instancetype)initWithNewNote
{
    if (self = [super init])
    {
        [self createNewRecord];
        [BBUserDefault deleteArchvierDataNote];
        self.imgDic = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _richEditor = [[DTRichTextEditorView alloc] initWithFrame:self.view.bounds];
    _richEditor.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _richEditor.textDelegate = self;
    
    [self.view addSubview:_richEditor];
    
    
    NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
    _richEditor.baseURL = [NSURL URLWithString:kSinaAppRedirectURI];
    _richEditor.textDelegate = self;
    _richEditor.defaultFontFamily = noteset.strFontName;
    _richEditor.textSizeMultiplier = 1.0;
    _richEditor.maxImageDisplaySize = CGSizeMake(300, 300);
    _richEditor.autocorrectionType = UITextAutocorrectionTypeYes;
    _richEditor.editable = YES;
    _richEditor.editorViewDelegate = self;
    _richEditor.defaultFontSize = [noteset.nFontSize floatValue];
    
    [self resetNoteSetting];
    [self resetBackGroundColor];
    _richEditor.attributedTextContentView.shouldDrawImages = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (self.bContent.arrayLine.count > 0)
    {
        _richEditor.attributedString  = [self geneAttributedString:self.bContent.arrayLine];
    }
    else
    {
        NSLog(@"===========22223344=====");
        [_richEditor setHTMLString:html];
    }
    
    [_richEditor becomeFirstResponder];
    //    [DTCoreTextLayoutFrame setShouldDrawDebugFrames:YES];
    
    self.mediaSlectView.hidden = YES;
    self.styleSlctView.hidden = YES;
    [self initAccesssoryView];
    
    [self showBackButton:nil action:@selector(backBtnPressed)];
    [self showRigthButton:NSLocalizedString(@"Submit", nil) withImage:nil highlightImge:nil andEvent:@selector(submitRecored)];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.saveTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(saveRecordToSandbox) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.saveTimer invalidate];
    self.saveTimer = nil;
}

- (EditAccessoryView *)accessoryView
{
    if(!_accessoryView)
    {
        [self initAccesssoryView];
    }
    return _accessoryView;
}

- (void)initAccesssoryView
{
    CGRect rct = [BBMisc getScreenAboveRectForm:CGRectMake(0, 0, SCR_WIDTH, 44)];
    _accessoryView = [[EditAccessoryView alloc] initWithFrame:rct];
    _accessoryView.btndelegate = self;
    //    _accessoryView.layer.masksToBounds = NO;
    //    _accessoryView.layer.shadowOffset = CGSizeMake(0, 0);
    //    _accessoryView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    _accessoryView.layer.shadowOpacity = .6;
    //    _accessoryView.layer.shadowRadius = 1.0f;
    _accessoryView.alpha = 0.97;
    [self.view addSubview:_accessoryView];
    _accessoryView.hidden = NO;
}


- (StyleSelectView *)styleSlctView
{
    if(!_styleSlctView)
    {
        float styleViewH = [BBAutoSize resizeWidth:240];
    
        _styleSlctView = [[StyleSelectView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, styleViewH)];
        _styleSlctView.frame = [BBMisc getScreenBlowRectForm:_styleSlctView.frame];
        //_styleSlctView.kbDelegate = self;
        //    _styleSlctView.layer.masksToBounds = NO;
        //    _styleSlctView.layer.shadowOffset = CGSizeMake(0, 0);
        //    _styleSlctView.layer.shadowColor = [UIColor blackColor].CGColor;
        //    _styleSlctView.layer.shadowOpacity = .6;
        //    _styleSlctView.layer.shadowRadius = 1.0f;
        _styleSlctView.styleDelegate = self;
        _styleSlctView.alpha = 0.97;
        [self.view addSubview:_styleSlctView];
        _styleSlctView.hidden = YES;
    }
    return _styleSlctView;
}

- (MediaSelectView *)mediaSlectView
{
    if(!_mediaSlectView)
    {
        float mediaViewH = [BBAutoSize resizeWidth:240];
      
        _mediaSlectView = [[MediaSelectView alloc]  initWithFrame:CGRectMake(0, 0, SCR_WIDTH, mediaViewH)];
        _mediaSlectView.frame = [BBMisc getScreenBlowRectForm:_mediaSlectView.frame];
        [_mediaSlectView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:245.0/255.0 blue:244.0/255.0 alpha:1]];
        _mediaSlectView.alpha = 0.97;
        _mediaSlectView.delegate = self;
        [self.view addSubview:_mediaSlectView];
        _mediaSlectView.hidden = YES;
    }
    return _mediaSlectView;
}

- (PaperListView *)paperListView
{
    if(!_paperListView)
    {
        float mediaViewH = [BBAutoSize resizeWidth:240];
        _paperListView = [[PaperListView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, mediaViewH)];
        _paperListView.frame = [BBMisc getScreenBlowRectForm:_paperListView.frame];
        [_paperListView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:245.0/255.0 blue:244.0/255.0 alpha:1]];
        _paperListView.alpha = 0.97;
        _paperListView.delegate = self;
        [self.view addSubview:_paperListView];
        _paperListView.hidden = YES;
    }
    return _paperListView;
}

#pragma mark － set

- (void)resetBackGroundColor
{
    NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
    if(noteset.isUseBgImg)
    {
        UIImage *img = [UIImage imageNamed:noteset.strBgImg];
        if ([noteset.strBgImg hasPrefix:@"skin"])
        {
            img  = [img imageAutoScaleToScreen];
        }
        if(img)
        {
            UIColor *color = [UIColor colorWithPatternImage:img];
            _richEditor.attributedTextContentView.backgroundColor = color;
            [_richEditor setBackgroundColor:color];
//            [self reDrawView:_richEditor.attributedTextContentView];
//            [self reDrawView:_richEditor];
          
        }
    }
    else
    {
        _richEditor.attributedTextContentView.backgroundColor = DTColorCreateWithHTMLName(noteset.strBgColor);
        [_richEditor setBackgroundColor:DTColorCreateWithHTMLName(noteset.strBgColor)];
//        [self reDrawView:_richEditor.attributedTextContentView];
//        [self reDrawView:_richEditor];
    }
}

- (void)reDrawView:(UIView *)view
{
    [view setNeedsDisplay];
    if ([view respondsToSelector:@selector(invalidateIntrinsicContentSize)])
    {
        [view invalidateIntrinsicContentSize];
    }
}

- (void)resetNoteSetting
{
     NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:DTDefaultLinkDecoration];
    [defaults setObject:[UIColor blueColor] forKey:DTDefaultLinkColor];
    [defaults setObject:noteset.strFontName forKey:DTDefaultFontFamily];
//    [defaults setObject:noteset.strFontName forKey:DTDefaultFontName];
    [defaults setObject:noteset.nFontSize forKey:DTDefaultFontSize];
    [defaults setObject:noteset.strBgColor forKey:DTBackgroundColorAttribute];
    [defaults setObject:noteset.strTextColor forKey:DTDefaultTextColor];
    _richEditor.textDefaults = defaults;
 
}

#pragma mark - data

- (void)createNewRecord
{
    NSDictionary *noteDic = [BBUserDefault getArchiverDataOfNote];
    if(noteDic)
    {
        self.bRecord =[NSKeyedUnarchiver unarchiveObjectWithData:[noteDic objectForKey:@"record"]];
        if(!self.bRecord)
        {
            self.bRecord = [[BRecord alloc]init];
        }
        self.bContent = [NSKeyedUnarchiver unarchiveObjectWithData:[noteDic objectForKey:@"content"]];
        if(!self.bContent)
        {
            self.bContent = [[BContent alloc] init];
        }
        self.imgArray = [NSKeyedUnarchiver unarchiveObjectWithData:[noteDic objectForKey:@"image"]];
        if(!self.imgArray || ![self.imgArray isKindOfClass:[NSMutableArray class]])
        {
            self.imgArray = [[NSMutableArray alloc] initWithCapacity:8];
        }
    }
    else
    {
        self.bRecord = [[BRecord alloc] init];
        self.bContent = [[BContent alloc] init];
        self.imgArray = [NSMutableArray arrayWithCapacity:10];
    }
    NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
    if(noteset.isUseBgImg)
    {
        self.bRecord.bg_image = noteset.strBgImg;
        self.bRecord.bg_color = noteset.strBgColor;
    }
    else
    {
        self.bRecord.bg_image = nil;
        self.bRecord.bg_color = noteset.strBgColor;
    }
}

- (void)saveRecordToSandbox
{
    if(self.bRecord)
    {
        [self parseAttributedString:_richEditor.attributedText];
        
        NSMutableDictionary *noteDic = [NSMutableDictionary dictionaryWithCapacity:4];
        [noteDic setObject:[NSKeyedArchiver archivedDataWithRootObject:self.bContent] forKey:@"content"];
        [noteDic setObject:[NSKeyedArchiver archivedDataWithRootObject:self.bRecord] forKey:@"record"];
        if(self.imgArray.count > 0)
            [noteDic setObject:[NSKeyedArchiver archivedDataWithRootObject:self.imgArray] forKey:@"image"];
        [BBUserDefault setArchvierData:noteDic];
        BBINFO(@"%@", [BBUserDefault getArchiverDataOfNote]);
    }
}

- (void)saveNoteData
{
    [self parseAttributedString:_richEditor.attributedText];
    if (!self.bbRecored)
    {
        self.bbRecored = [BB_BBRecord initWithBRecord:self.bRecord];
        BB_BBText *bbcontent = [BB_BBText BBContentWithBContent:self.bContent];
        bbcontent.record = self.bbRecored;
        self.bbRecored.contentInRecord = bbcontent;
    }
    else
    {
        [self.bbRecored.contentInRecord updateWithBContent:self.bContent];
    }
    for (int i = 0; i < self.imgArray.count; i++)
    {
        BImage *bime = [self.imgArray objectAtIndex:i];
        if ([self.imgDic objectForKey:bime.data_path])
        {
            BB_BBImage *bbime = [BB_BBImage BBImageWithBImage:bime];
            bbime.record = self.bbRecored;
        }
        else
        {
            BB_BBImage *bbimage = nil;
            NSArray *array = [BB_BBImage whereFormat:@"key == '%@'", bime.key];
            if(array && array.count > 0)
            {
                bbimage = array.first;
            }
            if(bbimage)
            {
                [bbimage delete];
            }
            if (bime.data_path && bime.data_path.length > 0)
            {
                NSString *strPath = [[self getNotePath] stringByAppendingPathComponent:bime.data_path];
                if ([FileManagerController fileExist:strPath])
                {
                    [FileManagerController removeFile:strPath];
                }
                
            }
            
        }
    }
    BBINFO(@"%@", [self getNotePath]);
    [self.bbRecored save];
    
}


- (NSString *)getNotePath
{
    return [DataModel getNotePath:self.bRecord];
}


#pragma mark - event


- (NSAttributedString *)geneAttributedString:(NSArray*)array
{
    NSMutableAttributedString *mulAttributeString = [[NSMutableAttributedString alloc] init];
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)      {
        NSComparisonResult result = NSOrderedSame;
        BLine *line1 = (BLine *)obj1;
        BLine *line2 = (BLine *)obj2;
        if (line1.line > line2.line)
        {
            result = NSOrderedDescending;
        }
        else if (line1.line == line2.line)
        {
            if (line1.run > line2.run)
            {
                result = NSOrderedDescending;
            }
            else if (line1.run < line2.run)
            {
                result = NSOrderedAscending;
            }
        }
        else
        {
            result = NSOrderedAscending;
        }
        return result;
    }];
    
    for (int i = 0; i < sortedArray.count; i++)
    {
        BLine *line = [sortedArray objectAtIndex:i];
        [mulAttributeString appendAttributedString:[line geneAttributedStringFromDir:[self getNotePath]]];
    }
    
    return mulAttributeString;
}

- (NSArray *)parseAttributedString:(NSAttributedString *)attributedString
{
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:10];
    NSString *plainString = [attributedString string];
    self.bContent.text = plainString;
    NSArray *paragraphs = [plainString componentsSeparatedByString:@"\n"];
    NSInteger location = 0;
    [self.imgDic removeAllObjects];
    for (NSUInteger i=0; i<[paragraphs count]; i++)
    {
        NSString *oneParagraph = [paragraphs objectAtIndex:i];
        NSRange paragraphRange = NSMakeRange(location, [oneParagraph length]);
        
        // skip empty paragraph at the end
   
        if (!paragraphRange.length)
        {
            BLine *bline = [[BLine alloc] init];
            bline.line = i;
            bline.run = 0;
            [retArray addObject:bline];
            continue;
        }
        
        __block NSUInteger runNum = 0;
        NSAttributedString *subAttributedString = [attributedString attributedSubstringFromRange:paragraphRange];
        [subAttributedString enumerateAttributesInRange:NSMakeRange(0, subAttributedString.length) options:nil usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            NSDictionary *dic = attrs;
            BStyle *style = [DataModel getStyleFromDiction:dic];
            BLine *bline = [[BLine alloc] init];
            bline.forcolor = style.strColor;
            bline.bgcolor = style.strBgColor;
            bline.fontsize = style.strSize;
            bline.fontname = style.strFontName;
            bline.location = range.location;
            bline.length = range.length;
            bline.line = i;
            bline.run = runNum;
            bline.text = [oneParagraph substringSafeWithRange:range];
            DTImageTextAttachment *imgAttachment = [dic objectForKey:NSAttachmentAttributeName];
            if (imgAttachment && [imgAttachment isKindOfClass:[DTImageTextAttachment class]])
            {
                bline.fileName = imgAttachment.strFileName;
                bline.displaySize = imgAttachment.displaySize;
                bline.orgiSize = imgAttachment.originalSize;
                [self.imgDic setObject:imgAttachment.strFileName forKey:imgAttachment.strFileName];
                BBINFO(@"%@", imgAttachment);
            }
            [retArray addObject:bline];
            NSLog(@"%@--%@--%@--%d",[oneParagraph substringSafeWithRange:range], dic, NSStringFromRange(range), *stop);
            runNum ++;
            
        }];
        
        location = location + paragraphRange.length + 1;
    }
    [self.bContent.arrayLine removeAllObjects];
    self.bContent.arrayLine = retArray;
    return retArray;
}

- (void)submitRecored
{
    [self.saveTimer invalidate];
    [BBUserDefault setHomeViewIndex:-1];
    [self showProgressHUD];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *imge = [_richEditor.attributedTextContentView translateToImage];
        UIImageWriteToSavedPhotosAlbum(imge, nil, nil, nil);
        [self saveNoteData];
        [BBUserDefault deleteArchvierDataNote];
        [self dismissProgressHUD];
        [self.navigationController popViewControllerAnimated:YES];
    });
 

}

- (void)backBtnPressed
{
    [self.saveTimer invalidate];
    [BBUserDefault setHomeViewIndex:-1];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self saveNoteData];
        [BBUserDefault deleteArchvierDataNote];
        [self.navigationController popViewControllerAnimated:YES];
    });

}

- (void)keyboardDown
{
    _richEditor.editable = NO;
    _richEditor.bShouldOpenEdit = YES;
    [_richEditor resignFirstResponder];
}

- (void)keyboardUp
{
    _richEditor.editable = YES;
    [_richEditor becomeFirstResponder];
}


#pragma mark - keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification {
    BBINFO(@"keyboardWillShow");

    if (OS_VERSION < 8.0)
    {
        [self replaceAccessoryBar];
    }
    else
    {
        [self hideAccessoryBar];
    }
    
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *number = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];

    
    CGRect endRect = CGRectMake(self.keyBoardView.frame.origin.x, self.keyBoardView.frame.origin.y - _accessoryView.frame.size.height, _accessoryView.bounds.size.width, _accessoryView.bounds.size.height);
    CGPoint fromPoint = [BBMisc getCurrentPointFrom:_accessoryView.frame];
    CGPoint toPoint = [BBMisc getCurrentPointFrom:endRect];
    BBINFO(@"%@", NSStringFromCGRect(self.keyBoardView.frame));
    if(self.accessoryView.slctState == e_KBSlct_Max)
    {
        _accessoryView.slctState = e_KBSlct_Keyboard;
        [_accessoryView setDefaultKeyBoardBtnStauts];
        self.keyBoardView.hidden = NO;
        _accessoryView.frame = CGRectMake(0, SCR_HEIGHT_P, _accessoryView.bounds.size.width, _accessoryView.bounds.size.height);
        [UIView animateWithDuration:[number floatValue] animations:^{
            _accessoryView.frame = endRect;
        }];
    }
    else if(_accessoryView.slctState == e_KBSlct_Keyboard)
    {
        self.keyBoardView.hidden = NO;
        _accessoryView.frame = endRect;
    }
    else if(_accessoryView.slctState == e_KBSlct_Style)
    {
        self.keyBoardView.hidden = YES;
        [self showStyleSelectViewWithAnimation:YES duration:[number floatValue]];
        CGRect rct = [BBMisc getScreenAboveRectForm:_styleSlctView.frame];
        toPoint.y = rct.origin.y - _accessoryView.frame.size.height / 2;
        CAAnimationGroup *animationGroup = [AnimationHelper showInputAccessoryBarFromPoint:fromPoint toPoint:toPoint duration:[number floatValue]];
        [_accessoryView.layer addAnimation:animationGroup forKey:@"show"];
        rct.size.height = _accessoryView.frame.size.height;
        rct.origin.y = rct.origin.y - _accessoryView.frame.size.height;
        _accessoryView.frame = rct;
    }
    else if(_accessoryView.slctState == e_KBSlct_Media)
    {
        self.keyBoardView.hidden = YES;
        [self  showMeidaWithAnimation:YES duration:[number floatValue]];
        CGRect rct = [BBMisc getScreenAboveRectForm:_mediaSlectView.frame];
        toPoint.y = rct.origin.y - _accessoryView.frame.size.height / 2;
        CAAnimationGroup *animationGroup = [AnimationHelper showInputAccessoryBarFromPoint:fromPoint toPoint:toPoint duration:[number floatValue]];
        [_accessoryView.layer addAnimation:animationGroup forKey:@"show"];
        rct.size.height = _accessoryView.frame.size.height;
        rct.origin.y = rct.origin.y - _accessoryView.frame.size.height;
        _accessoryView.frame = rct;
    }
    else if (_accessoryView.slctState == e_KBSlct_Paper)
    {
        self.keyBoardView.hidden = YES;
        [self  showPaperWithAnimation:YES duration:[number floatValue]];
        CGRect rct = [BBMisc getScreenAboveRectForm:_paperListView.frame];
        toPoint.y = rct.origin.y - _accessoryView.frame.size.height / 2;
        CAAnimationGroup *animationGroup = [AnimationHelper showInputAccessoryBarFromPoint:fromPoint toPoint:toPoint duration:[number floatValue]];
        [_accessoryView.layer addAnimation:animationGroup forKey:@"show"];
        rct.size.height = _accessoryView.frame.size.height;
        rct.origin.y = rct.origin.y - _accessoryView.frame.size.height;
        _accessoryView.frame = rct;
    }
    else
    {
        NSAssert(false, @"keyboardWillShow type is undefined");
    }
    
    
    //解决iOS8.3键盘隐藏后，还会响应事件的问题
    self.keyBoardView.userInteractionEnabled = !self.keyBoardView.hidden;
}

- (void)keyboardDidShow:(NSNotification *)notification {
    BBINFO(@"keyboardDidShow");
    
    // 在此记录键盘的高度
    NSDictionary* userInfoDict = [notification userInfo];
    CGRect KBRect = [[userInfoDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeight = KBRect.size.height;
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    BBINFO(@"keyboardWillHide");

    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *number = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect endRect = [aValue CGRectValue];
    endRect = [self.view convertRect:endRect fromView:nil];
    

    
    CGRect accessoryRct = _accessoryView.frame;
    accessoryRct.origin.y = SCR_HEIGHT_P;
    [UIView beginAnimations:@"hideAccessoryView" context:NULL];
    [UIView setAnimationDuration:[number floatValue]];
    [UIView setAnimationCurve:animationCurve];
    _accessoryView.frame = accessoryRct;
    [UIView commitAnimations];
    
    if(_accessoryView.slctState == e_KBSlct_Keyboard)
    {
        
    }
    else if(_accessoryView.slctState == e_KBSlct_Style)
    {
        if(self.styleSlctView.hidden)
            return;
        CGRect rct = [BBMisc getScreenBlowRectForm:_styleSlctView.frame];
        [UIView animateWithDuration:[number floatValue] animations:^{
            _styleSlctView.frame = rct;
        } completion:^(BOOL finished) {
            _styleSlctView.hidden = YES;
        }];
        
    }
    else if(_accessoryView.slctState == e_KBSlct_Media)
    {
        if(self.mediaSlectView.hidden)
            return;
        CGRect rct = [BBMisc getScreenBlowRectForm:_mediaSlectView.frame];
        [UIView animateWithDuration:[number floatValue] animations:^{
            _mediaSlectView.frame = rct;
        } completion:^(BOOL finished) {
            _mediaSlectView.hidden = YES;
        }];
        
    }
    else if(_accessoryView.slctState == e_KBSlct_Paper)
    {
        if(self.paperListView.hidden)
            return;
        CGRect rct = [BBMisc getScreenBlowRectForm:_paperListView.frame];
        [UIView animateWithDuration:[number floatValue] animations:^{
            _paperListView.frame = rct;
        } completion:^(BOOL finished) {
            _paperListView.hidden = YES;
        }];
        
    }
    else
    {
        
    }

    [_accessoryView resetKeyBoardBtnstatus];
}

- (void)replaceAccessoryBar {
    // Locate non-UIWindow.
    UIWindow *keyboardWindow = nil;
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![[window class] isEqual:[UIWindow class]])
        {
            keyboardWindow = window;
            break;
        }
    }
    
    // Locate UIWebFormView.
    for (UIView *keyboardSubView in [keyboardWindow subviews])
    {
        BBINFO(@"%@", keyboardSubView.debugDescription);
        if ([[keyboardSubView description] rangeOfString:@"<UIPeripheralHostView"].location != NSNotFound)
        {
            self.keyBoardView = keyboardSubView;
            _priKbRct = self.keyBoardView.frame;
            
            for (UIView *subView in [keyboardSubView subviews])
            {
                //BBINFO(@"%@", subView.debugDescription);
                
                if ([[subView description] rangeOfString:@"UIWebFormAccessory"].location != NSNotFound ||
                    /*[[subView description] rangeOfString:@"UIKBInputBackdropView"].location != NSNotFound ||*/
                    [[subView description] rangeOfString:@"UIImageView"].location != NSNotFound)
                {
                    [subView removeFromSuperview];
                }
                else if([[subView description] rangeOfString:@"UIKBInputBackdropView"].location != NSNotFound )
                {
                    if(subView.frame.size.height < 90)
                    {
                        [subView removeFromSuperview];
                    }
                }
                else if([[subView description] rangeOfString:@"UIKeyboardAutomatic"].location != NSNotFound )
                {
                    
                }
            }
        }
    }
}

- (void)hideAccessoryBar
{
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![[window class] isEqual:[UIWindow class]]) {
            [self findKeyBoardFrameFormWindow:window];
        }
    }
    
}

- (void)findKeyBoardFrameFormWindow:(UIWindow *)keyboardWindow
{
    BOOL isKeyBoard = NO;
    if (OS_VERSION >= 9.0)
    {
        if (![keyboardWindow.description rangeOfString:@"UIRemoteKeyboardWindow"].location != NSNotFound)
        {
            isKeyBoard = YES;
        }
    }
    else
    {
        isKeyBoard = YES;
    }
    for (UIView *keyboardSubView in [keyboardWindow subviews])
    {
        if ([[keyboardSubView description] rangeOfString:@"UIInputSetContainerView"].location != NSNotFound)
        {
            for (UIView *subView in [keyboardSubView subviews])
            {
                if ([[subView description] rangeOfString:@"UIInputSetHostView"].location != NSNotFound)
                {
                    if(isKeyBoard)
                    {
                        self.keyBoardView = subView;
                        _priKbRct = self.keyBoardView.frame;
                    }
                    
                    for (UIView *view in [subView subviews])
                    {
                        if ([[view description] rangeOfString:@"UIWebFormAccessory"].location != NSNotFound ||
                            [[view description] rangeOfString:@"UIImageView"].location != NSNotFound)
                        {
                            view.userInteractionEnabled = NO;
                            view.hidden = YES;
                        }
                        else if([[view description] rangeOfString:@"UIKBInputBackdropView"].location != NSNotFound)
                        {
                            if(view.frame.size.height < 90)
                            {
                                view.userInteractionEnabled = NO;
                                view.hidden = YES;
                            }
                        }
                        else if([[view description] rangeOfString:@"UIRemoteKeyboardPlaceholderView"].location != NSNotFound)
                        {
                            view.userInteractionEnabled = NO;
                            view.hidden = YES;
                        }
                    }
                }
                else
                {
                    BBINFO(@"%@", subView.description);
                }
            }
        }
    }
}


#pragma mark - EditAccessoryViewToolbarDelegate
- (void)accessoryToolbarSelected:(UIButton*)sender type:(T_KeyBoard_Btn)type {
    
    switch (type)
    {
        case e_KB_Media:
        {
            if(self.accessoryView.slctState == e_KBSlct_Media)
            {
                [self keyboardDown];
                return;
            }
            if (self.accessoryView.slctState == e_KBSlct_Max)
            {
                return;
            }
            if(self.accessoryView.slctState == e_KBSlct_Keyboard)
            {
                [self hideKeyBoardWithAnimation:YES duration:-1];
                [self showMeidaWithAnimation:NO  duration:-1];
            }
            else if(self.accessoryView.slctState == e_KBSlct_Style)
            {
                [self hideStyleSelectViewWithAnimation:YES duration:-1];
                [self showMeidaWithAnimation:NO duration:-1];
            }
            else if (self.accessoryView.slctState == e_KBSlct_Paper)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.paperListView.alpha = 0.3;
                } completion:^(BOOL finished) {
                    _paperListView.alpha = 1.0;
                    [self hidePaperWithAnimation:NO duration:-1];
                }];
                [self showMeidaWithAnimation:NO duration:-1];
            }
            else
            {
                NSAssert(false, @"error");
            }
            
            [UIView animateWithDuration:0.1 animations:^{
                [self.accessoryView setFrameNextToView:self.mediaSlectView];
            } completion:^(BOOL finished) {
            }];
            self.accessoryView.slctState = e_KBSlct_Media;
        }
            break;
        case e_KB_Paper:
        {
            if(self.accessoryView.slctState == e_KB_Paper)
            {
                [self keyboardDown];
                return;
            }
            if (self.accessoryView.slctState == e_KBSlct_Max)
            {
                return;
            }
            if(self.accessoryView.slctState == e_KBSlct_Keyboard)
            {
                [self hideKeyBoardWithAnimation:YES duration:-1];
                [self showPaperWithAnimation:NO  duration:-1];
            }
            else if(self.accessoryView.slctState == e_KBSlct_Style)
            {
                [self hideStyleSelectViewWithAnimation:YES duration:-1];
                [self showPaperWithAnimation:NO duration:-1];
            }
            else if (self.accessoryView.slctState == e_KBSlct_Media)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.mediaSlectView.alpha = 0.3;
                } completion:^(BOOL finished) {
                    _mediaSlectView.alpha = 1.0;
                    [self hideMeidaWithAnimation:NO duration:-1];
                }];
                [self showPaperWithAnimation:NO duration:-1];
            }
            else
            {
                NSAssert(false, @"error");
            }
            
            [UIView animateWithDuration:0.1 animations:^{
                [self.accessoryView setFrameNextToView:self.paperListView];
            } completion:^(BOOL finished) {
            }];
            self.accessoryView.slctState = e_KBSlct_Paper;
        }
            break;
        case e_KB_Style:
        {
            if(self.accessoryView.slctState == e_KBSlct_Style)
            {
                [self keyboardDown];
                return;
            }
            if(self.accessoryView.slctState == e_KBSlct_Max)
            {
                return;
            }
            else if(self.accessoryView.slctState == e_KBSlct_Keyboard)
            {
                [self hideKeyBoardWithAnimation:YES duration:0.1];
                [self showStyleSelectViewWithAnimation:NO  duration:-1];
                
            }
            else if (self.accessoryView.slctState == e_KBSlct_Media)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.mediaSlectView.alpha = 0.3;
                } completion:^(BOOL finished) {
                    _mediaSlectView.alpha = 1.0;
                    [self hideMeidaWithAnimation:NO duration:-1];
                }];
                [self showStyleSelectViewWithAnimation:YES  duration:0.1];
            }
            else if (self.accessoryView.slctState == e_KBSlct_Paper)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.paperListView.alpha = 0.3;
                } completion:^(BOOL finished) {
                    _paperListView.alpha = 1.0;
                    [self hidePaperWithAnimation:NO duration:-1];
                }];
                [self showStyleSelectViewWithAnimation:YES  duration:0.1];
            }
            else
            {
                NSAssert(false, @"error");
            }
            
//            if(self.styleDic)
//            {
//                [self.styleSlctView setCurrentStyles:self.styleDic];
//            }
            [UIView animateWithDuration:0.3 animations:^{
                [self.accessoryView setFrameNextToView:self.styleSlctView];
            } completion:^(BOOL finished) {
            }];
            self.accessoryView.slctState = e_KBSlct_Style;
        }
            break;
            
        case e_KB_KeyBoard:
        {
            if(self.accessoryView.slctState == e_KBSlct_Keyboard)
            {
                [self keyboardDown];
                return;
            }
            if(self.accessoryView.slctState == e_KBSlct_Max)
            {
                [self keyboardUp];
                return;
            }
            
            if(self.accessoryView.slctState == e_KBSlct_Style)
            {
                [UIView animateWithDuration:0.25 animations:^{
                    self.styleSlctView.alpha = 0.3;
                } completion:^(BOOL finished) {
                    self.styleSlctView.alpha = 1.0;
                    [self hideStyleSelectViewWithAnimation:NO duration:-1];
                }];
                
            }
            else if(self.accessoryView.slctState == e_KBSlct_Media)
            {
                [UIView animateWithDuration:0.25 animations:^{
                    self.mediaSlectView.alpha = 0.3;
                } completion:^(BOOL finished) {
                    self.mediaSlectView.alpha = 1.0;
                    [self hideMeidaWithAnimation:NO duration:-1];
                }];
            }
            else if (self.accessoryView.slctState == e_KBSlct_Paper)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.paperListView.alpha = 0.3;
                } completion:^(BOOL finished) {
                    _paperListView.alpha = 1.0;
                    [self hidePaperWithAnimation:NO duration:-1];
                }];
            }
            else
            {
                NSAssert(false, @"error");
            }
            [self showKeyboardWithAnimation:YES  duration:0.1];
            [UIView animateWithDuration:0.1 animations:^{
                [self.accessoryView setFrameNextToKeyboard:self.keyBoardView];
            }];
            
            self.accessoryView.slctState = e_KBSlct_Keyboard;
        }
            break;
        default:
            break;
    }
}

- (void)showMeidaWithAnimation:(BOOL)animation  duration:(float)fDura
{
    if(!self.mediaSlectView.hidden)
    {
        return;
    }
    if(fDura < 0)
        fDura = 0.25;
    self.mediaSlectView.hidden = NO;
    if (animation) {
        CGPoint fromPnt = [BBMisc getScreenBlowPointFrom:_mediaSlectView.frame];
        CGPoint toPnt = [BBMisc getScreenAbovePointFrom:_mediaSlectView.frame];
        CAAnimationGroup *animationGroup = [AnimationHelper showInputAccessoryBarFromPoint:fromPnt toPoint:toPnt duration:fDura];
        [_mediaSlectView.layer addAnimation:animationGroup forKey:@"show"];
    }
    CGRect rct = [BBMisc getScreenAboveRectForm:_mediaSlectView.frame];
    _mediaSlectView.frame = rct;
}

- (void)hideMeidaWithAnimation:(BOOL)animtation  duration:(float)fDura
{
    if(self.mediaSlectView.hidden)
        return;
    if(fDura < 0)
        fDura = 0.25;
    //    if(animtation)
    //    {
    //        CGPoint fromPnt = [BBMisc getCurrentPointFrom:_mediaSlectView.frame];
    //        CGPoint toPnt = [BBMisc getScreenBlowPointFrom:_mediaSlectView.frame];
    //        CAAnimationGroup *animationGroup = [AnimationHelper dimissInputAccessoryBarFromPoint:fromPnt toPoint:toPnt duration:fDura];
    //        [_mediaSlectView.layer addAnimation:animationGroup forKey:@"xunfeihide"];
    //    }
    if(animtation)
    {
        [UIView animateWithDuration:0.25 animations:^{
            _mediaSlectView.frame = [BBMisc getScreenBlowRectForm:_mediaSlectView.frame];
        } completion:^(BOOL finished) {
            _mediaSlectView.hidden = YES;
        }];
    }
    else
    {
        _mediaSlectView.frame = [BBMisc getScreenBlowRectForm:_mediaSlectView.frame];
        _mediaSlectView.hidden = YES;
    }
    
}

- (void)showPaperWithAnimation:(BOOL)animation  duration:(float)fDura
{
    if(!self.paperListView.hidden)
    {
        return;
    }
    if(fDura < 0)
        fDura = 0.25;
    self.paperListView.hidden = NO;
    if (animation) {
        CGPoint fromPnt = [BBMisc getScreenBlowPointFrom:_paperListView.frame];
        CGPoint toPnt = [BBMisc getScreenAbovePointFrom:_paperListView.frame];
        CAAnimationGroup *animationGroup = [AnimationHelper showInputAccessoryBarFromPoint:fromPnt toPoint:toPnt duration:fDura];
        [_paperListView.layer addAnimation:animationGroup forKey:@"show"];
    }
    CGRect rct = [BBMisc getScreenAboveRectForm:_paperListView.frame];
    _paperListView.frame = rct;
}

- (void)hidePaperWithAnimation:(BOOL)animtation  duration:(float)fDura
{
    if(self.paperListView.hidden)
        return;
    if(fDura < 0)
        fDura = 0.25;
    //    if(animtation)
    //    {
    //        CGPoint fromPnt = [BBMisc getCurrentPointFrom:_mediaSlectView.frame];
    //        CGPoint toPnt = [BBMisc getScreenBlowPointFrom:_mediaSlectView.frame];
    //        CAAnimationGroup *animationGroup = [AnimationHelper dimissInputAccessoryBarFromPoint:fromPnt toPoint:toPnt duration:fDura];
    //        [_mediaSlectView.layer addAnimation:animationGroup forKey:@"xunfeihide"];
    //    }
    if(animtation)
    {
        [UIView animateWithDuration:0.25 animations:^{
            _paperListView.frame = [BBMisc getScreenBlowRectForm:_paperListView.frame];
        } completion:^(BOOL finished) {
            _paperListView.hidden = YES;
        }];
    }
    else
    {
        _paperListView.frame = [BBMisc getScreenBlowRectForm:_paperListView.frame];
        _paperListView.hidden = YES;
    }
    
}


- (void)showKeyboardWithAnimation:(BOOL)animation  duration:(float)fDura
{
    if(!self.keyBoardView.hidden)
    {
        return;
    }
    if(fDura < 0)
        fDura = 0.25;
    self.keyBoardView.hidden = NO;
    if(animation)
    {
        CGPoint fromPnt = [BBMisc getCurrentPointFrom:_priKbRct];
        CGPoint toPnt = [BBMisc getScreenAbovePointFrom:_priKbRct];
        CAAnimationGroup *animationGroup = [AnimationHelper showInputAccessoryBarFromPoint:fromPnt toPoint:toPnt duration:fDura];
        [self.keyBoardView.layer addAnimation:animationGroup forKey:@"show"];
    }
    self.keyBoardView.frame = _priKbRct;
    
    //解决iOS8.3键盘隐藏后，还会响应事件的问题
    self.keyBoardView.userInteractionEnabled = YES;
}

- (void)hideKeyBoardWithAnimation:(BOOL)animation  duration:(float)fDura
{
    if(fDura < 0)
        fDura = 0.25;
    if(animation)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.keyBoardView.frame = [BBMisc getScreenBlowRectForm:self.keyBoardView.frame];
        } completion:^(BOOL finished) {
            self.keyBoardView.frame = _priKbRct;
            self.keyBoardView.hidden = YES;
        }];
    }
    else
    {
        self.keyBoardView.frame = _priKbRct;
        self.keyBoardView.hidden = YES;
    }
    
    //解决iOS8.3键盘隐藏后，还会响应事件的问题
    self.keyBoardView.userInteractionEnabled = NO;
}

- (void)showStyleSelectViewWithAnimation:(BOOL)animation duration:(float)fDura
{
    if(!self.styleSlctView.hidden)
        return;
    if(fDura < 0)
        fDura = 0.25;
    _styleSlctView.hidden = NO;
    if(animation)
    {
        CGPoint fromPnt = [BBMisc getCurrentPointFrom:_styleSlctView.frame];
        CGPoint toPnt = [BBMisc getScreenAbovePointFrom:_styleSlctView.frame];
        CAAnimationGroup *animationGroup = [AnimationHelper dimissInputAccessoryBarFromPoint:fromPnt toPoint:toPnt duration:fDura];
        [_styleSlctView.layer addAnimation:animationGroup forKey:@"xunfeihide"];
    }
    _styleSlctView.frame = [BBMisc getScreenAboveRectForm:_styleSlctView.frame];
    
}

- (void)hideStyleSelectViewWithAnimation:(BOOL)animation  duration:(float)fDura
{
    if(self.styleSlctView.hidden)
        return;
    if(fDura < 0)
        fDura = 0.25;
    //    if(animation)
    //    {
    //        CGPoint fromPnt = [BBMisc getCurrentPointFrom:_styleSlctView.frame];
    //        CGPoint toPnt = [BBMisc getScreenBlowPointFrom:_styleSlctView.frame];
    //        CAAnimationGroup *animationGroup = [AnimationHelper dimissInputAccessoryBarFromPoint:fromPnt toPoint:toPnt duration:fDura];
    //        [_styleSlctView.layer addAnimation:animationGroup forKey:@"hide"];
    //    }
    //    _styleSlctView.frame = [BBMisc getScreenBlowRectForm:_styleSlctView.frame];
    //    _styleSlctView.hidden = YES;
    if(animation)
    {
        [UIView animateWithDuration:0.25 animations:^{
            _styleSlctView.frame = [BBMisc getScreenBlowRectForm:_styleSlctView.frame];
        } completion:^(BOOL finished) {
            _styleSlctView.hidden = YES;
        }];
    }
    else
    {
        _styleSlctView.frame = [BBMisc getScreenBlowRectForm:_styleSlctView.frame];
        _styleSlctView.hidden = YES;
    }
}




#pragma mark - KeyBoardStateDelegate
- (void)keyboardDidChangeState:(T_KeyBoard_Style_State)state
{
    
}

- (void)keyboardDidSelectStyle:(BStyle *)bstyle
{
    BBINFO(@"%@,%@,%@,%@", bstyle.strFontName, bstyle.strColor, bstyle.strBgColor, bstyle.strSize);
    UITextRange *range = _richEditor.selectedTextRange;
    if([range.start isEqual:range.end])
    {
        BBINFO(@"11111111");
//        UIFont *font = [UIFont fontWithName:bstyle.strFontName size:[bstyle.strSize floatValue]];
//        if(!font || [bstyle.strFontName isEqualToString:kDefatultFont])
//        {
//            font = [UIFont systemFontOfSize:[bstyle.strSize floatValue]];
//        }
//        [_richEditor setFont:font];
//        UIColor *color = [bstyle.strColor getColorFromRGBA];
//        [_richEditor setForegroundColor:color inRange:range];
        NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
        noteset.strTextColor = bstyle.strColor;
        noteset.strFontName = bstyle.strFontName;
        noteset.strBgColor = bstyle.strBgColor;
        noteset.nFontSize = [NSNumber numberWithInteger:[bstyle.strSize floatValue]];
        [self resetNoteSetting];
        UIColor *color = [bstyle.strColor getColorFromCSSString];
        UIColor *bgColor = [bstyle.strBgColor getColorFromCSSString];
        [_richEditor setForegroundColor:color backgroundColor:bgColor inRange:range];
        NSString *strFontName = [DataModel checkFontName:bstyle.strFontName];
        [_richEditor updateFontInRange:range withFontFamilyName:strFontName pointSize:[bstyle.strSize floatValue]];
        self.lastStyle = bstyle;
    }
    else
    {
        BBINFO(@"22222222");
        UIColor *color = [bstyle.strColor getColorFromCSSString];
        UIColor *bgColor = [bstyle.strBgColor getColorFromCSSString];
        [_richEditor setForegroundColor:color backgroundColor:bgColor inRange:range];
        NSString *strFontName = [DataModel checkFontName:bstyle.strFontName];
        [_richEditor updateFontInRange:range withFontFamilyName:strFontName pointSize:[bstyle.strSize floatValue]];
    }
    BBINFO(@"%@", range);
   
}

- (void)keyboardXunFeiInputDidBegin
{
    
}

- (void)keyboardXunFeiInputDidStop
{
    
}

#pragma mark - paperdelegate

- (void)bbPhotoTableViewDidClick:(PaperItem *)object
{
    [self resetBackGroundColor];
}

#pragma mark - MediaSelectDelegate

- (void)mediaSelectDidSelect:(T_Media_Type)iType
{
    _lastSelection = [_richEditor selectedTextRange];
    
    if (!_lastSelection)
    {
        return;
    }
    switch (iType) {
        case e_Media_Photo:
        {
            BBAssetPickerNavigationViewController *pikcerViewController = [[BBAssetPickerNavigationViewController alloc] initWithDelegate:self];
            pikcerViewController.type = BBAssetMulSelectPhoto;
            pikcerViewController.strNotePath = [self getNotePath];
            [self presentViewController:pikcerViewController animated:YES completion:nil];
        }
            break;
        case e_Media_Paper:
        {
        
        }
            break;
   
        default:
            break;
    }
}

#pragma mark --- presentViewcontroller callback delegate
- (void)presentViewCtrDidCancel:(UIViewController *)seder
{
    if(!self.view)
    {
        
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)presentViewCtrDidFinish:(UIViewController *)seder
{
    if(!self.view)
    {
        
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    if(seder && [seder isKindOfClass:[BBAssetPickerNavigationViewController class]])
    {
        NSArray *arrayselectedimg = [BBUserDefault getSavedAblumImage];
  
        if(arrayselectedimg  && arrayselectedimg.count > 0)
        {
            [self showProgressHUD];
            [self.imgArray addObjectsFromArray:arrayselectedimg];
            [self addImageFromIndex:0 array:arrayselectedimg];
        }
        
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)addImageFromIndex:(NSInteger)index array:(NSArray *)array
{
    if(index >= array.count)
    {
        [self dismissProgressHUD];
        return;
    }
    @autoreleasepool
    {
        BImage *bimg = [array objectAtIndex:index];
        UIImage *img = [UIImage imageWithContentsOfFile:[[self getNotePath] stringByAppendingPathComponent:bimg.data_path]];
        //                img  = [UIImage imageNamed:@"record00.jpg"];
        [self replaceCurrentSelectionWithPhoto:img fileName:bimg.data_path];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _lastSelection = _richEditor.selectedTextRange;
        [self addImageFromIndex:index + 1 array:array];
    });
}


- (void)replaceCurrentSelectionWithPhoto:(UIImage *)image fileName:(NSString *)strFilename
{
    if (!_lastSelection)
    {
        return;
    }
    BBINFO(@"%@", _lastSelection);
    ScaledBImage *scaleImage = [DataModel scaleImage:image];
    // make an attachment
    DTImageTextAttachment *attachment = [[DTImageTextAttachment alloc] initWithElement:nil options:nil];
    attachment.image = (id)scaleImage.imge;
    attachment.displaySize = scaleImage.displaySize;
    attachment.originalSize = scaleImage.originalSize;
    attachment.strFileName = strFilename;
    
    [_richEditor replaceRange:_lastSelection withAttachment:attachment inParagraph:YES];
}


- (void)presentViewCtrDidFinish:(UIViewController*)sender withObject:(id)object
{
    if(!self.view)
    {
        
    }
    if(object)
    {
        
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark - DTRichTextEditorViewDelegate

- (BOOL)editorViewShouldBeginEditing:(DTRichTextEditorView *)editorView
{
//    BBINFO(@"editorViewShouldBeginEditing:");
    return YES;
}

- (void)editorViewDidBeginEditing:(DTRichTextEditorView *)editorView
{
//    BBINFO(@"editorViewDidBeginEditing:");
}

- (BOOL)editorViewShouldEndEditing:(DTRichTextEditorView *)editorView
{
    BBINFO(@"editorViewShouldEndEditing:");
    return NO;
}

- (void)editorViewDidEndEditing:(DTRichTextEditorView *)editorView
{
    BBINFO(@"editorViewDidEndEditing:");
}

- (BOOL)editorView:(DTRichTextEditorView *)editorView shouldChangeTextInRange:(NSRange)range replacementText:(NSAttributedString *)text
{
    BBINFO(@"editorView:shouldChangeTextInRange:replacementText:");
    
    return YES;
}

- (void)editorViewDidChangeSelection:(DTRichTextEditorView *)editorView
{
    UITextRange *range = editorView.selectedTextRange;
    BStyle *bstyle = self.lastStyle;
    if([range isEmpty] && self.lastStyle)
    {
        
    }
    else
    {
        NSDictionary *dic = [_richEditor getAttributedStringCurrentRange:range];
        bstyle = [DataModel getStyleFromDiction:dic];
    }
    [_styleSlctView setCurrentStyles:bstyle];
//    setCurrentStyles
    BBINFO(@"editorViewDidChangeSelection:");
    
}

- (void)editorViewDidChange:(DTRichTextEditorView *)editorView
{
    BBINFO(@"editorViewDidChange:");
}

- (BOOL)editorView:(DTRichTextEditorView *)editorView canPerformAction:(SEL)action withSender:(id)sender
{
    DTTextRange *selectedTextRange = (DTTextRange *)editorView.selectedTextRange;
    BOOL hasSelection = ![selectedTextRange isEmpty];
//    BBINFO(@"canPerformAction:");
    //    if (action == @selector(insertStar:) || action == @selector(insertWhiteStar:))
    //    {
    //        return _showInsertMenu;
    //    }
    //
    //    if (_showInsertMenu)
    //    {
    //        return NO;
    //    }
    //
    //    if (action == @selector(displayInsertMenu:))
    //    {
    //        return (!hasSelection && _showInsertMenu == NO);
    //    }
    //
    //    // For fun, disable selectAll:
    //    if (action == @selector(selectAll:))
    //    {
    //        return NO;
    //    }
    //    
    return YES;
}


@end
