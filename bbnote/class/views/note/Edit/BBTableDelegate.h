//
//  BBTableDelegate.h
//  bbnote
//
//  Created by bob on 10/18/15.
//  Copyright © 2015 bob. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BBPaperListDelegate <NSObject>

- (void)qmPhotoTableViewDidClick:(PhotoItem *)object;

@end


@interface BBTableDelegate : NSObject<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *arrayData;
@property (nonatomic, strong) NSString *strTitle;
@property (nonatomic, weak) id<QMSharePhotoListDelegate> delegate;

- (void)removeAllConnection;

@end
