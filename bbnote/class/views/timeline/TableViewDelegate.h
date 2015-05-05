//
//  TableViewDelegate.h
//  bbnote
//
//  Created by Apple on 13-4-30.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  enum {
    e_Tableview_Home = 0,
    e_Tableview_Max = 1
}BBTableType;

@interface TableViewDelegate : NSObject<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
{
    BBTableType type_;
    float fHeader_;
}
@property (nonatomic, retain) NSMutableArray *arrayDataList;
@property (nonatomic, assign) NSInteger numberOfSections;

- (id) initWithType:(BBTableType)eType;
@end
