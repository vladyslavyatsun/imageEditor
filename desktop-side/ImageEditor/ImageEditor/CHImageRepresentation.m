//
//  CHImageRepresentation.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHImageRepresentation.h"
#import "CHImage.h"

@implementation CHImageRepresentation

- (void)draw
{
    NSImage *image = ((CHImage *)self.modelElement).image;
    
    if ([self isSelected])
    {
        [NSGraphicsContext saveGraphicsState];
        NSSetFocusRingStyle(NSFocusRingAbove);
        [image drawInRect:self.rect];
        [NSGraphicsContext restoreGraphicsState];
    }
    else
    {
        [image drawInRect:self.rect];
    }
}



@end
