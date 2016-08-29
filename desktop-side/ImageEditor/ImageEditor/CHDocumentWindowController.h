//
//  CHDocumentWindowController.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/21/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CHAbstractElement;
@class CHDocumentModelController;

@interface CHDocumentWindowController : NSWindowController
typedef NS_ENUM(NSUInteger, CHDrawTool)
{
    kCHPointerTool = 0,
    kCHLineTool = 1,
    kCHRectangleTool = 2,
    kCHEllipseTool = 3
};

@property (nonatomic, assign) CHDrawTool selectedDrawTool;

- (instancetype)initWithNibName:(NSString *)nibName modelContoller:(CHDocumentModelController *)modelContoller;

- (void)addImageOnViewWithInitialPoint:(NSPoint)aPoint path:(NSString *)aPath;
- (void)setToolForDrawOnCanvas:(CHDrawTool)drawTool;
- (NSData *)documentViewRepresentationWithType:(CFStringRef)type;

@end
