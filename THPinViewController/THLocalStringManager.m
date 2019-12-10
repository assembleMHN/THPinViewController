//
//  THLocalStringManager.m
//  THPinViewControllerExample
//
//  Created by Morten Hjortshøj Nielsen on 10/12/2019.
//  Copyright © 2019 Thomas Heß. All rights reserved.
//

#import "THLocalStringManager.h"

@implementation THLocalStringManager

+ (id)sharedInstance {
    static THLocalStringManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (id)init {
    if (self = [super init]) {
        // write your code here
    }
    return self;
}

@end
