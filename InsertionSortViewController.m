//
//  InsertionSortViewController.m
//  Algorithms Playground
//
//  Created by Mincho Dzhagalov on 7/12/16.
//  Copyright © 2016 Mincho Dzhagalov. All rights reserved.
//

#import "InsertionSortViewController.h"

@interface InsertionSortViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *views;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIButton *runButton;
@property (nonatomic) NSMutableArray *numbers;
@property (nonatomic) CGFloat delay;

@end

@implementation InsertionSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self GenerateRandomNumbers];
}

- (void)GenerateRandomNumbers {
    for (int i = 0; i < 6; i++) {
        NSNumber *randomValue = [NSNumber numberWithInteger:arc4random() % 99];
        [self.numbers addObject:randomValue];
        ((UILabel *)[[self.views[i] subviews] firstObject]).text = [NSString stringWithFormat:@"%@", randomValue];
    }
}

- (IBAction)run:(UIButton *)sender {
    [self runningStateDidBegin];
    
    CGRect arrow = CGRectMake(
                              [self.views[1] frame].origin.x,
                              [self.views[1] frame].origin.y - 58,
                              [self.views[1] frame].size.width,
                              [self.views[1] frame].size.height
                              );
    [self.arrow setFrame:arrow];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.views[0] setBackgroundColor:[UIColor yellowColor]];
    }];
    
    [UIView transitionWithView:self.arrow
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.arrow.hidden = NO;
                    }
                    completion:^(BOOL finished) {
                    }];
    
    for (int i = 1; i < [self.numbers count]; i++) {
        NSInteger j = i;
        
        [UIView animateWithDuration:1.0f delay:self.delay options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            UIView *currentView = self.views[i];
            CGRect arrowFrame = CGRectMake(
                                           currentView.frame.origin.x,
                                           currentView.frame.origin.y - 58,
                                           currentView.frame.size.width,
                                           currentView.frame.size.height);
            self.arrow.frame = arrowFrame;
            
            self.delay += 1.0f;
        } completion:^(BOOL finished) {
        }];
        
        while (j > 0 && [self.numbers[j - 1] integerValue] > [self.numbers[j] integerValue]) {
            NSNumber *old = self.numbers[j - 1];
            self.numbers[j - 1] = self.numbers[j];
            self.numbers[j] = old;
            
            // make a muttable copy of self.views, swap, replace self.views with the newly ordered array
            NSMutableArray *mutableViews = [NSMutableArray arrayWithArray:self.views];
            UIView *oldView = mutableViews[j - 1];
            mutableViews[j - 1] = mutableViews[j];
            mutableViews[j] = oldView;
            self.views = mutableViews;
            
            CGRect firstFrame = CGRectMake(
                                           ((UIView *)self.views[j - 1]).frame.origin.x,
                                           ((UIView *)self.views[j - 1]).frame.origin.y,
                                           ((UIView *)self.views[j - 1]).frame.size.width,
                                           ((UIView *)self.views[j - 1]).frame.size.height);
            CGRect secondFrame = CGRectMake(
                                            ((UIView *)self.views[j]).frame.origin.x,
                                            ((UIView *)self.views[j]).frame.origin.y,
                                            ((UIView *)self.views[j]).frame.size.width,
                                            ((UIView *)self.views[j]).frame.size.height);
            
            [UIView animateWithDuration:1.0f delay:self.delay options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.views[j - 1] setFrame:secondFrame];
                [self.views[j] setFrame:firstFrame];
                
                self.delay += 1.0f;
            } completion:^(BOOL finished) {
                
            }];
            
            j--;
        }
        
        [UIView animateWithDuration:0.5f
                              delay:self.delay
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self.views[j] setBackgroundColor:[UIColor yellowColor]];
                             self.delay += 0.5f;
                         }
                         completion:nil];
    }
    
    [UIView animateWithDuration:0.5f
                          delay:self.delay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.arrow.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         self.arrow.hidden = YES;
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
