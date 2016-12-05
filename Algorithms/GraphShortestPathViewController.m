//
//  GraphShortestPathViewController.m
//  Algorithms Playground
//
//  Created by Mincho Dzhagalov on 7/30/16.
//  Copyright © 2016 Mincho Dzhagalov. All rights reserved.
//

#import "GraphShortestPathViewController.h"
#import "Dijkstra.h"

@interface GraphShortestPathViewController ()
@property (weak, nonatomic) IBOutlet UIView *a;
@property (weak, nonatomic) IBOutlet UIView *b;
@property (weak, nonatomic) IBOutlet UIView *c;
@property (weak, nonatomic) IBOutlet UIView *d;
@property (weak, nonatomic) IBOutlet UIView *e;
@property (weak, nonatomic) IBOutlet UIView *f;
@property (weak, nonatomic) IBOutlet UIView *g;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *weights;
@property (weak, nonatomic) IBOutlet UIButton *runButton;

@property (nonatomic) CGFloat delay;
@property (nonatomic) NSMutableDictionary *nodeByName;
@property (nonatomic) NSMutableDictionary *nameByNode;
@property (nonatomic) NSMutableArray *graph;
@end

@implementation GraphShortestPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self roundViews];
    [self drawEdges];
    [self mapNodes];
    [self buildGraph];
    [self drawEdgeWeights];
}

- (IBAction)run:(UIButton *)sender {
    [self runningStateDidBegin];
    
    NSArray *pathByIndices = [Dijkstra FindShortestPathIn:self.graph fromNode:0 toNode:6];
    
    [self animateShortestPath:pathByIndices];
}

- (void)animateShortestPath:(NSArray *)path {
    for (NSString *node in path) {
        NSString *nodeName = self.nameByNode[[NSString stringWithFormat:@"%@", node]];
        
        if ([nodeName isEqualToString:@"A"]) {
            [self animateUIViewBackgroundColorChange:self.a Delayed:self.delay];
            [self performSelector:@selector(animateUILabelBackgroundColorChange:Delayed:)
                       withObject:[[self.a subviews] firstObject]
                       afterDelay:self.delay];
        } else if ([nodeName isEqualToString:@"B"]) {
            [self animateUIViewBackgroundColorChange:self.b Delayed:self.delay];
            [self performSelector:@selector(animateUILabelBackgroundColorChange:Delayed:)
                       withObject:[[self.b subviews] firstObject]
                       afterDelay:self.delay];
        } else if ([nodeName isEqualToString:@"C"]) {
            [self animateUIViewBackgroundColorChange:self.c Delayed:self.delay];
            [self performSelector:@selector(animateUILabelBackgroundColorChange:Delayed:)
                       withObject:[[self.c subviews]
                                   firstObject]
                       afterDelay:self.delay];
        } else if ([nodeName isEqualToString:@"D"]) {
            [self animateUIViewBackgroundColorChange:self.d Delayed:self.delay];
            [self performSelector:@selector(animateUILabelBackgroundColorChange:Delayed:)
                       withObject:[[self.d subviews]
                                   firstObject]
                       afterDelay:self.delay];
        } else if ([nodeName isEqualToString:@"E"]) {
            [self animateUIViewBackgroundColorChange:self.e Delayed:self.delay];
            [self performSelector:@selector(animateUILabelBackgroundColorChange:Delayed:)
                       withObject:[[self.e subviews] firstObject]
                       afterDelay:self.delay];
        } else if ([nodeName isEqualToString:@"F"]) {
            [self animateUIViewBackgroundColorChange:self.f Delayed:self.delay];
            [self performSelector:@selector(animateUILabelBackgroundColorChange:Delayed:)
                       withObject:[[self.f subviews] firstObject]
                       afterDelay:self.delay];
        } else if ([nodeName isEqualToString:@"G"]) {
            [self animateUIViewBackgroundColorChange:self.g Delayed:self.delay];
            [self performSelector:@selector(animateUILabelBackgroundColorChange:Delayed:)
                       withObject:[[self.g subviews] firstObject]
                       afterDelay:self.delay];
        }
        
        self.delay += 1.0f;
    }
    
    [self performSelector:@selector(runningStateDidEnd) withObject:nil afterDelay:self.delay];
}

