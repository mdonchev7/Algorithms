//
//  Dijkstra.m
//  Algorithms Playground
//
//  Created by Mincho Dzhagalov on 7/10/16.
//  Copyright © 2016 Mincho Dzhagalov. All rights reserved.
//

#import "Dijkstra.h"

@implementation Dijkstra

+ (NSArray *)FindShortestPathIn:(NSMutableArray *)graph fromNode:(int)sourceNode toNode:(int) destinationNode {
    NSInteger n = [graph count];
    
    NSMutableArray *visited = [[NSMutableArray alloc] init];
    NSMutableArray *previous = [[NSMutableArray alloc] init];
    NSMutableArray *distance = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < n; i++)
    {
        [distance addObject:[NSNumber numberWithInteger:INT_MAX]];
    }
    
    for (int i = 0; i < n; i++)
    {
        [previous addObject:[NSNull null]];
    }
    
    for (int i = 0; i < n; i++)
    {
        [visited addObject:[NSNumber numberWithInteger:0]];
    }
    
    distance[sourceNode] = [NSNumber numberWithInteger:0];
    
    while (true)
    {
        NSInteger bestDistance = INT_MAX;
        NSInteger nearestNode = -1;
        
        for (int node = 0; node < n; node++) // Find the nearest node from all not visited nodes
        {
            bool isVisited = [visited[node] boolValue];
            if (!isVisited && [distance[node] integerValue] < bestDistance)
            {
                bestDistance = [distance[node] integerValue];
                nearestNode = node;
            }
        }
        
        if (bestDistance == INT_MAX) // All nodes are visited
        {
            break;
        }
        
        visited[nearestNode] = @(YES);
        
        for (int node = 0; node < n; node++)
        {
            if ([graph[nearestNode][node] integerValue] > 0) // Nodes have an edge between them
            {
                NSInteger distanceFromSourceToNearest = [distance[nearestNode] integerValue];
                NSInteger distanceFromNearestToNode = [graph[nearestNode][node] integerValue];
                NSInteger distanceFromSourceToNodeViaNearest = distanceFromSourceToNearest + distanceFromNearestToNode;
                
                if (distanceFromSourceToNodeViaNearest < [distance[node] integerValue])
                {
                    distance[node] = [NSNumber numberWithInteger:distanceFromSourceToNodeViaNearest];
                    previous[node] = [NSNumber numberWithInteger:nearestNode];
                }
            }
        }
    }
    
    if ([distance[destinationNode] integerValue] == INT_MAX) // No path from source to destination
    {
        return NULL;
    }
    
    NSMutableArray *path = [[NSMutableArray alloc] init];
    
    NSNumber *currentNode = [NSNumber numberWithInteger:destinationNode];
    
    while (currentNode != [NSNull null])
    {
        [path addObject:currentNode];
        currentNode = previous[[currentNode integerValue]];
    }
    
    return [[path reverseObjectEnumerator] allObjects];
}

@end
