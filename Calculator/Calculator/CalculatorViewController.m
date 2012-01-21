//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Konstantinos Mouzakitis on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfTypingaNumber;
@property (nonatomic) BOOL ppressed;
@property (nonatomic) int dot;
@property (nonatomic , strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize screen;
@synthesize userIsInTheMiddleOfTypingaNumber;
@synthesize dot;
@synthesize ppressed;
@synthesize brain = _brain;

-(CalculatorBrain *)brain
{
    if (!_brain){
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

-(IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    if ([digit isEqualToString:@"."]){
        self.dot++;
    }
    if (self.userIsInTheMiddleOfTypingaNumber){
        if ([digit isEqualToString:@"."]){
            if (self.dot<=1) self.display.text = [self.display.text stringByAppendingString:digit];
        }else self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfTypingaNumber=YES;
        self.ppressed = NO;
    }
}

- (IBAction)p_pressed {
    self.ppressed=YES;
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self.brain pushOperand:M_PI];
    self.screen.text = [self.screen.text stringByAppendingString:@" "];
    self.screen.text = [self.screen.text stringByAppendingString:self.display.text];
    self.screen.text = [self.screen.text stringByAppendingString:@" "];
    self.display.text = [NSString stringWithFormat:@"%g" , M_PI];
    self.screen.text = [self.screen.text stringByAppendingString:self.display.text];
    self.userIsInTheMiddleOfTypingaNumber=NO;
    self.dot = 0;
}


- (IBAction)c_pressed {
    self.screen.text = @"";
    self.display.text = @"0";
    [self.brain clear];
    self.userIsInTheMiddleOfTypingaNumber=NO;
}


- (IBAction)enterPressed {
    if (!self.ppressed) {
        [self.brain pushOperand:[self.display.text doubleValue]];
        self.screen.text = [self.screen.text stringByAppendingString:@" "];
        self.screen.text = [self.screen.text stringByAppendingString:self.display.text];
    }
    NSUInteger screen_length = [self.screen.text length];
    if (screen_length >= 20) self.screen.text = @"";
    self.userIsInTheMiddleOfTypingaNumber=NO;
    self.ppressed=NO;
    self.dot = 0;
}


-(IBAction)operationPressed:(UIButton *)sender
{
    if ((self.userIsInTheMiddleOfTypingaNumber)||(self.ppressed)){
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.screen.text = [self.screen.text stringByAppendingString:@" "];
    self.screen.text = [self.screen.text stringByAppendingString:operation];
    self.display.text = [NSString stringWithFormat:@"%g" , result];
}

- (void)viewDidUnload {
    [self setScreen:nil];
    [super viewDidUnload];
}
@end
