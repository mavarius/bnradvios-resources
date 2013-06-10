//
//  BNRViewController.h
//  Bugspray
//
//  Created by Michael Ward on 1/24/12.
//  Copyright (c) 2012 Big Nerd Ranch, Inc. All rights reserved.
//

typedef enum CalcOperation {
    CalcOperationNone = 0,
    CalcOperationSubtract = 1,
    CalcOperationAdd,
    CalcOperationDivide,
    CalcOperationMultiply
} CalcOperation;

@interface BNRViewController : UIViewController

@property (assign, nonatomic) float memValue;
@property (assign, nonatomic) float lcdValue;

@property (weak, nonatomic) IBOutlet UILabel *lcdLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *opButtons;

@property (assign, nonatomic) CalcOperation op;

- (IBAction)numberButtonPressed:(UIButton *)sender;

- (IBAction)calcClear:(UIButton *)sender;
- (IBAction)calcResolve:(UIButton *)sender;
- (IBAction)calcOperate:(UIButton *)sender;

@end
