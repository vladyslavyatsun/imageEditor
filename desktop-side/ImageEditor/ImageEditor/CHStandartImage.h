//
//  CHStandartImage.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHStandartImage : NSObject
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *title;
- (instancetype)initWithPath:(NSString *)path withTitle:(NSString *)title;
@end
