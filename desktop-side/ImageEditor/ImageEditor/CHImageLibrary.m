//
//  ImageLibrary.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHImageLibrary.h"


@interface CHImageLibrary()
@property (nonatomic, readwrite) NSMutableArray<CHStandartImage *> *mImageArray;
@end
@implementation CHImageLibrary

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _mImageArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)loadImages
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *imagesPath = [mainBundle pathsForResourcesOfType:nil inDirectory:@"image"];
    
    for (NSString *path in imagesPath)
    {
        CHStandartImage *image = [[CHStandartImage alloc] initWithPath:path withTitle:path];
        
        [self addImage:image];
        
        [image release];
    }
}

- (void)addImage:(CHStandartImage *)aImage
{
    if (aImage != nil)
    {
        [self.mImageArray addObject:aImage];
    }
}

- (void)removeImage:(CHStandartImage *)aImage
{
    [self.mImageArray removeObject:aImage];
}


- (NSArray<CHStandartImage *> *)imageArray
{
    return _mImageArray;
}
@end
