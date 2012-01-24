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
@property (nonatomic) int dot;
@property (nonatomic , strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize screen;
@synthesize userIsInTheMiddleOfTypingaNumber;
@synthesize dot;
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
    }
}

- (IBAction)c_pressed {
    self.screen.text = @"";
    self.display.text = @"0";
    [self.brain clear];
    self.userIsInTheMiddleOfTypingaNumber=NO;
}


- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.screen.text = [self.screen.text stringByAppendingString:@" "];
    self.screen.text = [self.screen.text stringByAppendingString:self.display.text];
    NSUInteger screen_length = [self.screen.text length];
    if (screen_length >= 20) self.screen.text = @"";
    self.userIsInTheMiddleOfTypingaNumber=NO;
    self.dot = 0;
}

- (IBAction)backspacePressed {
    NSString *lastDig = [NSString stringWithFormat:@"%C",[self.display.text characterAtIndex:([self.display.text length]-1)]];
    self.display.text = [self.display.text stringByReplacingCharactersInRange: [self.display.text rangeOfString:lastDig options:NSBackwardsSearch] withString:@""];
    if ([self.display.text length]==0){
        self.display.text=@"0";
        self.userIsInTheMiddleOfTypingaNumber=NO;
    }
}

- (IBAction)signPressed:(id)sender {
    NSString *firstChar = [NSString stringWithFormat:@"%C",[self.display.text characterAtIndex:0]];
    if([firstChar isEqualToString:@"-"])
        self.display.text = [self.display.text stringByReplacingCharactersInRange: [self.display.text rangeOfString:@"-"] withString:@""];
    else
        self.display.text = [@"-" stringByAppendingString:self.display.text];
}

-(IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfTypingaNumber){
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.screen.text = [self.screen.text stringByAppendingString:operation];
    self.screen.text = [self.screen.text stringByAppendingString:@" "];
    self.screen.text = [self.screen.text stringByAppendingString:@"="];
    self.display.text = [NSString stringWithFormat:@"%g" , result];
}

- (void)viewDidUnload {
    [self setScreen:nil];
    [super viewDidUnload];
}
@end
