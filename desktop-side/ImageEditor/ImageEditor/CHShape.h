//
//  CHShape.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/21/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHAbstractElement.h"

@interface CHShape : CHAbstractElement
@property (nonatomic, retain) NSColor *color;

- (instancetype)initWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint color:(NSColor *)color;

@end
