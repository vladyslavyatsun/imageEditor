//
//  ImageLibrary.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHStandartImage.h"

@interface CHImageLibrary : NSObject
@property (nonatomic, readonly, retain) NSArray<CHStandartImage *> *imageArray;

- (void)loadImages;
- (void)addImage:(CHStandartImage *)aImage;
- (void)removeImage:(CHStandartImage *)aImage;

@end
