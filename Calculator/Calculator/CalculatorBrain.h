//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Konstantinos Mouzakitis on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void)pushOperand:(double)operand;
-(void)pushVariable:(NSString *)variable;
-(double)performOperation:(NSString *)operation;
-(void)clear;

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariablesValues:(NSDictionary *)variableValues;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end
