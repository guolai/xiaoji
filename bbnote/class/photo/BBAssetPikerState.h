//
//  BBAssetPikerState.h
//  M6s
//
//  Created by zhuhb on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

//photo

typedef enum
{
    BBAssetPikerStateInitializing,
    BBAssetPikerStatePikingAlbum,
    BBAssetPikerStatePikingAssets,
    BBAssetPikerStatePikingDone,
    BBAssetPikerStatePikingDoneSmart,
    BBAssetPikerStatePikingCancelled
} BBAssetPikingState;

typedef enum {
    BBAssetPikerMask,
    BBAssetPikerFilter,
    BBAssetMulSelectPhoto
} BBAssetPikerType;


@interface BBAssetPikerState : NSObject
@property (nonatomic, readwrite) BBAssetPikingState state;
@property (nonatomic, readwrite) BBAssetPikerType type;
@property (nonatomic, strong) NSString *strValue;

@end
