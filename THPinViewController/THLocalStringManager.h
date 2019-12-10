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
@property (nonatomic, copy, nullable) NSString *promptTitle;
@property (nonatomic, copy, nullable) NSString *titleCancel;
@property (nonatomic, copy, nullable) NSString *titleDelete;

+ (id)sharedInstance;

@end

NS_ASSUME_NONNULL_END
