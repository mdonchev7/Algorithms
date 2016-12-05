//
//  Dijkstra.h
//  Algorithms Playground
//
//  Created by Mincho Dzhagalov on 7/10/16.
//  Copyright © 2016 Mincho Dzhagalov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dijkstra : NSObject

+ (NSArray *)FindShortestPathIn:(NSMutableArray*)graph fromNode:(int)sourceNode toNode:(int) destinationNode;

@end
