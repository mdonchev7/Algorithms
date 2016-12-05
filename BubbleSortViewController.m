//
//  BubbleSortViewController.m
//  Algorithms Playground
//
//  Created by Mincho Dzhagalov on 7/29/16.
//  Copyright © 2016 Mincho Dzhagalov. All rights reserved.
//

#import "BubbleSortViewController.h"


@interface BubbleSortViewController ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *views;
@property (weak, nonatomic) IBOutlet UIImageView *arrowOne;
@property (weak, nonatomic) IBOutlet UIImageView *arrowTwo;
@property (weak, nonatomic) IBOutlet UIButton *runButton;

@property (nonatomic) NSMutableArray *numbers;
@property (nonatomic) CGFloat delay;
@end

@implementation BubbleSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self generateRandomNumbers];
}

- (IBAction)run:(UIButton *)sender {
    [self runningStateDidBegin];
    
    CGRect arrowOneFrame = CGRectMake(
                                      [self.views[0] frame].origin.x,
                                      [self.views[0] frame].origin.y - 58,
                                      [self.views[0] frame].size.width,
                                      [self.views[0] frame].size.height
                                      );
    [self.arrowTwo setFrame:arrowOneFrame];
    CGRect arrowTwoFrame = CGRectMake(
                                      [self.views[1] frame].origin.x,
                                      [self.views[1] frame].origin.y - 58,
                                      [self.views[1] frame].size.width,
                                      [self.views[1] frame].size.height
                                      );
    [self.arrowOne setFrame:arrowTwoFrame];
    
    [UIView transitionWithView:self.arrowOne
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.arrowOne.hidden = NO;
                    }
                    completion:^(BOOL finished) {
                    }];
    [UIView transitionWithView:self.arrowTwo
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.arrowTwo.hidden = NO;
                    }
                    completion:^(BOOL finished) {
                    }];
    
    while (true) {
        BOOL didSwap = NO;
        
        for (int i = 1; i < [self.numbers count]; i++) {
            [self moveArrowsAt:i - 1 And:i];
            
            if ([self.numbers[i -1] integerValue] > [self.numbers[i] integerValue]) {
                id old = self.numbers[i - 1];
                self.numbers[i - 1] = self.numbers[i];
                self.numbers[i] = old;
                
                didSwap = YES;
                
                NSMutableArray *mutableViews = [NSMutableArray arrayWithArray:self.views];
                id oldView = mutableViews[i - 1];
                mutableViews[i  - 1] = mutableViews[i];
                mutableViews[i] = oldView;
                self.views = mutableViews;
                
                [UIView animateWithDuration:1.0f delay:self.delay options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    CGRect frameOne = [self.views[i - 1] frame];
                    CGRect frameTwo = [self.views[i] frame];
                    
                    [self.views[i - 1] setFrame:frameTwo];
                    [self.views[i] setFrame:frameOne];
                    
                    self.delay += 1.0f;
                } completion:^(BOOL finished) {
                }];
            }
        }
        
        if (!didSwap) {
            [UIView animateWithDuration:0.5f
                                  delay:self.delay
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 self.arrowOne.alpha = 0.0f;
                                 self.arrowTwo.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self runningStateDidEnd];
                                 self.arrowOne.hidden = YES;
                                 self.arrowTwo.hidden = YES;
                             }];
            
            break;
        }
    }
}

- (void)moveArrowsAt:(NSInteger)leftIndex And:(NSInteger)rightIndex {
    CGRect leftArrowFrame = CGRectMake(
                                      [self.views[leftIndex] frame].origin.x,
                                      [self.views[leftIndex] frame].origin.y - 58,
                                      [self.views[leftIndex] frame].size.width,
                                      [self.views[leftIndex] frame].size.height);
    CGRect rightArrowFrame = CGRectMake(
                                      [self.views[rightIndex] frame].origin.x,
                                      [self.views[rightIndex] frame].origin.y - 58,
                                      [self.views[rightIndex] frame].size.width,
                                      [self.views[rightIndex] frame].size.height);
    
    if (leftIndex == 1) { // arrows are moving from left to right
        [UIView animateWithDuration:1.0f
                              delay:self.delay
             usingSpringWithDamping:3
              initialSpringVelocity:1
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             [self.arrowOne setFrame:rightArrowFrame];
                             
                             self.delay += 0.1f;
                         } completion:nil];
        [UIView animateWithDuration:1.0f
                              delay:self.delay
             usingSpringWithDamping:3
              initialSpringVelocity:1
                            options:UIViewAnimationOptionTransitionFlipFromTop
                         animations:^{
                             [self.arrowTwo setFrame:leftArrowFrame];
                             
                             self.delay += 1.0f;
                         }
                         completion:nil];
    } else { // arrows are moving from right to left
        [UIView animateWithDuration:1.0f
                              delay:self.delay
             usingSpringWithDamping:3
              initialSpringVelocity:1
                            options:UIViewAnimationOptionTransitionFlipFromTop
                         animations:^{
                             [self.arrowTwo setFrame:leftArrowFrame];
                             
                             self.delay += 0.1f;
                         } completion:nil];
        
        [UIView animateWithDuration:1.0f
                              delay:self.delay
             usingSpringWithDamping:3
              initialSpringVelocity:1
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             [self.arrowOne setFrame:rightArrowFrame];
                             
                             self.delay += 1.0f;
                         } completion:nil];
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

- (void)generateRandomNumbers {
    for (int i = 0; i < [self.views count]; i++) {
        NSNumber *randomValue = [NSNumber numberWithInteger:arc4random() % 99];
        
        [self.numbers addObject:randomValue];
        ((UILabel *)[[self.views[i] subviews] firstObject]).text = [NSString stringWithFormat:@"%@", randomValue];
    }
}

- (NSMutableArray *)numbers
{
    if (!_numbers){
        _numbers = [[NSMutableArray alloc] init];
    }
    
    return _numbers;
}

#pragma Mark - Navigation

- (IBAction)popViewController:(UISwipeGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