- (void)animateUIViewBackgroundColorChange:(UIView *)view Delayed:(CGFloat)delay {
    [UIView animateWithDuration:1.0f
                          delay:delay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [view.layer setBackgroundColor:[[UIColor lightGrayColor] CGColor]];
                     }
                     completion:nil];
}

- (void)animateUILabelBackgroundColorChange:(UILabel *)label Delayed:(CGFloat)delay {
    [UIView transitionWithView:label
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        label.backgroundColor = [UIColor lightGrayColor];
                    }
                    completion:nil];
}

- (void)drawEdgeWeights {
    for (UILabel *label in self.weights) {
        NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        
        if ([label.text rangeOfCharacterFromSet:set].location != NSNotFound) {
            continue;
        }
        
        NSString *x = [[label.text substringToIndex:1] uppercaseString];
        NSString *y = [[label.text substringFromIndex:1] uppercaseString];
        
        NSInteger node1 = [self.nodeByName[x] integerValue];
        NSInteger node2 = [self.nodeByName[y] integerValue];
        
        [label setText:[NSString stringWithFormat:@"%@", self.graph[node1][node2]]];
    }
}

- (void)mapNodes {
    [self.nodeByName setValue:[NSNumber numberWithInt:0] forKey:@"A"];
    [self.nodeByName setValue:[NSNumber numberWithInt:1] forKey:@"B"];
    [self.nodeByName setValue:[NSNumber numberWithInt:2] forKey:@"C"];
    [self.nodeByName setValue:[NSNumber numberWithInt:3] forKey:@"D"];
    [self.nodeByName setValue:[NSNumber numberWithInt:4] forKey:@"E"];
    [self.nodeByName setValue:[NSNumber numberWithInt:5] forKey:@"F"];
    [self.nodeByName setValue:[NSNumber numberWithInt:6] forKey:@"G"];
    
    [self.nameByNode setValue:@"A" forKey:@"0"];
    [self.nameByNode setValue:@"B" forKey:@"1"];
    [self.nameByNode setValue:@"C" forKey:@"2"];
    [self.nameByNode setValue:@"D" forKey:@"3"];
    [self.nameByNode setValue:@"E" forKey:@"4"];
    [self.nameByNode setValue:@"F" forKey:@"5"];
    [self.nameByNode setValue:@"G" forKey:@"6"];
}

- (void)buildGraph {
    NSMutableArray *graph = [[NSMutableArray alloc] init];
    
    NSNumber *aToB = [NSNumber numberWithInt:1 + arc4random() % (100 - 1)];
    NSNumber *aToC = [NSNumber numberWithInt:1 + arc4random() % (100 - 1)];
    
    NSNumber *bToC = [NSNumber numberWithInt:1 + arc4random() % (100 - 1)];
    NSNumber *bToD = [NSNumber numberWithInt:1 + arc4random() % (100 - 1)];
    
    NSNumber *cToD = [NSNumber numberWithInt:1 + arc4random() % (100 - 1)];
    NSNumber *cToE = [NSNumber numberWithInt:1 + arc4random() % (100 - 1)];
    
    NSNumber *dToE = [NSNumber numberWithInt:1 + arc4random() % (100 - 1)];
    NSNumber *dToF = [NSNumber numberWithInt:1 + arc4random() % (100 - 1)];
    
    NSNumber *fToG = [NSNumber numberWithInt:1 + arc4random() % (100 - 1)];
    
    for (int i = 0; i < 7; i++) {
        [graph addObject:[NSMutableArray new]];
        
        for (int j = 0; j < 7; j++) {
            [graph[i] addObject:[NSNumber numberWithInt:-1]];
        }
    }
    
    graph[0][1] = aToB;
    graph[0][2] = aToC;
    
    graph[1][0] = aToB;
    graph[1][2] = bToC;
    graph[1][3] = bToD;
    
    graph[2][0] = aToC;
    graph[2][1] = bToC;
    graph[2][3] = cToD;
    graph[2][4] = cToE;
    
    graph[3][1] = bToD;
    graph[3][2] = cToD;
    graph[3][4] = dToE;
    graph[3][5] = dToF;
    
    graph[4][2] = cToE;
    graph[4][3] = dToE;
    
    graph[5][3] = dToF;
    graph[5][6] = fToG;
    
    graph[6][5] = fToG;
    
    self.graph = graph;
}

