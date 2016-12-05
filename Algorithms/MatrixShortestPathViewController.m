#import "MatrixShortestPathViewController.h"
#import "Dijkstra.h"

static NSInteger const rowsCount = 6;
static NSInteger const columnsCount = 4;
static NSInteger const cellsCount = rowsCount * columnsCount;
static NSInteger const startNode = 0;
static NSInteger const endNode = 23;

@interface MatrixShortestPathViewController ()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (weak, nonatomic) IBOutlet UIButton *runButton;

@property (nonatomic) CGFloat delay;
@property (nonatomic) NSMutableArray *matrix;

@end

@implementation MatrixShortestPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.matrix = [self randomNumbers];
    [self updateUI];
}

- (IBAction)run:(UIButton *)sender {
    [self runningStateDidBegin];
    
    NSMutableArray *graph = [self buildGraph];
    
    NSArray *pathByIndices = [Dijkstra FindShortestPathIn:graph fromNode:startNode toNode:endNode];
    
    NSInteger labelIndex = 0;
    
    for (UILabel *label in self.labels) {
        if ([pathByIndices containsObject:[NSNumber numberWithInteger:labelIndex]]) {
            [UILabel animateWithDuration:0.5f delay:self.delay options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [label.superview.layer setBackgroundColor:[[UIColor lightGrayColor] CGColor]];
                
                self.delay += 0.5;
            } completion:^(BOOL finished) {
            }];
        }
        
        labelIndex++;
    }
    
    [self performSelector:@selector(runningStateDidEnd) withObject:nil afterDelay:self.delay];
}

- (NSMutableArray *)buildGraph {
    NSMutableArray *graph = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < cellsCount; i++) {
        graph[i] = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < cellsCount; j++) {
            graph[i][j] = [NSNumber numberWithInt:-1];
        }
    }
    
    NSInteger nodeIndex = 0;
    
    for (int row = 0; row < rowsCount; row++)
    {
        for (int column = 0; column < columnsCount; column++)
        {
            if (row - 1 >= 0)
            {
                NSNumber *north = self.matrix[row - 1][column];
                graph[nodeIndex][nodeIndex - columnsCount] = north;
            }
            if (column + 1 < columnsCount)
            {
                NSNumber *east = self.matrix[row][column + 1];
                graph[nodeIndex][nodeIndex + 1] = east;
            }
            if (row + 1 < rowsCount)
            {
                NSNumber *south = self.matrix[row + 1][column];
                graph[nodeIndex][nodeIndex + columnsCount] = south;
            }
            if (column - 1 >= 0)
            {
                NSNumber *west = self.matrix[row][column - 1];
                graph[nodeIndex][nodeIndex - 1] = west;
            }
            
            nodeIndex++;
        }
    }
    
    return graph;
}

- (void)updateUI {
    NSInteger rowIndex = 0;
    NSInteger columnIndex = 0;
    
    for (int labelIndex = 0; labelIndex < [self.labels count]; labelIndex++) {
        [self.labels[labelIndex] setText:[NSString stringWithFormat:@"%@", self.matrix[rowIndex][columnIndex]]];
        
        columnIndex++;
        
        if (columnIndex == 4) {
            rowIndex++;
            columnIndex = 0;
        }
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

- (NSMutableArray *)randomNumbers {
    NSMutableArray *matrix = [[NSMutableArray alloc] init];
    
    for (int row = 0; row < rowsCount; row++) {
        NSMutableArray *rowArray = [[NSMutableArray alloc] init];
        
        for (int column = 0; column < columnsCount; column++) {
            NSNumber *randomNumber = [NSNumber numberWithInt:1 + arc4random() % (100 - 1)];
            [rowArray addObject:randomNumber];
        }
        
        [matrix addObject:rowArray];
    }
    
    return matrix;
}

#pragma Mark - Navigation

- (IBAction)popViewController:(UISwipeGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
