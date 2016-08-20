//
//  CHImage.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHImage.h"

@interface CHImage()
@property (nonatomic, retain) NSImage *anImage;
@end

@implementation CHImage

- (instancetype)initWithInitialPoint:(NSPoint)initialPoint imagePath:(NSString *)imagePath
{
    self = [super init];
    if(self)
    {
        self.initialPoint = initialPoint;
        _anImage = [[NSImage alloc] initWithContentsOfFile:imagePath];
        
    }
    return self;
}


- (void)draw
{
    [self.anImage drawInRect:NSMakeRect(20, 20, 20, 20)];
}

- (void)addPoint:(NSPoint)point
{
    NSLog(@"image doesn't have path");
}

- (NSColor *)color
{
    NSLog(@"image doesn't have color");
    return nil;
}

- (void)setColor:(NSColor *)color
{
    NSLog(@"image doesn't have color");
}

- (CGFloat)thickness
{
    NSLog(@"image doesn't have thickness");
    return 0;
}

- (NSBezierPath *)path
{
    NSLog(@"image doesn't have path");
    return nil;
}

- (void)setPath:(NSBezierPath *)path
{
    NSLog(@"image doesn't have color");
}

- (void)dealloc
{
    [_anImage release];
    [super dealloc];
}
@end
