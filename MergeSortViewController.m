//
//  MergeSortViewController.m
//  Algorithms Playground
//
//  Created by Mincho Dzhagalov on 8/4/16.
//  Copyright © 2016 Mincho Dzhagalov. All rights reserved.
//

#import "MergeSortViewController.h"

@interface MergeSortViewController()
@property (weak, nonatomic) IBOutlet UIButton *runButton;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *views;

@property (nonatomic) NSMutableArray *numbers;
@property (nonatomic) CGFloat delay;
@property (nonatomic) NSInteger viewIndex;
@property (nonatomic) NSInteger step;

@end

@implementation MergeSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self generateRandomNumbers];
    
    [self updateUI];
    
    self.viewIndex += [self.numbers count];
}

- (IBAction)run:(id)sender {
    [self runningStateDidBegin];
    
    self.numbers = [self mergeSort:self.numbers];
}

- (NSMutableArray *) mergeSort:(NSMutableArray *)arr {
    if ([arr count] == 1) {
        return  arr;
    }
    
    NSMutableArray *left = [NSMutableArray new];
    NSMutableArray *right = [NSMutableArray new];
    
    for (int i = 0; i < [arr count]; i++) {
        if (i % 2 == 0) {
            [left addObject:arr[i]];
        } else {
            [right addObject:arr[i]];
        }
    }
    
    for (NSNumber *number in left) {
        UIView *view = self.views[self.viewIndex];
        UILabel *label = [[view subviews] firstObject];
        NSMutableArray *args = [[NSMutableArray alloc] initWithObjects:view, label, number, nil];
        
        [self performSelector:@selector(transitionFromHiddenState:) withObject:args afterDelay:self.delay];
        self.viewIndex++;
        self.delay += 0.7f;
    }
    
    self.delay += 1.0f;
    
    for (NSNumber *number in right) {
        UIView *view = self.views[self.viewIndex];
        UILabel *label = [[view subviews] firstObject];
        NSMutableArray *args = [[NSMutableArray alloc] initWithObjects:view, label, number, nil];
        
        [self performSelector:@selector(transitionFromHiddenState:) withObject:args afterDelay:self.delay];
        self.viewIndex++;
        self.delay += 0.7f;
    }
    
    self.delay += 1.0f;
    
    left = [self mergeSort:left];
    right = [self mergeSort:right];
    
    return [self merge:left :right];
}

