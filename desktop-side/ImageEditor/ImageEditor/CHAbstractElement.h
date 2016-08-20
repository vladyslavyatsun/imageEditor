//
//  CHAbstractFigure.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/19/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CHLine;
@class CHEllipse;
@class CHRectangle;

@interface CHAbstractElement : NSObject

@property (nonatomic, retain) NSBezierPath *path;
@property (nonatomic, retain) NSColor *color;
@property (nonatomic, assign) CGFloat thickness;
@property (nonatomic, assign) NSPoint initialPoint;

- (instancetype)initWithInitialPoint:(NSPoint)initialPoint;
- (void)addPoint:(NSPoint)point;
- (void)draw;

+ (CHLine *)lineWithInitialPoint:(NSPoint)initialPoint;
+ (CHRectangle *)rectangleWithInitialPoint:(NSPoint)initialPoint;
+ (CHEllipse *)ellipseWithInitialPoint:(NSPoint)initialPoint;



@end
