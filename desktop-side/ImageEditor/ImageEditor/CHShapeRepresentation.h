//
//  CHShapeRepresentation.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHAbstractElementRepresentation.h"

@interface CHShapeRepresentation : CHAbstractElementRepresentation
@property (nonatomic, retain) NSBezierPath *bezierPath;
@property (nonatomic, retain) NSColor *color;
@end
