//
//  MenuViewController.m
//  Algorithms Playground
//
//  Created by Mincho Dzhagalov on 8/3/16.
//  Copyright © 2016 Mincho Dzhagalov. All rights reserved.
//

#import "MenuViewController.h"
#import "BubbleSortViewController.h"

@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *bubbleSortView;
@property (weak, nonatomic) IBOutlet UIView *insertionSortView;
@property (weak, nonatomic) IBOutlet UIView *shortestPathInMatrixView;
@property (weak, nonatomic) IBOutlet UIView *shotestPathInGraphView;

@end

@implementation MenuViewController

- (IBAction)presentBubbleSortViewController:(UITapGestureRecognizer *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BubbleSortViewController *bsvc = [sb instantiateViewControllerWithIdentifier:@"Bubble Sort View Controller"];
    [self.navigationController pushViewController:bsvc animated:YES];
}

- (IBAction)presentInsertionSortViewController:(UITapGestureRecognizer *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BubbleSortViewController *isvc = [sb instantiateViewControllerWithIdentifier:@"Insertion Sort View Controller"];
    [self.navigationController pushViewController:isvc animated:YES];
}

- (IBAction)presentMergeSortViewController:(UITapGestureRecognizer *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BubbleSortViewController *isvc = [sb instantiateViewControllerWithIdentifier:@"Merge Sort View Controller"];
    [self.navigationController pushViewController:isvc animated:YES];
}

- (IBAction)presentSelectionSortViewController:(UITapGestureRecognizer *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BubbleSortViewController *isvc = [sb instantiateViewControllerWithIdentifier:@"Selection Sort View Controller"];
    [self.navigationController pushViewController:isvc animated:YES];
}

- (IBAction)presentShortestPathInMatrixViewController:(UITapGestureRecognizer *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BubbleSortViewController *spmvs = [sb instantiateViewControllerWithIdentifier:@"Shortest Path In Matrix View Controller"];
    [self.navigationController pushViewController:spmvs animated:YES];
}
- (IBAction)presentShortestPathInGraphViewController:(UITapGestureRecognizer *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BubbleSortViewController *spgvc = [sb instantiateViewControllerWithIdentifier:@"Shortest Path In Graph View Controller"];
    [self.navigationController pushViewController:spgvc animated:YES];
}

@end