- (NSMutableArray *)merge:(NSMutableArray *)left :(NSMutableArray *)right {
    NSMutableArray *result = [NSMutableArray new];
    
    int resultLeftIndex = 0;
    int resultRightIndex = 0;
    
    NSMutableArray *leftViewsIndices = [NSMutableArray new];
    NSMutableArray *rightViewsIndices = [NSMutableArray new];
    NSInteger leftViewIndex = 0;
    NSInteger rightViewIndex = 0;
    
    int upperRowViewIndex = -1;
    
    if (self.step == 0) {
        [leftViewsIndices addObject:[NSNumber numberWithInteger:15]];
        [rightViewsIndices addObject:[NSNumber numberWithInteger:16]];
        upperRowViewIndex = 12;
    } else if (self.step == 1) {
        [leftViewsIndices addObject:[NSNumber numberWithInteger:12]];
        [leftViewsIndices addObject:[NSNumber numberWithInteger:13]];
        [rightViewsIndices addObject:[NSNumber numberWithInteger:14]];
        upperRowViewIndex = 6;
    } else if (self.step == 2) {
        [leftViewsIndices addObject:[NSNumber numberWithInteger:20]];
        [rightViewsIndices addObject:[NSNumber numberWithInteger:21]];
        upperRowViewIndex = 17;
    } else if (self.step == 3) {
        [leftViewsIndices addObject:[NSNumber numberWithInteger:17]];
        [leftViewsIndices addObject:[NSNumber numberWithInteger:18]];
        [rightViewsIndices addObject:[NSNumber numberWithInteger:19]];
        upperRowViewIndex = 9;
    } else if (self.step == 4) {
        [leftViewsIndices addObject:[NSNumber numberWithInteger:6]];
        [leftViewsIndices addObject:[NSNumber numberWithInteger:7]];
        [leftViewsIndices addObject:[NSNumber numberWithInteger:8]];
        [rightViewsIndices addObject:[NSNumber numberWithInteger:9]];
        [rightViewsIndices addObject:[NSNumber numberWithInteger:10]];
        [rightViewsIndices addObject:[NSNumber numberWithInteger:11]];
        upperRowViewIndex = 0;
        
        [self performSelector:@selector(runningStateDidEnd) withObject:nil afterDelay:self.delay + 12.0f];
    }
    
    while (resultLeftIndex < [left count] && resultRightIndex < [right count]){
        if ([left[resultLeftIndex] integerValue] <= [right[resultRightIndex] integerValue]) {
            [result addObject:left[resultLeftIndex]];
            
            UIView *view = self.views[[leftViewsIndices[leftViewIndex] integerValue]];
            [self performSelector:@selector(transitionToHiddenState:) withObject:view afterDelay:self.delay];
            
            UIView *viewToUpdate = self.views[upperRowViewIndex];
            NSArray *args = [[NSArray alloc] initWithObjects:viewToUpdate, left[resultLeftIndex], nil];
            [self performSelector:@selector(updateViewValue:) withObject:args afterDelay:self.delay];
            
            resultLeftIndex++;
            leftViewIndex++;
        } else {
            [result addObject:right[resultRightIndex]];
            
            UIView *view = self.views[[rightViewsIndices[rightViewIndex] integerValue]];
            [self performSelector:@selector(transitionToHiddenState:) withObject:view afterDelay:self.delay];
            
            UIView *viewToUpdate = self.views[upperRowViewIndex];
            NSArray *args = [[NSArray alloc] initWithObjects:viewToUpdate, right[resultRightIndex], nil];
            [self performSelector:@selector(updateViewValue:) withObject:args afterDelay:self.delay];
            
            resultRightIndex++;
            rightViewIndex++;
        }
        
        upperRowViewIndex++;
        self.delay += 2.0f;
    }
    
    while (resultLeftIndex < [left count]) {
        [result addObject:left[resultLeftIndex]];
        
        UIView *view = self.views[[leftViewsIndices[leftViewIndex] integerValue]];
        [self performSelector:@selector(transitionToHiddenState:) withObject:view afterDelay:self.delay];
        
        UIView *viewToUpdate = self.views[upperRowViewIndex];
        NSArray *args = [[NSArray alloc] initWithObjects:viewToUpdate, left[resultLeftIndex], nil];
        [self performSelector:@selector(updateViewValue:) withObject:args afterDelay:self.delay];
        
        leftViewIndex++;
        resultLeftIndex++;
        upperRowViewIndex++;
        self.delay += 2.0f;
    }
    
    while (resultRightIndex < [right count]) {
        [result addObject:right[resultRightIndex]];
        
        UIView *view = self.views[[rightViewsIndices[rightViewIndex] integerValue]];
        [self performSelector:@selector(transitionToHiddenState:) withObject:view afterDelay:self.delay];
        
        UIView *viewToUpdate = self.views[upperRowViewIndex];
        NSArray *args = [[NSArray alloc] initWithObjects:viewToUpdate, right[resultRightIndex], nil];
        [self performSelector:@selector(updateViewValue:) withObject:args afterDelay:self.delay];
        
        rightViewIndex++;
        resultRightIndex++;
        upperRowViewIndex++;
        self.delay += 2.0f;
    }
    
    self.step++;

    return result;
}

- (void)generateRandomNumbers {
    for (int i = 0; i < 6; i++) {
        NSNumber *randomValue = [NSNumber numberWithInteger:arc4random() % 99];
        
        [self.numbers addObject:randomValue];
    }
}

- (void)updateViewValue:(NSArray *)params {
    UIView *viewToUpdate = params[0];
    NSNumber *value = params[1];
    
    [UIView transitionWithView:viewToUpdate
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        UILabel *label = [[viewToUpdate subviews] firstObject];
                        [label setText:[NSString stringWithFormat:@"%@", value]];
                    }
                    completion:nil];
}

- (void)transitionToHiddenState:(UIView *)viewToHide {
    [UIView transitionWithView:viewToHide
                      duration:0.7f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [viewToHide setHidden:YES];
                    }
                    completion:nil];
}

- (void)transitionFromHiddenState:(NSMutableArray *)params {
    UIView *view = params[0];
    UILabel *label = params[1];
    NSNumber *number = params[2];
    
    [UIView transitionWithView:view
                      duration:0.7f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [view setHidden:NO];
                        [label setText:[NSString stringWithFormat:@"%@", number]];
                    }
                    completion:nil];
}

- (void)updateUI {
    for (int i = 0; i < [self.numbers count]; i++) {
        UIView *view = self.views[i];
        UILabel *label = [[view subviews] firstObject];
        [label setText:[NSString stringWithFormat:@"%@", self.numbers[i]]];
    }
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

- (NSMutableArray *)numbers {
    if (!_numbers) {
        _numbers = [[NSMutableArray alloc] init];
    }
    
    return _numbers;
}

#pragma Mark - Navigation

- (IBAction)popViewController:(UISwipeGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
