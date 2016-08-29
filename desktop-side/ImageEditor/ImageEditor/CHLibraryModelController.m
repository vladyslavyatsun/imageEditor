//
//  CHLibraryModelController.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/29/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHLibraryModelController.h"
#import "CHLibraryImage.h"

NSString * const kCHResourcesDirectoryName = @"images";
NSString *const kCHApplicationSupportDirectory = @"ImageEditor";
@interface CHLibraryModelController()
@property (nonatomic, retain) NSMutableArray<CHLibraryImage *> *mutableLibraryImages;
@end
@implementation CHLibraryModelController
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _mutableLibraryImages = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)loadImagesWithTypes:(NSArray *)types
{
    NSMutableArray<NSURL *> *imagesURLs = [[NSMutableArray alloc] init];
    NSString *appSupportPath = [self applicationSupportPath];
    
    if (appSupportPath)
    {
        NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appSupportPath error:NULL];
        
        for (NSString *path in fileNames)
        {
            NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", appSupportPath, path]];
            
            CHLibraryImage *image = [[CHLibraryImage alloc] initWithTitle:[url.lastPathComponent stringByDeletingPathExtension] url:url readOnly:NO];
            
            if (image)
            {
                [self addImageInLibrary:image];
                [image release];
            }
        }
        
        for (NSString *type in types)
        {
            [imagesURLs addObjectsFromArray:[[NSBundle mainBundle] URLsForResourcesWithExtension:type.pathExtension
                                                                                    subdirectory:kCHResourcesDirectoryName]];
        }
        
        for (NSURL *url in imagesURLs)
        {
            CHLibraryImage *image = [[CHLibraryImage alloc] initWithTitle:[url.lastPathComponent stringByDeletingPathExtension] url:url readOnly:YES];
            
            if (image)
            {
                [self addImageInLibrary:image];
                [image release];
            }
        }
    }
    
    [imagesURLs release];
}


- (BOOL)loadImageData:(NSData *)image withFileName:(NSString *)fileName
{
    BOOL result = NO;
    
    if (image)
    {
        NSString *filePath = [[self applicationSupportPath] stringByAppendingPathComponent:fileName];
        
        NSError *writeError = nil;
        
        if (filePath)
        {
            [image writeToFile:filePath options:NSDataWritingAtomic error:&writeError];
            
            if (!writeError)
            {
                result = YES;
            }
        }
    }
    
    return result;
}

- (NSString *)applicationSupportPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *appSupportPath = [paths.firstObject stringByAppendingPathComponent:kCHApplicationSupportDirectory];
    
    NSString *result = nil;
    
    NSError *createError = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:appSupportPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&createError];
    
    if (!createError)
    {
        result = [NSString stringWithString:appSupportPath];
    }
    
    return result;
}


- (void)addImageInLibrary:(CHLibraryImage *)image
{
    if (image)
    {
        [self insertObject:image inLibraryImagesAtIndex:self.mutableLibraryImages.count];
    }
}

- (void)addImageInLibrary:(CHLibraryImage *)image withIndex:(NSUInteger)index
{
    if (image)
    {
        [self insertObject:image inLibraryImagesAtIndex:index];
    }
}

- (CHLibraryImage *)imageWithIndex:(NSUInteger)index
{
    return [self objectInLibraryImagesAtIndex:index];
}

#pragma mark libraryDocuments KVC Support
- (NSArray<CHLibraryImage *> *)libraryImages
{
    return self.mutableLibraryImages;
}

- (NSUInteger)countOfLibraryImages
{
    return self.mutableLibraryImages.count;
}

- (CHLibraryImage *)objectInLibraryImagesAtIndex:(NSUInteger)index
{
    return self.mutableLibraryImages[index];
}

- (void)insertObject:(CHLibraryImage *)object inLibraryImagesAtIndex:(NSUInteger)index
{
    [self.mutableLibraryImages insertObject:object atIndex:index];
}

- (void)removeObjectFromLibraryImagesAtIndex:(NSUInteger)index
{
    [self.mutableLibraryImages removeObjectAtIndex:index];
}

-(void)dealloc
{
    [_mutableLibraryImages release];
    [super dealloc];
}

@end
