//
//  CHIntegerTransformer.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/25/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHIntegerTransformer.h"

@implementation CHIntegerTransformer

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return value;
}

- (id)reverseTransformedValue:(id)value
{
    NSNumber *result = @(0);
    
    if (value)
    {
        result = value;
    }
    
    return result;
}

@end
