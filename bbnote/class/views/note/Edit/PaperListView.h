//
//  PaperListView.h
//  bbnote
//
//  Created by bob on 10/18/15.
//  Copyright © 2015 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBPaperListDelegate;

@interface PaperListView : UIView
@property (nonatomic, weak) id<BBPaperListDelegate> delegate;
- (void)removeTableAllConnection;
@end
