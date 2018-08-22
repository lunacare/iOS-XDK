//
//  LYRUIMessageViewController.h
//  Layer-XDK-UI-iOS
//
//  Created by Klemen Verdnik on 6/12/18.
//  Copyright (c) 2018 Layer. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "LYRUIMessageViewController.h"
#import "LYRUIMessageSerializer.h"
#import "LYRUIConfiguration+DependencyInjection.h"
#import "LYRUILargeMessageItemContentPresentersProvider.h"
#import "LYRUIMessageItemViewPresenter.h"
#import "LYRUIMessageItemView.h"
#import "LYRUIMediaMessage.h"
#import "UIView+LYRUISafeArea.h"
#import "LYRUIBaseMessageTypeSerializer.h"

@interface LYRUIMessageViewController () <LYRQueryControllerDelegate>

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) LYRUIMessageSerializer *messageSerializer;
@property (nonatomic, readonly) LYRUILargeMessageItemContentPresentersProvider *contentPresentersProvider;
@property (nonatomic, readonly) LYRUIMessageItemView *messageView;
@property (nonatomic, readonly) UILabel *noMessageLabel;
@property (nonatomic, readwrite) LYRQueryController *queryController;
@property (nonatomic, readwrite) NSArray<NSLayoutConstraint *> *constraints;
@property (nonatomic, readwrite) LYRMessagePart *messagePart;

@end

@implementation LYRUIMessageViewController

@synthesize layerConfiguration = _layerConfiguration;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (instancetype)initWithConfiguration:(LYRUIConfiguration *)configuration {
    self = [super init];
    if (self) {
        _layerConfiguration = configuration;
        _messageSerializer = [configuration.injector objectOfType:[LYRUIMessageSerializer class]];
        _contentPresentersProvider = [configuration.injector objectOfType:[LYRUILargeMessageItemContentPresentersProvider class]];
        [self lyr_commonInit];
    }
    return self;
}

- (void)lyr_commonInit {
    _noMessageLabel = [[UILabel alloc] initWithFrame:self.view.frame];
    _noMessageLabel.text = @"no message";
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Failed to call designated initializer. Call '%@' instead.", NSStringFromSelector(@selector(initWithConfiguration:))] userInfo:nil];
}

- (void)setLayerConfiguration:(LYRUIConfiguration *)layerConfiguration {
    _layerConfiguration = layerConfiguration;
    _messageSerializer = [layerConfiguration.injector objectOfType:[LYRUIMessageSerializer class]];
    _contentPresentersProvider = [layerConfiguration.injector objectOfType:[LYRUILargeMessageItemContentPresentersProvider class]];
}

- (void)loadView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.scrollEnabled = YES;
    _scrollView.backgroundColor = [UIColor colorWithWhite:242.0/255.0 alpha:1.0];
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.view = _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didTapDone:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    LYRQuery *messagePartQuery = [LYRQuery queryWithQueryableClass:LYRMessagePart.class];
    messagePartQuery.predicate = [LYRPredicate predicateWithProperty:@"identifier" predicateOperator:LYRPredicateOperatorIsEqualTo value:self.messagePartID];
    NSOrderedSet<LYRMessagePart *> *messageParts = [self.layerConfiguration.client executeQuery:messagePartQuery error:nil];
    if (!messageParts && messageParts.count == 0) {
        self.messagePart = nil;
        return;
    }
    self.messagePart = messageParts.firstObject;
    LYRQuery *messageQuery = [LYRQuery queryWithQueryableClass:LYRMessage.class];
    messageQuery.predicate = [LYRPredicate predicateWithProperty:@"identifier" predicateOperator:LYRPredicateOperatorIsEqualTo value:self.messagePart.message.identifier];
    self.queryController = [self.layerConfiguration.client queryControllerWithQuery:messageQuery error:nil];
    self.queryController.delegate = self;
    [self.queryController execute:nil];
}

- (void)didTapDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateMessageView {
    for (UIView *subview in self.scrollView.subviews.copy) {
        [subview removeFromSuperview];
    }
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    LYRUIMessageType *typedMessage;
    if (self.messagePart != nil) {
        id<LYRUIMessageTypeSerializing> messagePartSerializer = [self.layerConfiguration.injector serializerForMessagePartMIMEType:[self.messagePart.MIMEType componentsSeparatedByString:@";"].firstObject];
        typedMessage = [messagePartSerializer typedMessageWithMessagePart:self.messagePart];
        if (!typedMessage) {
            typedMessage = [self.messageSerializer typedMessageWithLayerMessage:self.messagePart.message];
        }
    }
    if (!typedMessage) {
        self.noMessageLabel.frame = self.scrollView.frame;
        [self.scrollView addSubview:self.noMessageLabel];
        return;
    }
    self.navigationItem.title = @"Preview";
    id<LYRUIMessageItemContentPresenting> presenter = [self.contentPresentersProvider presenterForMessageClass:[typedMessage class]];
    presenter.actionHandlingDelegate = self.actionHandlingDelegate;
    UIEdgeInsets safeArea = self.navigationController ? self.navigationController.view.lyr_safeAreaInsets : self.scrollView.lyr_safeAreaInsets;
    UIView *messageView = [presenter viewForMessage:typedMessage];
    messageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    messageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - safeArea.bottom);
    messageView.translatesAutoresizingMaskIntoConstraints = YES;
    messageView.autoresizesSubviews = YES;
    [self.scrollView addSubview:messageView];
    self.scrollView.contentSize = messageView.frame.size;
}

#pragma mark - LYRQueryControllerDelegate Implementation

- (void)queryControllerDidChangeContent:(LYRQueryController *)queryController {
    [self updateMessageView];
}

#pragma mark - Keyboard Appearance Handling

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.scrollIndicatorInsets = contentInsets;
    self.scrollView.contentInset = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
