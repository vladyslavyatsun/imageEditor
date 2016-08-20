//
//  CHImage.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHAbstractElement.h"

@interface CHImage : CHAbstractElement
- (instancetype)initWithInitialPoint:(NSPoint)initialPoint imagePath:(NSString *)imagePath;
@end
