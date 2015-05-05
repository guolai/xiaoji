//
//  TileView.m
//  bbnote
//
//  Created by bob on 7/8/13.
//  Copyright (c) 2013 bob. All rights reserved.
//

#import "TileView.h"

@implementation TileView



- (void)setTileImage:(UIImage *)img
{
    if(image_ != img)
    {
        image_ = img;
        if(image_)
            [self setNeedsDisplay];
    }

}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.1, 0.1, 0, 0.9);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextDrawPath(context, kCGPathFill);
    if(image_)
    {
        float fHeight = rect.size.height;
        float fImgHeight = image_.size.height;
        
        float fTotal = 0;
        fImgHeight = fImgHeight * rect.size.width / image_.size.width;
       
        if(fImgHeight >= fHeight)
        {
            [image_ drawInRect:CGRectMake(0, 0, rect.size.width, fImgHeight)];
        }
        else
        {
            while(fTotal < fHeight)
            {
                [image_ drawInRect:CGRectMake(0, fTotal, rect.size.width, fImgHeight)];
                fTotal += fImgHeight;
                NSLog(@"---- %f", fTotal);
            }
        }
    }

}


@end
