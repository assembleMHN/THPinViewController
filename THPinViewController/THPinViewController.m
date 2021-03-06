//
//  THPinViewController.m
//  THPinViewController
//
//  Created by Thomas Heß on 11.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinViewController.h"
#import "THPinView.h"
#import "UIImage+ImageEffects.h"
#import "THLocalStringManager.h"

@interface THPinViewController () <THPinViewDelegate>

@property (nonatomic, strong) THPinView *pinView;
@property (nonatomic, strong) UIView *blurView;
@property (nonatomic, strong) NSArray *blurViewContraints;
@end

@implementation THPinViewController

- (instancetype)initWithDelegate:(id<THPinViewControllerDelegate>)delegate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _delegate = delegate;
        _backgroundColor = [UIColor whiteColor];
        _translucentBackground = NO;
    }
    return self;
}

- (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    return [self initWithDelegate:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithDelegate:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBlurView];
    
    self.pinView = [[THPinView alloc] initWithDelegate:self];
    
    self.pinView.promptTitle = [[THLocalStringManager sharedInstance] promptTitle];
    self.pinView.promptColor = self.promptColor;
    self.pinView.hideLetters = self.hideLetters;
    self.pinView.disableCancel = self.disableCancel;
    self.pinView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.pinView];
    // center pin view
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pinView attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f constant:0.0f]];
    CGFloat pinViewYOffset = 0.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        pinViewYOffset = -9.0f;
    } else {
        BOOL isFourInchScreen = (fabs(CGRectGetHeight([UIScreen mainScreen].bounds) - 568.0f) < DBL_EPSILON);
        if (isFourInchScreen) {
            pinViewYOffset = 25.5f;
        } else {
            pinViewYOffset = 18.5f;
        }
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pinView attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f constant:pinViewYOffset]];
}

#pragma mark - Properties

- (void)setPromptTitle:(NSString *)promptTitle
{
    if ([[[THLocalStringManager sharedInstance]promptTitle] isEqualToString:promptTitle]) {
        return;
    }
    [[THLocalStringManager sharedInstance] setPromptTitle:promptTitle];
    self.pinView.promptTitle = [[THLocalStringManager sharedInstance] promptTitle];
}


- (void)setCancelTitle:(NSString *)cancelTitle {
    if ([[[THLocalStringManager sharedInstance]titleCancel] isEqualToString:cancelTitle]) {
        return;
    }
    [[THLocalStringManager sharedInstance] setCancelTitle:cancelTitle];
}

- (void)setDeleteTitle:(NSString *)deleteTitle{
    if ([[[THLocalStringManager sharedInstance]titleDelete] isEqualToString:deleteTitle]) {
        return;
    }
    [[THLocalStringManager sharedInstance] setDeleteTitle:deleteTitle];
}

- (void)setPromptColor:(UIColor *)promptColor
{
    if ([self.promptColor isEqual:promptColor]) {
        return;
    }
    _promptColor = promptColor;
    self.pinView.promptColor = self.promptColor;
}

- (void)setHideLetters:(BOOL)hideLetters
{
    if (self.hideLetters == hideLetters) {
        return;
    }
    _hideLetters = hideLetters;
    self.pinView.hideLetters = self.hideLetters;
}

- (void)setDisableCancel:(BOOL)disableCancel
{
    if (self.disableCancel == disableCancel) {
        return;
    }
    _disableCancel = disableCancel;
    self.pinView.disableCancel = self.disableCancel;
}

#pragma mark - Blur

- (void)addBlurView
{
    self.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurEffectView];
}

#pragma mark - THPinViewDelegate

- (NSUInteger)pinLengthForPinView:(THPinView *)pinView
{
    NSUInteger pinLength = [self.delegate pinLengthForPinViewController:self];
    NSAssert(pinLength > 0, @"PIN length must be greater than 0");
    return MAX(pinLength, (NSUInteger)1);
}

- (BOOL)pinView:(THPinView *)pinView isPinValid:(NSString *)pin
{
    return [self.delegate pinViewController:self isPinValid:pin];
}

- (void)cancelButtonTappedInPinView:(THPinView *)pinView
{
    if ([self.delegate respondsToSelector:@selector(pinViewControllerWillDismissAfterPinEntryWasCancelled:)]) {
        [self.delegate pinViewControllerWillDismissAfterPinEntryWasCancelled:self];
    }
    [self dismissViewControllerAnimated:!_disableDismissAniamtion completion:^{
        if ([self.delegate respondsToSelector:@selector(pinViewControllerDidDismissAfterPinEntryWasCancelled:)]) {
            [self.delegate pinViewControllerDidDismissAfterPinEntryWasCancelled:self];
        }
    }];
}

- (void)correctPinWasEnteredInPinView:(THPinView *)pinView
{
    if ([self.delegate respondsToSelector:@selector(pinViewControllerWillDismissAfterPinEntryWasSuccessful:)]) {
        [self.delegate pinViewControllerWillDismissAfterPinEntryWasSuccessful:self];
    }
    [self dismissViewControllerAnimated:!_disableDismissAniamtion completion:^{
        if ([self.delegate respondsToSelector:@selector(pinViewControllerDidDismissAfterPinEntryWasSuccessful:)]) {
            [self.delegate pinViewControllerDidDismissAfterPinEntryWasSuccessful:self];
        }
    }];
}

- (void)incorrectPinWasEnteredInPinView:(THPinView *)pinView
{
    if ([self.delegate userCanRetryInPinViewController:self]) {
        if ([self.delegate respondsToSelector:@selector(incorrectPinEnteredInPinViewController:)]) {
            [self.delegate incorrectPinEnteredInPinViewController:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:)]) {
            [self.delegate pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:self];
        }
        [self dismissViewControllerAnimated:!_disableDismissAniamtion completion:^{
            if ([self.delegate respondsToSelector:@selector(pinViewControllerDidDismissAfterPinEntryWasUnsuccessful:)]) {
                [self.delegate pinViewControllerDidDismissAfterPinEntryWasUnsuccessful:self];
            }
        }];
    }
}

@end

