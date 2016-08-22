//
//  CHImage.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHAbstractElement.h"

@interface CHImage : CHAbstractElement
@property (nonatomic, retain) NSImage *image;

- (instancetype)initWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint image:(NSImage *)image;

@end
