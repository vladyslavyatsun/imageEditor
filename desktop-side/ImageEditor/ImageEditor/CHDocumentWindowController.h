//
//  CHDocumentWindowController.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/21/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CHAbstractElement;

@interface CHDocumentWindowController : NSWindowController
- (void)addImageOnViewWithInitialPoint:(NSPoint)aPoint path:(NSString *)aPath;
@end
