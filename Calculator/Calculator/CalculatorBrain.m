//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Konstantinos Mouzakitis on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain() 
@property (nonatomic,strong) NSMutableArray *programStack;
@property (nonatomic,strong) NSDictionary *variableValues;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize variableValues = _variableValues;

-(NSMutableArray *) programStack{
    if (!_programStack){
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

-(NSDictionary *) variableValues{
    if (!_variableValues)
        _variableValues = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"12",@"x",@"5",@"y",@"15",@"z",nil];
    return _variableValues;
}

-(void)pushOperand:(double)operand{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

-(void)pushVariable:(NSString *)variable{
    [self.programStack addObject:variable];
}

-(void)clear{
    [self.programStack removeAllObjects];
}

-(double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program usingVariablesValues:self.variableValues];
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *) descriptionOfProgram:(id)program
{
    return @"askisi 2";
}

+ (double) popOperandOffStack:(NSMutableArray *)stack
{
    double result =0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
        result = [topOfStack doubleValue];
    else if ([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"*"]){
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]){
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]){
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sqrt"]){
            result = sqrt([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"π"]){
            result = M_PI;
        }
    }
    
    return result;
}

+ (double) runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
    return [self popOperandOffStack:stack];
}

+ (double) runProgram:(id)program usingVariablesValues:(NSDictionary *)variableValues{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
    for(int i=0;i<[stack count];i++){
        if ([[variableValues allKeys] containsObject:[stack objectAtIndex:i]]){
            [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:[[variableValues valueForKey:[stack objectAtIndex:i]] doubleValue]]];
        }
    }
    return [self popOperandOffStack:stack];
}

@end
