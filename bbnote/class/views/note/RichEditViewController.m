//
//  RichEditViewController.m
//  bbnote
//
//  Created by bob on 10/6/15.
//  Copyright © 2015 bob. All rights reserved.
//

#import "RichEditViewController.h"

@interface RichEditViewController ()<DTRichTextEditorViewDelegate, DTAttributedTextContentViewDelegate>
@property (nonatomic, strong) DTRichTextEditorView *richEditor;

@end

@implementation RichEditViewController

- (void)dealloc
{
    _richEditor.textDelegate = nil;
    _richEditor.editorViewDelegate = nil;
    _richEditor = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _richEditor = [[DTRichTextEditorView alloc] initWithFrame:self.view.bounds];
    _richEditor.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _richEditor.textDelegate = self;
    
    [self.view addSubview:_richEditor];
    
    
    
    _richEditor.baseURL = [NSURL URLWithString:@"http://www.drobnik.com"];
    _richEditor.textDelegate = self;
    _richEditor.defaultFontFamily = @"Helvetica";
    _richEditor.textSizeMultiplier = 1.0;
    _richEditor.maxImageDisplaySize = CGSizeMake(300, 300);
    _richEditor.autocorrectionType = UITextAutocorrectionTypeYes;
    _richEditor.editable = YES;
    _richEditor.editorViewDelegate = self;
    _richEditor.defaultFontSize = 14;
    
    
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:DTDefaultLinkDecoration];
    [defaults setObject:[UIColor redColor] forKey:DTDefaultLinkColor];
    
//    NSLog(@"%@", [DTCSSStylesheet defaultStyleSheet]);
    
    // demonstrate half em paragraph spacing
    //    DTCSSStylesheet *styleSheet = [[DTCSSStylesheet alloc] initWithStyleBlock:@"p {margin-bottom:0.5em} ol {margin-bottom:0.5em} li {margin-bottom:0.5em}"];
    //    [defaults setObject:styleSheet forKey:DTDefaultStyleSheet];
    //
    //    _richEditor.textDefaults = defaults;
    _richEditor.attributedTextContentView.shouldDrawImages = NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    [_richEditor setHTMLString:html];
    [_richEditor becomeFirstResponder];
    //    [DTCoreTextLayoutFrame setShouldDrawDebugFrames:YES];

}

#pragma mark - DTRichTextEditorViewDelegate

- (BOOL)editorViewShouldBeginEditing:(DTRichTextEditorView *)editorView
{
    NSLog(@"editorViewShouldBeginEditing:");
    return YES;
}

- (void)editorViewDidBeginEditing:(DTRichTextEditorView *)editorView
{
    NSLog(@"editorViewDidBeginEditing:");
}

- (BOOL)editorViewShouldEndEditing:(DTRichTextEditorView *)editorView
{
    NSLog(@"editorViewShouldEndEditing:");
    return NO;
}

- (void)editorViewDidEndEditing:(DTRichTextEditorView *)editorView
{
    NSLog(@"editorViewDidEndEditing:");
}

- (BOOL)editorView:(DTRichTextEditorView *)editorView shouldChangeTextInRange:(NSRange)range replacementText:(NSAttributedString *)text
{
    NSLog(@"editorView:shouldChangeTextInRange:replacementText:");
    
    return YES;
}

- (void)editorViewDidChangeSelection:(DTRichTextEditorView *)editorView
{
    NSLog(@"editorViewDidChangeSelection:");
    
}

- (void)editorViewDidChange:(DTRichTextEditorView *)editorView
{
    NSLog(@"editorViewDidChange:");
}

- (BOOL)editorView:(DTRichTextEditorView *)editorView canPerformAction:(SEL)action withSender:(id)sender
{
    DTTextRange *selectedTextRange = (DTTextRange *)editorView.selectedTextRange;
    BOOL hasSelection = ![selectedTextRange isEmpty];
    
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
