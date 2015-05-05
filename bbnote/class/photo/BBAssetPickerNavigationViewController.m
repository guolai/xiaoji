//
//  BBAssetPickerNavigationViewController.m
//  Zine
//
//  Created by bob on 10/9/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import "BBAssetPickerNavigationViewController.h"
#import "BBAssetPickerNavigationViewController.h"
#import "BBAssetPikerState.h"
#import "BBAlbumTableViewController.h"


@interface BBAssetPickerNavigationViewController ()
{
    
}
@property (nonatomic, retain) BBAssetPikerState *assetPickerState;
@property (nonatomic, assign)id<BBPresentViewControlerDelegate> presentDelagate;
@end

@implementation BBAssetPickerNavigationViewController


@synthesize assetPickerState = _assetPickerState;
@synthesize type = _type;
@synthesize strNotePath = _strNotePath;


-(void)dealloc
{
    BBDEALLOC();
    self.assetPickerState = nil;
    self.presentDelagate = nil;

}

- (id)initWithDelegate:(id<BBPresentViewControlerDelegate>)delegate
{
    BBAlbumTableViewController *vc = [[BBAlbumTableViewController alloc]init];
    vc.assetPickerState = self.assetPickerState;
    if(self = [super initWithRootViewController:vc])
    {
        self.presentDelagate = delegate;
    }
    return self;
}

- (id)initWithForSmartCardViewDelegate:(id<BBPresentViewControlerDelegate>)delegate
{
//    SmartCardViewController  *vc = [[SmartCardViewController alloc]init];
//    vc.assetPickerState = self.assetPickerState;
//    if(self = [super initWithRootViewController:vc])
//    {
//        self.presentDelagate = delegate;
//    }
    return self;
}

- (BBAssetPikerState *)assetPickerState
{
    if(!_assetPickerState)
    {
        _assetPickerState = [[BBAssetPikerState alloc] init];
    }
    return _assetPickerState;
}

- (void)setType:(BBAssetPikerType)type
{
    if(_type != type)
    {
        self.assetPickerState.type = type;
        _type = type;
    }
}

- (void)setStrNotePath:(NSString *)strNotePath
{
    if(_strNotePath != strNotePath)
    {
        self.assetPickerState.strValue = strNotePath;
        _strNotePath = strNotePath;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_assetPickerState addObserver:self forKeyPath:kPHOTO_STATE_KEY options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_assetPickerState removeObserver:self forKeyPath:kPHOTO_STATE_KEY];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(![object isEqual:self.assetPickerState])
        return;
    if([kPHOTO_STATE_KEY isEqualToString:keyPath])
    {
 
        if(BBAssetPikerStatePikingCancelled == self.assetPickerState.state)
        {
            if(self.presentDelagate && [self.presentDelagate respondsToSelector:@selector(presentViewCtrDidCancel:)])
            {
                [self.presentDelagate presentViewCtrDidCancel:nil];
            }
        }
        else if(BBAssetPikerStatePikingDone == self.assetPickerState.state)
        {
            if(self.presentDelagate && [self.presentDelagate respondsToSelector:@selector(presentViewCtrDidFinish:)])
            {
                [self.presentDelagate presentViewCtrDidFinish:self];
            }
        }
        else if(BBAssetPikerStatePikingDoneSmart == self.assetPickerState.state)
        {
            if(self.presentDelagate && [self.presentDelagate respondsToSelector:@selector(presentViewCtrDidFinishWithObject:)])
            {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: self.assetPickerState.strValue, @"filename", @"smartcard", @"type", nil];
                [self.presentDelagate presentViewCtrDidFinishWithObject:dic];
            }
        }
    }
}

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return self.topViewController.supportedInterfaceOrientations;
//}
//
//- (BOOL)shouldAutorotate
//{
//    return self.topViewController.shouldAutorotate;
//}
@end
