//
//  HomeSelectViewController.m
//  bbnote
//
//  Created by bob on 7/7/13.
//  Copyright (c) 2013 bob. All rights reserved.
//

#import "HomeSelectViewController.h"
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Constant.h"
#import "BBSkin.h"
#import "FileManagerController.h"
#import "SettingCell.h"
#import "BBUserDefault.h"

@implementation HomeSelectViewController


- (id)init
{
    self = [super init];
    if (self) {
        arrayData_ = [[NSArray alloc] initWithObjects:@"从手机相册选择", @"拍一张", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[BBSkin shareSkin].bgColor];
    [self showBackButton:NSLocalizedString(@"Home", nil) action:nil];
    [self showTitle:NSLocalizedString(@"Setting",nil)];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(5.0, 0.0, SCR_WIDTH - 5, SCR_HEIGHT - SCR_TOPBAR) style:UITableViewStyleGrouped];
    [self.tableView  setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 2;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"settextcell";
    SetTextTableCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if(!cell)
    {
        cell = [[SetTextTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
    }
    cell.lblName.textColor = [BBSkin shareSkin].bgTxtColor;
    cell.lblText.textColor = [BBSkin shareSkin].bgTxtLightColor;
    cell.lblName.text = [arrayData_  objectAtIndex:indexPath.row];
    cell.lblText.text = nil;
    if(indexPath.section == 0 && indexPath.row == 2)
    {
        if([BBUserDefault getPasswdStatus])
        {
            cell.lblText.text =NSLocalizedString(@"opened", nil);
        }
        else
        {
            cell.lblText.text =NSLocalizedString(@"closed", nil);
        }
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
            ipc.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            ipc.delegate = self;
            ipc.allowsEditing=YES;
            [self presentViewController:ipc animated:YES completion:NULL];
        }
        else
        {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            NSString *requiredMediaType = (NSString *)kUTTypeImage;
            controller.mediaTypes = [[NSArray alloc] initWithObjects:requiredMediaType, nil];
            controller.allowsEditing = YES;
            controller.delegate = self;
            
            [self.navigationController presentViewController:controller animated:YES completion:NULL];
        }
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BBINFO(@"%@", info);
    NSString *mediaType =[info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        BBINFO(@"you select a video");
    }
    else if([mediaType isEqualToString:(NSString *) kUTTypeImage])
    {
        UIImage *pickeImg =[info objectForKey:UIImagePickerControllerEditedImage];
        if(pickeImg && ![pickeImg isEqual:[NSNull null]])
        {
            NSString *strPath1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"notephoto"];
            strPath1 = [strPath1 pathExtension];
            BBINFO(@"%@", strPath1);
            if(![FileManagerController documentCreateDirectoryPath:NOTE_BG_PATH])
            {
                BBINFO(@"file path create failed");
            }
            NSString *strPath = [[FileManagerController documentPath] stringByAppendingPathComponent:NOTE_BG_PATH];
            strPath = [strPath stringByAppendingPathComponent:[BBUserDefault getTimelineTitleImage]];
            BBINFO(@"file path is %@", strPath);
            [UIImagePNGRepresentation(pickeImg) writeToFile:strPath atomically:YES];
            [BBUserDefault setHomeViewIndex:-1];
            [self dismissViewControllerAnimated:YES completion:NULL];
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark postdata

@end
