//
//  BBTableDelegate.h
//  bbnote
//
//  Created by bob on 10/18/15.
//  Copyright © 2015 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBAssetWrapper.h"


@protocol BBPaperListDelegate <NSObject>

- (void)bbPhotoTableViewDidClick:(PaperItem *)object;

@end


@interface BBTableDelegate : NSObject<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *arrayData;
@property (nonatomic, weak) id<BBPaperListDelegate> delegate;

- (void)removeAllConnection;

@end
