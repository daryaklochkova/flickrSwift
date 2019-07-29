//
//  CellSizeProvider.h
//  flickerSwift
//
//  Created by Darya Klochkova on 26/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol CellSizeProvider <NSObject>
- (instancetype)initWithMinCellSize:(CGSize)minCellSize
                         minSpacing:(NSInteger)minSpacing;
- (void)recalculateCellSize:(CGSize)collectionViewSize;

- (CGSize)getCellSize;
- (UIEdgeInsets)getEdgeInsets;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CellSizeProvider : NSObject <CellSizeProvider>

@end

NS_ASSUME_NONNULL_END
