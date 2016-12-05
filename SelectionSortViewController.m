//
//  SelectionSortViewController.m
//  Algorithms Playground
//
//  Created by Mincho Dzhagalov on 8/4/16.
//  Copyright © 2016 Mincho Dzhagalov. All rights reserved.
//

#import "SelectionSortViewController.h"

@interface SelectionSortViewController()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *views;
@property (weak, nonatomic) IBOutlet UIButton *runButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrowOne;
@property (weak, nonatomic) IBOutlet UIImageView *arrowTwo;

@property (nonatomic) NSMutableArray *numbers;
@property (nonatomic) CGFloat delay;
@end

@implementation SelectionSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self generateRandomNumbers];
    [self updateUI];
}

- (IBAction)run:(UIButton *)sender {
    [self runningStateDidBegin];
    
    CGRect arrowOneFrame = CGRectMake(
                                      [self.views[0] frame].origin.x,
                                      [self.views[0] frame].origin.y - 58,
                                      [self.views[0] frame].size.width,
                                      [self.views[0] frame].size.height
                                      );
    [self.arrowOne setFrame:arrowOneFrame];
    CGRect arrowTwoFrame = CGRectMake(
                                      [self.views[1] frame].origin.x,
                                      [self.views[1] frame].origin.y - 58,
                                      [self.views[1] frame].size.width,
                                      [self.views[1] frame].size.height
                                      );
    [self.arrowTwo setFrame:arrowTwoFrame];
    
    [UIView transitionWithView:self.arrowOne
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.arrowOne.hidden = NO;
                    }
                    completion:nil];
    
    [UIView transitionWithView:self.arrowTwo
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.arrowTwo.hidden = NO;
                    }
                    completion:nil];
    
    for (int i = 0; i < [self.numbers count] - 1; i++) {
        int minElementIndex = i;
        
        [UIView animateWithDuration:1.0f
                              delay:self.delay
             usingSpringWithDamping:3.0f
              initialSpringVelocity:1.0f
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             CGRect arrowOneFrame = CGRectMake(
                                                               [self.views[i] frame].origin.x,
                                                               [self.views[i] frame].origin.y - 58,
                                                               [self.views[i] frame].size.width,
                                                               [self.views[i] frame].size.height
                                                               );
                             [self.arrowOne setFrame:arrowOneFrame];
                             self.delay += 0.2f;
                         }
                         completion:nil];
        
        for (int j = i + 1; j < [self.numbers count]; j++) {
            [UIView animateWithDuration:1.0f
                                  delay:self.delay
                 usingSpringWithDamping:3.0f
                  initialSpringVelocity:1.0f
                                options:UIViewAnimationOptionTransitionCrossDissolve
                             animations:^{
                                 CGRect arrowTwoFrame = CGRectMake(
                                                                   [self.views[j] frame].origin.x,
                                                                   [self.views[j] frame].origin.y - 58,
                                                                   [self.views[j] frame].size.width,
                                                                   [self.views[j] frame].size.height
                                                                   );
                                 [self.arrowTwo setFrame:arrowTwoFrame];
                                 self.delay += 1.0f;
                             }
                             completion:nil];
            
            if ([self.numbers[j] integerValue] < [self.numbers[minElementIndex] integerValue]) {
                minElementIndex = j;
            }
        }
        
        if (minElementIndex != i) {
            NSNumber *old = self.numbers[i];
            self.numbers[i] = self.numbers[minElementIndex];
            self.numbers[minElementIndex] = old;
            
            NSMutableArray *mutableViews = [NSMutableArray arrayWithArray:self.views];
            id oldView = mutableViews[i];
            mutableViews[i] = mutableViews[minElementIndex];
            mutableViews[minElementIndex] = oldView;
            self.views = mutableViews;
            
            [UIView animateWithDuration:1.0f delay:self.delay options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                CGRect frameOne = [self.views[i] frame];
                CGRect frameTwo = [self.views[minElementIndex] frame];
                
                [self.views[i] setFrame:frameTwo];
                [self.views[minElementIndex] setFrame:frameOne];
                
                self.delay += 1.0f;
            } completion:^(BOOL finished) {
            }];
        }
        
        [UIView animateWithDuration:0.5f
                              delay:self.delay
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self.views[i] setBackgroundColor:[UIColor orangeColor]];
                             self.delay += 0.5f;
                         }
                         completion:nil];
    }
    
    [UIView animateWithDuration:0.5f
                          delay:self.delay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.arrowOne.alpha = 0.0f;
                         self.arrowTwo.alpha = 0.0f;
                         [self.views[[self.views count] - 1] setBackgroundColor:[UIColor orangeColor]];
                     }
                     completion:^(BOOL finished) {
                         [self runningStateDidEnd];
                     }];
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
    }
}

- (void)updateUI {
    for (int i = 0; i < [self.numbers count]; i++) {
        UILabel *label = [[self.views[i] subviews] firstObject];
        [label setText:[NSString stringWithFormat:@"%@", self.numbers[i]]];
    }
}

#pragma Mark - Lazy Instantiation

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
