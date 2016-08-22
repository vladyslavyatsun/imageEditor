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
@class CHImage;

extern NSString * const kCHElementDidUpdate;

@interface CHAbstractElement : NSObject

@property (nonatomic, assign) NSPoint startPoint;
@property (nonatomic, assign) NSPoint endPoint;

- (instancetype)initWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint;

+ (CHLine *)lineWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint color:(NSColor *)color;
+ (CHRectangle *)rectangleWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint color:(NSColor *)color;
+ (CHEllipse *)ellipseWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint color:(NSColor *)color;
+ (CHImage *)imageWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint image:(NSImage *)image;


@end
