//
//  CoreTextViewController.m
//  jyy
//
//  Created by bob on 3/6/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "CoreTextViewController.h"
#import "FTCoreTextView.h"

@interface CoreTextViewController ()<FTCoreTextViewDelegate>

@end

@implementation CoreTextViewController
@synthesize scrollView;
@synthesize coreTextView;
@synthesize strContent;

- (void)loadView
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view  = bgview;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ygkz_bg"]]];
    
    float viewHeight = self.height;
    
    float fWidth = 120;
    float fBtmHeight = 60;
    float fTop = 0;
    float fWSpace = (self.width - fWidth * 2) / 3;
    float fHeight = 40;
    if(OS_VERSION < 7.0)
    {
        viewHeight -= self.navBarHeight;
        viewHeight -= 20;
    }
    else
    {
        fTop = 0;
        viewHeight -= fTop;
    }
    CGRect rct = CGRectMake(0, fTop, self.width, viewHeight);
    self.scrollView = [[UIScrollView alloc] initWithFrame:rct];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleWidth;
    
    self.coreTextView = [[FTCoreTextView alloc] initWithFrame:CGRectInset(rct, 10.0f, 0)];
	self.coreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    

    
    //  If you want to get notified about users taps on the links,
    //  implement FTCoreTextView's delegate methods
    //  See example implementation below
    self.coreTextView.delegate = self;
    
    [self.scrollView addSubview:self.coreTextView];
    [self.coreTextView setBackgroundColor:[UIColor clearColor]];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.scrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  Add custom styles to the FTCoreTextView
    [self.coreTextView addStyles:[self coreTextStyle]];
    
    //  Set the custom-formatted text to the FTCoreTextView
    self.coreTextView.text = self.strContent;
    [self.coreTextView fitToSuggestedHeight];
    
    //  Adjust the scroll view's content size so it can scroll all
    //  the FTCoreTextView's content
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.bounds), CGRectGetMaxY(self.coreTextView.frame)+20.0f)];
}




#pragma mark Styling

- (NSArray *)coreTextStyle
{
    NSMutableArray *result = [NSMutableArray array];
    
    //  This will be default style of the text not closed in any tag
	FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
	defaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
	defaultStyle.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:16.f];
	defaultStyle.textAlignment = FTCoreTextAlignementJustified;
	[result addObject:defaultStyle];
	
    //  Create style using convenience method
	FTCoreTextStyle *titleStyle = [FTCoreTextStyle styleWithName:@"title"];
	titleStyle.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:40.f];
	titleStyle.paragraphInset = UIEdgeInsetsMake(20.f, 0, 25.f, 0);
	titleStyle.textAlignment = FTCoreTextAlignementCenter;
	[result addObject:titleStyle];
	
    //  Image will be centered
	FTCoreTextStyle *imageStyle = [FTCoreTextStyle new];
	imageStyle.name = FTCoreTextTagImage;
	imageStyle.textAlignment = FTCoreTextAlignementCenter;
	[result addObject:imageStyle];
	
	FTCoreTextStyle *firstLetterStyle = [FTCoreTextStyle new];
	firstLetterStyle.name = @"firstLetter";
	firstLetterStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:30.f];
	[result addObject:firstLetterStyle];
	
    //  This is the link style
    //  Notice that you can make copy of FTCoreTextStyle
    //  and just change any required properties
	FTCoreTextStyle *linkStyle = [defaultStyle copy];
	linkStyle.name = FTCoreTextTagLink;
	linkStyle.color = [UIColor orangeColor];
	[result addObject:linkStyle];
	
	FTCoreTextStyle *subtitleStyle = [FTCoreTextStyle styleWithName:@"subtitle"];
	subtitleStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:25.f];
	subtitleStyle.color = [UIColor brownColor];
	subtitleStyle.paragraphInset = UIEdgeInsetsMake(10, 0, 10, 0);
	[result addObject:subtitleStyle];
	
    //  This will be list of items
    //  You can specify custom style for a bullet
	FTCoreTextStyle *bulletStyle = [defaultStyle copy];
	bulletStyle.name = FTCoreTextTagBullet;
	bulletStyle.bulletFont = [UIFont fontWithName:@"TimesNewRomanPSMT" size:16.f];
	bulletStyle.bulletColor = [UIColor orangeColor];
	bulletStyle.bulletCharacter = @"❧";
	bulletStyle.paragraphInset = UIEdgeInsetsMake(0, 20.f, 0, 0);
	[result addObject:bulletStyle];
    
    FTCoreTextStyle *italicStyle = [defaultStyle copy];
	italicStyle.name = @"italic";
	italicStyle.underlined = YES;
    italicStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:16.f];
	[result addObject:italicStyle];
    
    FTCoreTextStyle *boldStyle = [defaultStyle copy];
	boldStyle.name = @"bold";
    boldStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:16.f];
	[result addObject:boldStyle];
    
    FTCoreTextStyle *coloredStyle = [defaultStyle copy];
    [coloredStyle setName:@"colored"];
    [coloredStyle setColor:[UIColor redColor]];
	[result addObject:coloredStyle];
    
    return  result;
}

#pragma mark FTCoreTextViewDelegate

- (void)coreTextView:(FTCoreTextView *)acoreTextView receivedTouchOnData:(NSDictionary *)data
{
    //  You can get detailed info about the touched links
    
    //  Name (type) of selected tag
    NSString *tagName = [data objectForKey:FTCoreTextDataName];
    
    //  URL if the touched data was link
    NSURL *url = [data objectForKey:FTCoreTextDataURL];
    
    //  Frame of the touched element
    //  Notice that frame is returned as a string returned by NSStringFromCGRect function
    CGRect touchedFrame = CGRectFromString([data objectForKey:FTCoreTextDataFrame]);
    
    //  You can get detailed CoreText information
    NSDictionary *coreTextAttributes = [data objectForKey:FTCoreTextDataAttributes];
    
    NSLog(@"Received touched on element:\n"
          @"Tag name: %@\n"
          @"URL: %@\n"
          @"Frame: %@\n"
          @"CoreText attributes: %@",
          tagName, url, NSStringFromCGRect(touchedFrame), coreTextAttributes
          );
}


@end
