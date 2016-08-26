//
//  CHCanvasView.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/19/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CHAbstractElementRepresentation;

@interface CHCanvasView : NSView

- (instancetype)initWithElementsRepresentation:(NSArray<CHAbstractElementRepresentation *> *)elementsWithRepresentation;

@end
