//
//  CHDocumentViewController.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/25/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CHAbstractElement;

@interface CHCanvasViewController : NSViewController
@property (nonatomic, assign) BOOL drawTool;

- (void)addElementOnView:(CHAbstractElement *)anElement;
- (void)removeElementFromView:(CHAbstractElement *)anElement;
- (NSBitmapImageRep *)viewToBitmapImageRepresentation;
@end
