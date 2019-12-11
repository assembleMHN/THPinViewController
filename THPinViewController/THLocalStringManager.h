//
//  THLocalStringManager.h
//  THPinViewControllerExample
//
//  Created by Morten Hjortshøj Nielsen on 10/12/2019.
//  Copyright © 2019 Thomas Heß. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THLocalStringManager : NSObject
@property (nonatomic, assign) NSString *promptTitle;
@property (nonatomic, assign) NSString *titleCancel;
@property (nonatomic, assign) NSString *titleDelete;

+ (id)sharedInstance;

@end

NS_ASSUME_NONNULL_END