- (void)roundViews {
    [self roundUIView:self.a];
    [self roundUIView:self.b];
    [self roundUIView:self.c];
    [self roundUIView:self.d];
    [self roundUIView:self.e];
    [self roundUIView:self.f];
    [self roundUIView:self.g];
}

- (void)roundUIView:(UIView *)view {
    view.layer.cornerRadius = view.frame.size.width / 2;
    view.layer.borderWidth = 2.0f;
    view.layer.borderColor = [[UIColor blackColor] CGColor];
}

- (void)drawEdges {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint pointA = CGPointMake(self.a.center.x + self.a.frame.size.width / 2, self.a.center.y);
    
    CGPoint pointBTop = CGPointMake(self.b.center.x, self.b.center.y - self.b.frame.size.height / 2);
    CGPoint pointBRight = CGPointMake(self.b.center.x + self.b.frame.size.width / 2, self.b.center.y);
    
    CGPoint pointCLeft = CGPointMake(self.c.center.x - self.c.frame.size.width / 2, self.c.center.y);
    CGPoint pointCRight = CGPointMake(self.c.center.x + self.c.frame.size.width / 2, self.c.center.y);
    CGPoint pointCBottom = CGPointMake(self.c.center.x, self.c.center.y + self.c.frame.size.height / 2);
    
    CGPoint pointDLeft = CGPointMake(self.d.center.x - self.d.frame.size.width / 2, self.d.center.y);
    CGPoint pointDBottom = CGPointMake(self.d.center.x, self.d.center.y + self.d.frame.size.height / 2);
    CGPoint pointDRight = CGPointMake(self.d.center.x + self.d.frame.size.width / 2, self.d.center.y);
    
    CGPoint pointELeft = CGPointMake(self.e.center.x - self.e.frame.size.width / 2, self.e.center.y);
    
    CGPoint pointFRight = CGPointMake(self.f.center.x + self.f.frame.size.width / 2, self.f.center.y);
    CGPoint pointFLeft = CGPointMake(self.f.center.x - self.f.frame.size.width / 2, self.f.center.y);
    
    CGPoint pointGLeft = CGPointMake(self.g.center.x - self.g.frame.size.width / 2, self.g.center.y);
    
    [path moveToPoint:pointA];
    [path addLineToPoint:pointBTop];
    [path moveToPoint:pointA];
    [path addLineToPoint:pointCLeft];
    
    [path moveToPoint:pointBTop];
    [path addLineToPoint:pointCBottom];
    [path moveToPoint:pointBRight];
    [path addLineToPoint:pointDLeft];
    
    [path moveToPoint:pointCRight];
    [path addLineToPoint:pointELeft];
    [path moveToPoint:pointCBottom];
    [path addLineToPoint:pointDLeft];
    
    [path moveToPoint:pointDRight];
    [path addLineToPoint:pointELeft];
    
    [path moveToPoint:pointDBottom];
    [path addLineToPoint:pointFLeft];
    
    [path moveToPoint:pointFRight];
    [path addLineToPoint:pointGLeft];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    
    layer.path = path.CGPath;
    layer.strokeColor = [[UIColor whiteColor] CGColor];
    layer.lineWidth = 2.0f;
    
    [self.view.layer addSublayer:layer];
}

- (void)runningStateDidBegin {
    self.runButton.enabled = NO;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    [self.view setUserInteractionEnabled:NO];
}

- (void)runningStateDidEnd {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    [self.view setUserInteractionEnabled:YES];
}

#pragma Mark - Lazy Instantiation

- (NSMutableDictionary *)nodeByName
{
    if (!_nodeByName){
        _nodeByName = [[NSMutableDictionary alloc] init];
    }
    
    return _nodeByName;
}

- (NSMutableDictionary *)nameByNode
{
    if (!_nameByNode){
        _nameByNode = [[NSMutableDictionary alloc] init];
    }
    
    return _nameByNode;
}

#pragma Mark - Navigation

- (IBAction)popViewController:(UISwipeGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
