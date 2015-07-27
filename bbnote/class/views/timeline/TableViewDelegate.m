//
//  TableViewDelegate.m
//  bbnote
//
//  Created by Apple on 13-4-30.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "TableViewDelegate.h"
#import "Constant.h"
#import "HomeCell.h"
#import "BBRecord.h"
#import "BBContent.h"
#import "UIImage+SCaleImage.h"
#import "FileManagerController.h"
#import "BBMisc.h"
#import "BBSkin.h"
#import "DataModel.h"
#import "BBUserDefault.h"

@implementation TableViewDelegate
@synthesize arrayDataList;
@synthesize numberOfSections;

- (void)dealloc
{
    self.arrayDataList = nil;
}

- (id) initWithType:(BBTableType)eType
{
    if(self = [super init])
    {
        type_ = eType;
        fHeader_ = CELL_TITLE_BG_CELL_HEIGHT;
        self.numberOfSections = 2;
        self.arrayDataList = [[NSMutableArray alloc] initWithCapacity:18];
    }
    return self;
}

#pragma mark ----datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 14 * fScr_Scale;
    }
    if(indexPath.row == 0)
        return fHeader_;
    BBRecord *bbrecord = [self.arrayDataList objectAtIndex:indexPath.row - 1];
    NSArray *arrimages = [DataModel BBimageArrayGetImagelist:[[bbrecord imageInRecord] allObjects]];
  
    BBText *bbcontent = bbrecord.contentInRecord;
    float fTop = CELL_TOP_SPACE;
    if(arrimages.count > 0)
    {
//        BImage *bimage = [arrimages objectAtIndex:0];
//        float fHeight = [bimage.height floatValue];
//        float fWidth = [bimage.width floatValue];
//        float fw = 1.0;
//        float fh = 1.0;
//        fw = CELL_CMT_WIDTH;
//        float fscale = fw / fWidth;
//        fh = fHeight * fscale;
//        if(fh >= CELL_IMAGE_MAX_HEIGHT)
//            fh = CELL_IMAGE_MAX_HEIGHT;
//        fTop += fh;
        fTop += CELL_BIG_IMAGE_HEIGHT;
        fTop += CELL_SML_IMAGE_MARGIN;
    }
    if(arrimages.count > 1)
    {
        fTop += CELL_SML_IMAGE_HEIGHT;
        fTop += CELL_SML_IMAGE_MARGIN;
    }
    if(!bbcontent.text || [bbcontent.text isEqual:[NSNull null]] || [bbcontent.text isEqualToString:@""])
    {

    }
    else
    {
        CGSize size = [bbcontent.text sizeWithFont:[UIFont systemFontOfSize:CELL_CMT_FONT_SIZE] constrainedToSize:CGSizeMake(CELL_CMT_WIDTH, 100 * fScr_Scale) lineBreakMode:NSLineBreakByTruncatingTail];
        fTop += size.height;
        fTop += CELL_SML_IMAGE_MARGIN;
    }
    
    fTop += CELL_OTHER_CMT_HEiGHT;
    fTop += CELL_SML_IMAGE_MARGIN;
    
    fTop += CELL_OTHER_CMT_HEiGHT;
    fTop += CELL_BTM_SPACE;
    if(fTop < CELL_MIN_HEIGHT)
        fTop = CELL_MIN_HEIGHT;
    return fTop;
}



//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    //    CGPoint pnt =  scrollView.contentOffset;
//    //    BBINFO(@"%@", NSStringFromCGPoint(pnt));
//    //    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
//    //    if (bottomEdge >= scrollView.contentSize.height )
//    //        [[NSNotificationCenter defaultCenter] postNotificationName:kTABLEDELEGATE_BEGINDRAGGING object:nil userInfo:nil];
//}

//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:scrollView forKey:@"scrollview"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kTableDelegateEndDraging object:nil userInfo:dic];
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:scrollView forKey:@"scrollview"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kTableDelegateDidScroll object:nil userInfo:dic];
//}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        [[NSNotificationCenter defaultCenter] postNotificationName:kTableDelegateDidSelect object:nil userInfo:[NSDictionary dictionaryWithObject:indexPath forKey:@"indexpath"]];
    
}



#pragma mark ---- delegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView  {
    
    return self.numberOfSections;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return fHeader_;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view_ = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, fHeader_)] autorelease];
