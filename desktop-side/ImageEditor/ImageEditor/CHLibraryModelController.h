//
//  CHLibraryModelController.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/29/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CHLibraryImage;

@interface CHLibraryModelController : NSObject
@property (nonatomic, retain) NSArray<CHLibraryImage *> *libraryImages;
- (void)addImageInLibrary:(CHLibraryImage *)image;
- (void)loadImagesWithTypes:(NSArray *)types;
- (NSString *)applicationSupportPath;
- (BOOL)loadImageData:(NSData *)image withFileName:(NSString *)fileName;
- (void)addImageInLibrary:(CHLibraryImage *)image withIndex:(NSUInteger)index;
- (CHLibraryImage *)imageWithIndex:(NSUInteger)index;
@end