//    [view_ setBackgroundColor:[UIColor clearColor]];
//    UIImageView *imgView_ = [[[UIImageView alloc] initWithFrame:CGRectMake(0, -10, SCR_WIDTH, fHeader_ - 10)] autorelease];
//    CALayer *layer1 = [imgView_ layer];
//    
//    layer1.borderColor = [CELLIMAGEBORER_COLOR CGColor];
//    layer1.borderWidth = 2.0f;
//    layer1.shadowColor = CELLIMAGEBORER_COLOR.CGColor;
//    layer1.shadowOffset = CGSizeMake(3, 3);
//    layer1.shadowOpacity = 0.8;
//    layer1.shadowRadius = 5;
//    layer1.cornerRadius = 10;
//    
//    [imgView_ setContentMode:UIViewContentModeCenter];
//    [imgView_ setClipsToBounds:YES];
//    UITapGestureRecognizer *tapGst_ = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureReconnizerPressed)] autorelease];
//    [imgView_ addGestureRecognizer:tapGst_];
//    [imgView_ setUserInteractionEnabled:YES];
//    UIImage *bgimg;
//    NSString *strBgImg = [[FileManagerController documentPath] stringByAppendingPathComponent:[[NSUserDefaults standardUserDefaults] objectForKey:@"notephoto"]];
//    if(![FileManagerController fileExist:strBgImg])
//    {
//        bgimg = [UIImage imageNamed:@"01.jpg"];
//    }
//    else
//    {
//        bgimg = [[UIImage imageWithContentsOfFile:strBgImg] scaleToSize:CGSizeMake(SCR_WIDTH, fHeader_)];
//    }
//    [imgView_ setImage:bgimg];
//    [view_ addSubview:imgView_];
//
//    return view_;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if(section == 0)
//        return 14;
//    else
//        return 0;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 14)] autorelease];
//    CGRect rct = [BBMisc getRect:CELL_LEFT_SPACE withPosY:0.0 withwidth:12.0 withHeight:14.0];
//    UIImageView *imgView = [[[UIImageView alloc] initWithFrame:rct] autorelease];
//    [imgView setImage:[UIImage imageNamed:@"endOfHistory.png"]];
//    [view addSubview:imgView];
//    UILabel *lable = [[[UILabel alloc] initWithFrame:CGRectMake(CELL_LEFT_SPACE +  12, 0.0, 150, 14)] autorelease];
//    [lable setBackgroundColor:[UIColor clearColor]];
//    [lable setFont:[UIFont boldSystemFontOfSize:12]];
//    [lable setTextColor:[BBSkin shareSkin].bgTxtColor];
//    [lable setText:[BBMisc getTheTimeOfFirstUseApp]];
//    [view addSubview:lable];
//    return view;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(section == 0)
        return arrayDataList.count + 1;
    else
        return 1;
}


// table with with built in cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1)
    {
        static NSString *strIndef = @"HomeDateCell";
        DateCell *cell = [tableView dequeueReusableCellWithIdentifier:strIndef];
        if(!cell)
        {
            cell = [[DateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndef];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        return cell;
    }
    if(indexPath.row == 0)
    {
        static NSString *strIndef = @"HomeImageCell";
        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:strIndef];
        if(!cell)
        {
            cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndef];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        NSString *strBgImg = [[FileManagerController documentPath] stringByAppendingPathComponent:NOTE_BG_PATH];
        strBgImg = [strBgImg stringByAppendingPathComponent:[BBUserDefault getTimelineTitleImage]];
        if(![BBUserDefault getTimelineTitleImage] || ![FileManagerController fileExist:strBgImg])
        {
            cell.strImage = [[FileManagerController resourcesPath] stringByAppendingPathComponent:@"home_default_title_bg.jpg"];
          
        }
        else
        {
            cell.strImage = strBgImg;
        }
        BBINFO(@"%@", cell.strImage);
        return cell;
    }
    static NSString *CellIdentifier = @"HomeContentCell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    BBRecord *bbrecord = [self.arrayDataList objectAtIndex:indexPath.row - 1];
    cell.brecord = bbrecord;
    cell.arrayAudios = [[bbrecord audioInRecord] allObjects];
    cell.arrayImages = [DataModel BBimageArrayGetImagelist:[[bbrecord imageInRecord] allObjects]];
    cell.bcontent = bbrecord.contentInRecord;
//    if(self.arrayDataList.count == indexPath.row)
//        cell.isLast = YES;
//    else
//        cell.isLast = NO;
    [cell resizeHeight];
    return cell;
}

@end
