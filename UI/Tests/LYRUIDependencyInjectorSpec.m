#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LayerXDK/LYRUIDependencyInjector.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIPresenceView.h>
#import <LayerXDK/LYRUIPresenceViewDefaultTheme.h>
#import <LayerXDK/LYRUIPresenceViewPresenter.h>
#import <LayerXDK/LYRUIAvatarView.h>
#import <LayerXDK/LYRUIAvatarViewDefaultTheme.h>
#import <LayerXDK/LYRUIAvatarViewPresenter.h>
#import <LayerXDK/LYRUIImageWithLettersView.h>
#import <LayerXDK/LYRUIImageWithLettersViewPresenter.h>
#import <LayerXDK/LYRUIBaseItemView.h>
#import <LayerXDK/LYRUIBaseItemViewDefaultTheme.h>
#import <LayerXDK/LYRUIBaseItemViewLayout.h>
#import <LayerXDK/LYRUIConversationItemView.h>
#import <LayerXDK/LYRUIConversationItemViewUnreadTheme.h>
#import <LayerXDK/LYRUIConversationItemViewPresenter.h>
#import <LayerXDK/LYRUIConversationItemTitleFormatter.h>
#import <LayerXDK/LYRUIMessageTimeDefaultFormatter.h>
#import <LayerXDK/LYRUIConversationListView.h>
#import <LayerXDK/LYRUIConversationListViewPresenter.h>
#import <LayerXDK/LYRUIListCellPresenter.h>
#import <LayerXDK/LYRUIListHeaderView.h>
#import <LayerXDK/LYRUIListSupplementaryViewPresenter.h>
#import <LayerXDK/LYRUIListLayout.h>
#import <LayerXDK/LYRUIIdentityItemView.h>
#import <LayerXDK/LYRUIIdentityItemViewPresenter.h>
#import <LayerXDK/LYRUIIdentityNameFormatter.h>
#import <LayerXDK/LYRUITimeAgoFormatter.h>
#import <LayerXDK/LYRUIIdentityListView.h>
#import <LayerXDK/LYRUIIdentityListViewPresenter.h>
#import <LayerXDK/LYRUIImageFetcher.h>
#import <LayerXDK/LYRUIImageFactory.h>
#import <LayerXDK/LYRUIInitialsFormatter.h>
#import <LayerXDK/LYRUIDataFactory.h>
#import <LayerXDK/LYRUIDispatcher.h>
#import <LayerXDK/NSCache+LYRUIImageCaching.h>
#import <LayerXDK/LYRUIComposeBar.h>
#import <LayerXDK/LYRUIComposeBarPresenter.h>
#import <LayerXDK/LYRUIAvatarViewProvider.h>
#import <LayerXDK/LYRUIMessageItemView.h>
#import <LayerXDK/LYRUIMessageItemViewLayout.h>
#import <LayerXDK/LYRUIMessageItemViewPresenter.h>
#import <LayerXDK/LYRUIMessageItemAccessoryViewProviding.h>
#import <LayerXDK/LYRUIMessageCollectionViewCell.h>
#import <LayerXDK/LYRUIMessageCellPresenter.h>
#import <LayerXDK/LYRUIMessageListMessageTimeView.h>
#import <LayerXDK/LYRUIMessageListMessageTimeViewLayout.h>
#import <LayerXDK/LYRUIMessageListTimeSupplementaryViewPresenter.h>
#import <LayerXDK/LYRUIMessageListMessageStatusView.h>
#import <LayerXDK/LYRUIMessageListMessageStatusViewLayout.h>
#import <LayerXDK/LYRUIMessageListStatusSupplementaryViewPresenter.h>
#import <LayerXDK/LYRUIListLoadingIndicatorView.h>
#import <LayerXDK/LYRUIListLoadingIndicatorPresenter.h>
#import <LayerXDK/LYRUIMessageListView.h>
#import <LayerXDK/LYRUIMessageListLayout.h>
#import <LayerXDK/LYRUIMessageListViewPresenter.h>
#import <LayerXDK/LYRUIMessageListTimeFormatter.h>
#import <LayerXDK/LYRUIConversationView.h>
#import <LayerXDK/LYRUIConversationViewLayout.h>
#import <LayerXDK/LYRUIPanelTypingIndicatorView.h>
#import <LayerXDK/LYRUIPanelTypingIndicatorViewLayout.h>
#import <LayerXDK/LYRUITypingIndicatorFooterPresenter.h>
#import <LayerXDK/LYRUIBubbleTypingIndicatorCollectionViewCell.h>
#import <LayerXDK/LYRUITypingIndicatorCellPresenter.h>
#import <LayerXDK/LYRUIReusableViewsQueue.h>
#import "LYRUIFakeTestMessage.h"
#import "LYRUIFakeImageMessage.h"
#import "LYRUIFakeTestMessageSerializer.h"
#import "LYRUIFakeTestMessagePresenter.h"
#import "LYRUIFakeTestMessageContainerPresenter.h"
#import "LYRUIFakeTestActionHandler.h"
#import <LayerXDK/LYRUITextMessage.h>
#import <LayerXDK/LYRUITextMessageSerializer.h>
#import <LayerXDK/LYRUITextMessageContentViewPresenter.h>
#import <LayerXDK/LYRUIStandardMessageContainerViewPresenter.h>
#import <LayerXDK/LYRUIStandardMessageContainerView.h>
#import <LayerXDK/LYRUIStandardMessageContainerViewLayout.h>
#import <LayerXDK/LYRUIStandardMessageContainerViewDefaultTheme.h>
#import <LayerXDK/LYRUIFileMessage.h>
#import <LayerXDK/LYRUIFileMessageSerializer.h>
#import <LayerXDK/LYRUIFileMessageContentViewPresenter.h>
#import <LayerXDK/LYRUIMessageOpenFileActionHandler.h>
#import <LayerXDK/LYRUILinkMessage.h>
#import <LayerXDK/LYRUILinkMessageSerializer.h>
#import <LayerXDK/LYRUILinkMessageContentViewPresenter.h>
#import <LayerXDK/LYRUILinkMessageContainerViewPresenter.h>
#import <LayerXDK/LYRUIMessageOpenURLActionHandler.h>
#import <LayerXDK/LYRUIImageMessage.h>
#import <LayerXDK/LYRUIImageMessageSerializer.h>
#import <LayerXDK/LYRUIImageMessageContentViewPresenter.h>
#import <LayerXDK/LYRUILocationMessage.h>
#import <LayerXDK/LYRUILocationMessageSerializer.h>
#import <LayerXDK/LYRUILocationMessageContentViewPresenter.h>
#import <LayerXDK/LYRUIMessageOpenMapActionHandler.h>
#import <LayerXDK/LYRUIStatusMessageCollectionViewCell.h>
#import <LayerXDK/LYRUIStatusCellPresenter.h>
#import <LayerXDK/LYRUIStatusMessage.h>
#import <LayerXDK/LYRUIStatusMessageSerializer.h>
#import <LayerXDK/LYRUIResponseMessage.h>
#import <LayerXDK/LYRUIResponseMessageSerializer.h>
#import <LayerXDK/LYRUIButtonsMessage.h>
#import <LayerXDK/LYRUIButtonsMessageSerializer.h>
#import <LayerXDK/LYRUIButtonsMessageCompositeViewPresenter.h>
#import <LayerXDK/LYRUIChoiceMessage.h>
#import <LayerXDK/LYRUIChoiceMessageSerializer.h>
#import <LayerXDK/LYRUIChoiceMessageCompositeViewPresenter.h>
#import <LayerXDK/LYRUIProductMessage.h>
#import <LayerXDK/LYRUIProductMessageSerializer.h>
#import <LayerXDK/LYRUIProductMessageCompositeViewPresenter.h>
#import <LayerXDK/LYRUIReceiptMessage.h>
#import <LayerXDK/LYRUIReceiptMessageSerializer.h>
#import <LayerXDK/LYRUIReceiptMessageCompositeViewPresenter.h>
#import <LayerXDK/LYRUICarouselMessage.h>
#import <LayerXDK/LYRUICarouselMessageSerializer.h>
#import <LayerXDK/LYRUICarouselMessageCompositeViewPresenter.h>
#import <LayerXDK/LYRUICarouselMessageListView.h>
#import <LayerXDK/LYRUICarouselMessageListViewPresenter.h>
#import <LayerXDK/LYRUICarouselContentOffsetHandler.h>
#import <LayerXDK/LYRUICarouselContentOffsetsCache.h>
#import <LayerXDK/LYRUIMessageListViewPreviewingDelegate.h>

SpecBegin(LYRUIDependencyInjector)

describe(@"LYRUIDependencyInjector", ^{
    __block LYRUIConfiguration *configurationMock;
    __block LYRUIDependencyInjector *injector;

    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injector = [[LYRUIDependencyInjector alloc] init];
        injector.layerConfiguration = configurationMock;
    });

    afterEach(^{
        injector = nil;
    });

    describe(@"themeForViewClass:", ^{
        __block id returnedObject;
        
        context(@"for LYRUIPresenceView", ^{
            beforeEach(^{
                returnedObject = [injector themeForViewClass:[LYRUIPresenceView class]];
            });
            
            it(@"should return theme conforming to `LYRUIPresenceViewTheme` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIPresenceViewTheme));
            });
        });
        
        context(@"for LYRUIAvatarView", ^{
            beforeEach(^{
                returnedObject = [injector themeForViewClass:[LYRUIAvatarView class]];
            });
            
            it(@"should return theme conforming to `LYRUIAvatarViewTheme` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIAvatarViewTheme));
            });
        });
        
        context(@"for LYRUIConversationItemView", ^{
            beforeEach(^{
                returnedObject = [injector themeForViewClass:[LYRUIConversationItemView class]];
            });
            
            it(@"should return theme conforming to `LYRUIBaseItemViewTheme` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIBaseItemViewTheme));
            });
        });
        
        context(@"for LYRUIIdentityItemView", ^{
            beforeEach(^{
                returnedObject = [injector themeForViewClass:[LYRUIIdentityItemView class]];
            });
            
            it(@"should return theme conforming to `LYRUIBaseItemViewTheme` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIBaseItemViewTheme));
            });
        });
        
        context(@"for LYRUIStandardMessageContainerView", ^{
            beforeEach(^{
                returnedObject = [injector themeForViewClass:[LYRUIStandardMessageContainerView class]];
            });
            
            it(@"should return theme conforming to `LYRUIStandardMessageContainerViewTheme` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIStandardMessageContainerViewTheme));
            });
        });
    });
    
    describe(@"alternativeThemeForViewClass:", ^{
        __block id returnedObject;
        
        context(@"for LYRUIConversationItemView", ^{
            beforeEach(^{
                returnedObject = [injector alternativeThemeForViewClass:[LYRUIConversationItemView class]];
            });
            
            it(@"should return theme conforming to `LYRUIBaseItemViewTheme` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIBaseItemViewTheme));
            });
        });
    });
    
    describe(@"presenterForViewClass:", ^{
        __block id returnedObject;
        
        context(@"for LYRUIPresenceView", ^{
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIPresenceView class]];
            });
            
            it(@"should return presenter of `LYRUIPresenceViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIPresenceViewPresenter class]);
            });
        });
        
        context(@"for LYRUIAvatarView", ^{
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIAvatarView class]];
            });
            
            it(@"should return presenter of `LYRUIAvatarViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIAvatarViewPresenter class]);
            });
        });
        
        context(@"for LYRUIImageWithLettersView", ^{
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIImageWithLettersView class]];
            });
            
            it(@"should return presenter of `LYRUIImageWithLettersViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIImageWithLettersViewPresenter class]);
            });
        });
        
        context(@"for LYRUIConversationItemView", ^{
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIConversationItemView class]];
            });
            
            it(@"should return presenter of `LYRUIConversationItemViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIConversationItemViewPresenter class]);
            });
        });
        
        context(@"for UICollectionViewCell", ^{
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[UICollectionViewCell class]];
            });
            
            it(@"should return presenter of `LYRUIListCellPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIListCellPresenter class]);
            });
        });
        
        context(@"for LYRUIListHeaderView", ^{
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIListHeaderView class]];
            });
            
            it(@"should return presenter of `LYRUIListSupplementaryViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIListSupplementaryViewPresenter class]);
            });
        });
        
        context(@"for LYRUIConversationListView", ^{
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIConversationListView class]];
            });
            
            it(@"should return presenter of `LYRUIConversationListViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIConversationListViewPresenter class]);
            });
        });
        
        context(@"for LYRUIIdentityItemView", ^{
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIIdentityItemView class]];
            });
            
            it(@"should return presenter of `LYRUIIdentityItemViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIIdentityItemViewPresenter class]);
            });
        });
        
        context(@"for LYRUIIdentityListView", ^{
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIIdentityListView class]];
            });
            
            it(@"should return presenter of `LYRUIIdentityListViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIIdentityListViewPresenter class]);
            });
        });
        
        context(@"for LYRUIComposeBar", ^{
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIComposeBar class]];
            });
            
            it(@"should return presenter of `LYRUIComposeBarPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIComposeBarPresenter class]);
            });
        });
        
        context(@"for LYRUIMessageItemView", ^{
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIMessageItemView class]];
            });
            
            it(@"should return presenter of `LYRUIMessageItemViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIMessageItemViewPresenter class]);
            });
        });
        
        context(@"for LYRUIMessageListView", ^{
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIMessageListView class]];
            });
            
            it(@"should return presenter of `LYRUIMessageListViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIMessageListViewPresenter class]);
            });
        });
        
        context(@"for LYRUICarouselMessageListView", ^{
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUICarouselMessageListView class]];
            });
            
            it(@"should return presenter of `LYRUICarouselMessageListViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUICarouselMessageListViewPresenter class]);
            });
        });
    });
    
    describe(@"layoutForViewClass:", ^{
        __block id returnedObject;
        
        context(@"for LYRUIConversationItemView", ^{
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIConversationItemView class]];
            });
            
            it(@"should return layout conforming to `LYRUIBaseItemViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIBaseItemViewLayout));
            });
        });
        
        context(@"for LYRUIConversationListView", ^{
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIConversationListView class]];
            });
            
            it(@"should return layout conforming to `LYRUIListViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIListViewLayout));
            });
        });
        
        context(@"for LYRUIConversationItemView", ^{
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIConversationItemView class]];
            });
            
            it(@"should return layout conforming to `LYRUIBaseItemViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIBaseItemViewLayout));
            });
        });
        
        context(@"for LYRUIIdentityListView", ^{
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIIdentityListView class]];
            });
            
            it(@"should return layout conforming to `LYRUIListViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIListViewLayout));
            });
        });
        
        context(@"for LYRUIIdentityItemView", ^{
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIIdentityItemView class]];
            });
            
            it(@"should return layout conforming to `LYRUIBaseItemViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIBaseItemViewLayout));
            });
        });
        
        context(@"for LYRUIComposeBar", ^{
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIComposeBar class]];
            });
            
            it(@"should return layout conforming to `LYRUIComposeBarLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIComposeBarLayout));
            });
        });
        
        context(@"for LYRUIMessageItemView", ^{
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIMessageItemView class]];
            });
            
            it(@"should return layout conforming to `LYRUIMessageItemViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIMessageItemViewLayout));
            });
        });
        
        context(@"for LYRUIMessageListMessageTimeView", ^{
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIMessageListMessageTimeView class]];
            });
            
            it(@"should return layout conforming to `LYRUIListHeaderViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIListHeaderViewLayout));
            });
        });
        
        context(@"for LYRUIMessageListMessageStatusView", ^{
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIMessageListMessageStatusView class]];
            });
            
            it(@"should return layout conforming to `LYRUIListHeaderViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIListHeaderViewLayout));
            });
        });
        
        context(@"for LYRUIMessageListView", ^{
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIMessageListView class]];
            });
            
            it(@"should return layout conforming to `LYRUIListViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIListViewLayout));
            });
        });
        
        context(@"for LYRUIConversationView", ^{
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIConversationView class]];
            });
            
            it(@"should return layout conforming to `LYRUIConversationViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIConversationViewLayout));
            });
        });
        
        context(@"for LYRUIPanelTypingIndicatorView", ^{
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIPanelTypingIndicatorView class]];
            });
            
            it(@"should return layout conforming to `LYRUIPanelTypingIndicatorViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIPanelTypingIndicatorViewLayout));
            });
        });
        
        context(@"for LYRUIStandardMessageContainerView", ^{
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIStandardMessageContainerView class]];
            });
            
            it(@"should return layout conforming to `LYRUIStandardMessageContainerViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIStandardMessageContainerViewLayout));
            });
        });
    });
    
    describe(@"protocolImplementation:forClass:", ^{
        __block id returnedObject;
        
        context(@"of LYRUIConversationItemAccessoryViewProviding", ^{
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIConversationItemAccessoryViewProviding)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIAvatarViewProvider` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIAvatarViewProvider class]);
            });
        });
        
        context(@"of LYRUIConversationItemTitleFormatting", ^{
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIConversationItemTitleFormatting)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIConversationItemTitleFormatter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIConversationItemTitleFormatter class]);
            });
        });
        
        context(@"of LYRUITimeFormatting", ^{
            context(@"for any class", ^{
                beforeEach(^{
                    returnedObject = [injector protocolImplementation:@protocol(LYRUITimeFormatting)
                                                             forClass:[NSObject class]];
                });
                
                it(@"should return object of `LYRUIMessageTimeDefaultFormatter` type", ^{
                    expect(returnedObject).to.beAKindOf([LYRUIMessageTimeDefaultFormatter class]);
                });
            });
            
            context(@"for `LYRUIIdentityItemViewPresenter` class", ^{
                beforeEach(^{
                    returnedObject = [injector protocolImplementation:@protocol(LYRUITimeFormatting)
                                                             forClass:[LYRUIIdentityItemViewPresenter class]];
                });
                
                it(@"should return object of `LYRUITimeAgoFormatter` type", ^{
                    expect(returnedObject).to.beAKindOf([LYRUITimeAgoFormatter class]);
                });
            });
            
            context(@"for `LYRUIMessageListTimeSupplementaryViewPresenter` class", ^{
                beforeEach(^{
                    returnedObject = [injector protocolImplementation:@protocol(LYRUITimeFormatting)
                                                             forClass:[LYRUIMessageListTimeSupplementaryViewPresenter class]];
                });
                
                it(@"should return object of `LYRUIMessageListTimeFormatter` type", ^{
                    expect(returnedObject).to.beAKindOf([LYRUIMessageListTimeFormatter class]);
                });
            });
        });
        
        context(@"of LYRUIIdentityItemAccessoryViewProviding", ^{
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIIdentityItemAccessoryViewProviding)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIAvatarViewProvider` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIAvatarViewProvider class]);
            });
        });
        
        context(@"of LYRUIIdentityNameFormatting", ^{
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIIdentityNameFormatting)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIIdentityNameFormatter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIIdentityNameFormatter class]);
            });
        });
        
        context(@"of LYRUIImageFetching", ^{
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIImageFetching)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIImageFetcher` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIImageFetcher class]);
            });
        });
        
        context(@"of LYRUIImageCreating", ^{
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIImageCreating)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIImageFactory` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIImageFactory class]);
            });
        });
        
        context(@"of LYRUIInitialsFormatting", ^{
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIInitialsFormatting)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIInitialsFormatter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIInitialsFormatter class]);
            });
        });
        
        context(@"of LYRUIDataCreating", ^{
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIDataCreating)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIDataFactory` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIDataFactory class]);
            });
        });
        
        context(@"of LYRUIDispatching", ^{
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIDispatching)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIDispatcher` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIDispatcher class]);
            });
        });
        
        context(@"of LYRUIImageCaching", ^{
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIImageCaching)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `NSCache` type", ^{
                expect(returnedObject).to.beAKindOf([NSCache class]);
            });
            
            context(@"when called multiple times", ^{
                __block id anotherReturnedObject;
                
                beforeEach(^{
                    anotherReturnedObject = [injector protocolImplementation:@protocol(LYRUIImageCaching)
                                                                    forClass:[NSObject class]];
                });
                
                it(@"should return the same object", ^{
                    expect(returnedObject).to.equal(anotherReturnedObject);
                });
            });
        });
        
        context(@"of LYRUIThumbnailsCaching", ^{
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIThumbnailsCaching)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `NSCache` type", ^{
                expect(returnedObject).to.beAKindOf([NSCache class]);
            });
            
            context(@"when called multiple times", ^{
                __block id anotherReturnedObject;
                
                beforeEach(^{
                    anotherReturnedObject = [injector protocolImplementation:@protocol(LYRUIThumbnailsCaching)
                                                                    forClass:[NSObject class]];
                });
                
                it(@"should return the same object", ^{
                    expect(returnedObject).to.equal(anotherReturnedObject);
                });
            });
        });
        
        context(@"of LYRUIMessageItemAccessoryViewProviding", ^{
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIMessageItemAccessoryViewProviding)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIAvatarViewProvider` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIAvatarViewProvider class]);
            });
        });
        
        context(@"of LYRUICarouselContentOffsetHandling", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUICarouselContentOffsetHandling)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUICarouselContentOffsetHandler` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUICarouselContentOffsetHandler class]);
            });
        });
        
        context(@"of UIViewControllerPreviewingDelegate", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(UIViewControllerPreviewingDelegate)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIMessageListViewPreviewingDelegate` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIMessageListViewPreviewingDelegate class]);
            });
        });
    });
    
    describe(@"objectOfType:", ^{
        __block id returnedObject;
        
        context(@"for NSCalendar", ^{
            beforeEach(^{
                returnedObject = [injector objectOfType:[NSCalendar class]];
            });
            
            it(@"should return current calendar", ^{
                expect(returnedObject).to.equal([NSCalendar currentCalendar]);
            });
        });
        
        context(@"for NSDateFormatter", ^{
            __block NSDateFormatter *returnedObject;
            
            beforeEach(^{
                returnedObject = [injector objectOfType:[NSDateFormatter class]];
            });
            
            it(@"should return `NSDateFormatter` instance", ^{
                expect(returnedObject).to.beAKindOf([NSDateFormatter class]);
            });
            it(@"should return date formatter with system time zone", ^{
                expect(returnedObject.timeZone).to.equal([NSTimeZone systemTimeZone]);
            });
            it(@"should return date formatter with current locale", ^{
                expect(returnedObject.locale).to.equal([NSLocale currentLocale]);
            });
        });
        
        context(@"for NSLocale", ^{
            beforeEach(^{
                returnedObject = [injector objectOfType:[NSLocale class]];
            });
            
            it(@"should return current locale", ^{
                expect(returnedObject).to.equal([NSLocale currentLocale]);
            });
        });
        
        context(@"for NSTimeZone", ^{
            beforeEach(^{
                returnedObject = [injector objectOfType:[NSTimeZone class]];
            });
            
            it(@"should return system time zone", ^{
                expect(returnedObject).to.equal([NSTimeZone systemTimeZone]);
            });
        });
        
        context(@"for NSURLSession", ^{
            beforeEach(^{
                returnedObject = [injector objectOfType:[NSURLSession class]];
            });
            
            it(@"should return shared session", ^{
                expect(returnedObject).to.equal([NSURLSession sharedSession]);
            });
        });
        
        context(@"for NSBundle", ^{
            __block NSBundle *returnedObject;
            
            beforeEach(^{
                returnedObject = [injector objectOfType:[NSBundle class]];
            });
            
            it(@"should return `NSBundle` instance", ^{
                expect(returnedObject).to.beAKindOf([NSBundle class]);
            });
            it(@"should return bundle with Layer UI Resources", ^{
                expect(returnedObject.bundleIdentifier).to.equal(@"org.cocoapods.LayerXDKUIResource");
            });
        });
        
        context(@"for NSNotificationCenter", ^{
            __block NSNotificationCenter *returnedObject;
            
            beforeEach(^{
                returnedObject = [injector objectOfType:[NSNotificationCenter class]];
            });
            
            it(@"should return default notification center", ^{
                expect(returnedObject).to.equal([NSNotificationCenter defaultCenter]);
            });
        });
        
        context(@"for LYRUIReusableViewsQueue", ^{
            __block LYRUIReusableViewsQueue *returnedObject;
            
            beforeEach(^{
                returnedObject = [injector objectOfType:[LYRUIReusableViewsQueue class]];
            });
            
            it(@"should return object of `LYRUIReusableViewsQueue` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIReusableViewsQueue class]);
            });
            
            context(@"when called multiple times", ^{
                __block LYRUIReusableViewsQueue *anotherReturnedObject;
                
                beforeEach(^{
                    anotherReturnedObject = [injector objectOfType:[LYRUIReusableViewsQueue class]];
                });
                
                it(@"should return the same object", ^{
                    expect(returnedObject).to.equal(anotherReturnedObject);
                });
            });
        });
        
        context(@"for LYRUIListLoadingIndicatorPresenter", ^{
            beforeEach(^{
                returnedObject = [injector objectOfType:[LYRUIListLoadingIndicatorPresenter class]];
            });
            
            it(@"should return presenter of `LYRUIListLoadingIndicatorPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIListLoadingIndicatorPresenter class]);
            });
        });
        
        context(@"for LYRUICarouselContentOffsetsCache", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector objectOfType:[LYRUICarouselContentOffsetsCache class]];
            });
            
            it(@"should return `LYRUICarouselContentOffsetsCache` instance", ^{
                expect(returnedObject).to.beAKindOf([LYRUICarouselContentOffsetsCache class]);
            });
            
            context(@"when called multiple times", ^{
                __block id anotherReturnedObject;
                
                beforeEach(^{
                    anotherReturnedObject = [injector objectOfType:[LYRUICarouselContentOffsetsCache class]];
                });
                
                it(@"should return the same instance", ^{
                    expect(anotherReturnedObject).to.equal(returnedObject);
                });
            });
        });
    });
    
    describe(@"handledMessageClasses", ^{
        __block NSArray *returnedClasses;
        
        context(@"without customizations", ^{
            beforeEach(^{
                returnedClasses = [injector handledMessageClasses];
            });
            
            it(@"should contain 10 message types", ^{
                expect(returnedClasses).to.haveCount(10);
            });
            it(@"should contain LYRUITextMessage", ^{
                expect(returnedClasses).to.contain([LYRUITextMessage class]);
            });
            it(@"should contain LYRUIImageMessage", ^{
                expect(returnedClasses).to.contain([LYRUIImageMessage class]);
            });
            it(@"should contain LYRUILinkMessage", ^{
                expect(returnedClasses).to.contain([LYRUILinkMessage class]);
            });
            it(@"should contain LYRUIFileMessage", ^{
                expect(returnedClasses).to.contain([LYRUIFileMessage class]);
            });
            it(@"should contain LYRUILocationMessage", ^{
                expect(returnedClasses).to.contain([LYRUILocationMessage class]);
            });
            it(@"should contain LYRUIButtonsMessage", ^{
                expect(returnedClasses).to.contain([LYRUIButtonsMessage class]);
            });
            it(@"should contain LYRUIChoiceMessage", ^{
                expect(returnedClasses).to.contain([LYRUIChoiceMessage class]);
            });
            it(@"should contain LYRUICarouselMessage", ^{
                expect(returnedClasses).to.contain([LYRUICarouselMessage class]);
            });
            it(@"should contain LYRUIProductMessage", ^{
                expect(returnedClasses).to.contain([LYRUIProductMessage class]);
            });
            it(@"should contain LYRUIReceiptMessage", ^{
                expect(returnedClasses).to.contain([LYRUIReceiptMessage  class]);
            });
        });
        
        context(@"when custom message type is registered", ^{
            beforeEach(^{
                [injector registerMessageTypeClass:[LYRUIFakeTestMessage class]
                               withSerializerClass:[LYRUIFakeTestMessageSerializer class]
                             contentPresenterClass:[LYRUIFakeTestMessagePresenter class]];
                
                returnedClasses = [injector handledMessageClasses];
            });
            
            it(@"should contain 11 message types", ^{
                expect(returnedClasses).to.haveCount(11);
            });
            it(@"should contain LYRUITextMessage", ^{
                expect(returnedClasses).to.contain([LYRUITextMessage class]);
            });
            it(@"should contain LYRUIImageMessage", ^{
                expect(returnedClasses).to.contain([LYRUIImageMessage class]);
            });
            it(@"should contain LYRUILinkMessage", ^{
                expect(returnedClasses).to.contain([LYRUILinkMessage class]);
            });
            it(@"should contain LYRUIFileMessage", ^{
                expect(returnedClasses).to.contain([LYRUIFileMessage class]);
            });
            it(@"should contain LYRUILocationMessage", ^{
                expect(returnedClasses).to.contain([LYRUILocationMessage class]);
            });
            it(@"should contain LYRUIButtonsMessage", ^{
                expect(returnedClasses).to.contain([LYRUIButtonsMessage class]);
            });
            it(@"should contain LYRUIChoiceMessage", ^{
                expect(returnedClasses).to.contain([LYRUIChoiceMessage class]);
            });
            it(@"should contain LYRUICarouselMessage", ^{
                expect(returnedClasses).to.contain([LYRUICarouselMessage class]);
            });
            it(@"should contain LYRUIProductMessage", ^{
                expect(returnedClasses).to.contain([LYRUIProductMessage class]);
            });
            it(@"should contain LYRUIReceiptMessage", ^{
                expect(returnedClasses).to.contain([LYRUIReceiptMessage  class]);
            });
            it(@"should contain LYRUIFakeTestMessage", ^{
                expect(returnedClasses).to.contain([LYRUIFakeTestMessage  class]);
            });
        });
    });
    
    describe(@"presenterForMessageClass:", ^{
        __block id<LYRUIMessageItemContentPresenting> returnedPresenter;
        
        context(@"for LYRUITextMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector presenterForMessageClass:[LYRUITextMessage class]];
            });
            
            it(@"should return `LYRUITextMessageContentViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUITextMessageContentViewPresenter class]);
            });
        });
        
        context(@"for LYRUIImageMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector presenterForMessageClass:[LYRUIImageMessage class]];
            });
            
            it(@"should return `LYRUIImageMessageContentViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUIImageMessageContentViewPresenter class]);
            });
        });
        
        context(@"for LYRUILinkMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector presenterForMessageClass:[LYRUILinkMessage class]];
            });
            
            it(@"should return `LYRUILinkMessageContentViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUILinkMessageContentViewPresenter class]);
            });
        });
        
        context(@"for LYRUIFileMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector presenterForMessageClass:[LYRUIFileMessage class]];
            });
            
            it(@"should return `LYRUIFileMessageContentViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUIFileMessageContentViewPresenter class]);
            });
        });
        
        context(@"for LYRUILocationMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector presenterForMessageClass:[LYRUILocationMessage class]];
            });
            
            it(@"should return `LYRUILocationMessageContentViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUILocationMessageContentViewPresenter class]);
            });
        });
        
        context(@"for LYRUIButtonsMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector presenterForMessageClass:[LYRUIButtonsMessage class]];
            });
            
            it(@"should return `LYRUIButtonsMessageCompositeViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUIButtonsMessageCompositeViewPresenter class]);
            });
        });
        
        context(@"for LYRUIChoiceMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector presenterForMessageClass:[LYRUIChoiceMessage class]];
            });
            
            it(@"should return `LYRUIChoiceMessageCompositeViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUIChoiceMessageCompositeViewPresenter class]);
            });
        });
        
        context(@"for LYRUICarouselMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector presenterForMessageClass:[LYRUICarouselMessage class]];
            });
            
            it(@"should return `LYRUICarouselMessageCompositeViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUICarouselMessageCompositeViewPresenter class]);
            });
        });
        
        context(@"for LYRUIProductMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector presenterForMessageClass:[LYRUIProductMessage class]];
            });
            
            it(@"should return `LYRUIProductMessageCompositeViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUIProductMessageCompositeViewPresenter class]);
            });
        });
        
        context(@"for LYRUIReceiptMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector presenterForMessageClass:[LYRUIReceiptMessage class]];
            });
            
            it(@"should return `LYRUIReceiptMessageCompositeViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUIReceiptMessageCompositeViewPresenter class]);
            });
        });
    });
    
    describe(@"containerPresenterForMessageClass:", ^{
        __block id<LYRUIMessageItemContentPresenting> returnedPresenter;
        
        context(@"for LYRUITextMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector containerPresenterForMessageClass:[LYRUITextMessage class]];
            });
            
            it(@"should return `LYRUIStandardMessageContainerViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUIStandardMessageContainerViewPresenter class]);
            });
        });
        
        context(@"for LYRUIImageMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector containerPresenterForMessageClass:[LYRUIImageMessage class]];
            });
            
            it(@"should return `LYRUIStandardMessageContainerViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUIStandardMessageContainerViewPresenter class]);
            });
        });
        
        context(@"for LYRUILinkMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector containerPresenterForMessageClass:[LYRUILinkMessage class]];
            });
            
            it(@"should return `LYRUILinkMessageContainerViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUILinkMessageContainerViewPresenter class]);
            });
        });
        
        context(@"for LYRUIFileMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector containerPresenterForMessageClass:[LYRUIFileMessage class]];
            });
            
            it(@"should return `LYRUIStandardMessageContainerViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUIStandardMessageContainerViewPresenter class]);
            });
        });
        
        context(@"for LYRUILocationMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector containerPresenterForMessageClass:[LYRUILocationMessage class]];
            });
            
            it(@"should return `LYRUIStandardMessageContainerViewPresenter`", ^{
                expect(returnedPresenter).to.beAKindOf([LYRUIStandardMessageContainerViewPresenter class]);
            });
        });
        
        context(@"for LYRUIButtonsMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector containerPresenterForMessageClass:[LYRUIButtonsMessage class]];
            });
            
            it(@"should return nil", ^{
                expect(returnedPresenter).to.beNil();
            });
        });
        
        context(@"for LYRUIChoiceMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector containerPresenterForMessageClass:[LYRUIChoiceMessage class]];
            });
            
            it(@"should return nil", ^{
                expect(returnedPresenter).to.beNil();
            });
        });
        
        context(@"for LYRUICarouselMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector containerPresenterForMessageClass:[LYRUICarouselMessage class]];
            });
            
            it(@"should return nil", ^{
                expect(returnedPresenter).to.beNil();
            });
        });
        
        context(@"for LYRUIProductMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector containerPresenterForMessageClass:[LYRUIProductMessage class]];
            });
            
            it(@"should return nil", ^{
                expect(returnedPresenter).to.beNil();
            });
        });
        
        context(@"for LYRUIReceiptMessage", ^{
            beforeEach(^{
                returnedPresenter = [injector containerPresenterForMessageClass:[LYRUIReceiptMessage class]];
            });
            
            it(@"should return nil", ^{
                expect(returnedPresenter).to.beNil();
            });
        });
    });
    
    describe(@"serializerForMessagePartMIMEType:", ^{
        __block id<LYRUIMessageTypeSerializing> returnedSerializer;
        
        context(@"for `application/vnd.layer.text+json`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"application/vnd.layer.text+json"];
            });
            
            it(@"should return `LYRUITextMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUITextMessageSerializer class]);
            });
        });
        
        context(@"for `text/plain`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"text/plain"];
            });
            
            it(@"should return `LYRUITextMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUITextMessageSerializer class]);
            });
        });
        
        context(@"for `application/vnd.layer.image+json`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"application/vnd.layer.image+json"];
            });
            
            it(@"should return `LYRUIImageMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUIImageMessageSerializer class]);
            });
        });
        
        context(@"for `image/jpg`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"image/jpg"];
            });
            
            it(@"should return `LYRUIImageMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUIImageMessageSerializer class]);
            });
        });
        
        context(@"for `image/jpeg`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"image/jpeg"];
            });
            
            it(@"should return `LYRUIImageMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUIImageMessageSerializer class]);
            });
        });
        
        context(@"for `image/png`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"image/png"];
            });
            
            it(@"should return `LYRUIImageMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUIImageMessageSerializer class]);
            });
        });
        
        context(@"for `image/gif`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"image/gif"];
            });
            
            it(@"should return `LYRUIImageMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUIImageMessageSerializer class]);
            });
        });
        
        context(@"for `application/vnd.layer.link+json`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"application/vnd.layer.link+json"];
            });
            
            it(@"should return `LYRUILinkMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUILinkMessageSerializer class]);
            });
        });
        
        context(@"for `application/vnd.layer.file+json`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"application/vnd.layer.file+json"];
            });
            
            it(@"should return `LYRUIFileMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUIFileMessageSerializer class]);
            });
        });
        
        context(@"for `application/pdf`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"application/pdf"];
            });
            
            it(@"should return `LYRUIFileMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUIFileMessageSerializer class]);
            });
        });
        
        context(@"for `application/vnd.layer.location+json`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"application/vnd.layer.location+json"];
            });
            
            it(@"should return `LYRUILocationMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUILocationMessageSerializer class]);
            });
        });
        
        context(@"for `location/coordinate`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"location/coordinate"];
            });
            
            it(@"should return `LYRUILocationMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUILocationMessageSerializer class]);
            });
        });
        
        context(@"for `application/vnd.layer.buttons+json`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"application/vnd.layer.buttons+json"];
            });
            
            it(@"should return `LYRUIButtonsMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUIButtonsMessageSerializer class]);
            });
        });
        
        context(@"for `application/vnd.layer.choice+json`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"application/vnd.layer.choice+json"];
            });
            
            it(@"should return `LYRUIChoiceMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUIChoiceMessageSerializer class]);
            });
        });
        
        context(@"for `application/vnd.layer.carousel+json`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"application/vnd.layer.carousel+json"];
            });
            
            it(@"should return `LYRUICarouselMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUICarouselMessageSerializer class]);
            });
        });
        
        context(@"for `application/vnd.layer.product+json`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"application/vnd.layer.product+json"];
            });
            
            it(@"should return `LYRUIProductMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUIProductMessageSerializer class]);
            });
        });
        
        context(@"for `application/vnd.layer.receipt+json`", ^{
            beforeEach(^{
                returnedSerializer = [injector serializerForMessagePartMIMEType:@"application/vnd.layer.receipt+json"];
            });
            
            it(@"should return `LYRUIReceiptMessageSerializer`", ^{
                expect(returnedSerializer).to.beAKindOf([LYRUIReceiptMessageSerializer class]);
            });
        });
    });
    
    describe(@"handlerOfMessageActionWithEvent:forMessageType:", ^{
        __block id<LYRUIActionHandling> returnedHandler;
        
        context(@"for `open-file`", ^{
            beforeEach(^{
                returnedHandler = [injector handlerOfMessageActionWithEvent:@"open-file" forMessageType:nil];
            });
            
            it(@"should return `LYRUIMessageOpenFileActionHandler`", ^{
                expect(returnedHandler).to.beAKindOf([LYRUIMessageOpenFileActionHandler class]);
            });
        });
        
        context(@"for `open-url`", ^{
            beforeEach(^{
                returnedHandler = [injector handlerOfMessageActionWithEvent:@"open-url" forMessageType:nil];
            });
            
            it(@"should return `LYRUIMessageOpenURLActionHandler`", ^{
                expect(returnedHandler).to.beAKindOf([LYRUIMessageOpenURLActionHandler class]);
            });
        });
        
        context(@"for `open-map`", ^{
            beforeEach(^{
                returnedHandler = [injector handlerOfMessageActionWithEvent:@"open-map" forMessageType:nil];
            });
            
            it(@"should return `LYRUIMessageOpenMapActionHandler`", ^{
                expect(returnedHandler).to.beAKindOf([LYRUIMessageOpenMapActionHandler class]);
            });
        });
    });
    
    describe(@"registerMessageTypeClass:withSerializerClass:contentPresenterClass:containerPresenterClass:", ^{
        context(@"when message type class is nil", ^{
            __block void(^invalidCall)();
            
            beforeEach(^{
                invalidCall = ^{
                    Class messageTypeClass = nil;
                    [injector registerMessageTypeClass:messageTypeClass
                                   withSerializerClass:[LYRUIFakeTestMessageSerializer class]
                                 contentPresenterClass:[LYRUIFakeTestMessagePresenter class]
                               containerPresenterClass:[LYRUIFakeTestMessageContainerPresenter class]];
                };
            });
            
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                NSString *exceptionReason = @"`messageTypeClass` argument can not be nil.";
                expect(invalidCall).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"when message type class is not a `LYRUIMessageType` subclass", ^{
            __block void(^invalidCall)();
            
            beforeEach(^{
                invalidCall = ^{
                    [injector registerMessageTypeClass:[NSObject class]
                                   withSerializerClass:[LYRUIFakeTestMessageSerializer class]
                                 contentPresenterClass:[LYRUIFakeTestMessagePresenter class]
                               containerPresenterClass:[LYRUIFakeTestMessageContainerPresenter class]];
                };
            });
            
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                NSString *exceptionReason = @"`messageTypeClass` must be a subclass of `LYRUIMessageType`.";
                expect(invalidCall).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"when serializer class is nil", ^{
            __block void(^invalidCall)();
            
            beforeEach(^{
                invalidCall = ^{
                    Class messageSerializerClass = nil;
                    [injector registerMessageTypeClass:[LYRUIFakeTestMessage class]
                                   withSerializerClass:messageSerializerClass
                                 contentPresenterClass:[LYRUIFakeTestMessagePresenter class]
                               containerPresenterClass:[LYRUIFakeTestMessageContainerPresenter class]];
                };
            });
            
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                NSString *exceptionReason = @"`serializerClass` argument can not be nil.";
                expect(invalidCall).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"when serializer class does not conform to `LYRUIMessageTypeSerializing` protocol", ^{
            __block void(^invalidCall)();
            
            beforeEach(^{
                invalidCall = ^{
                    [injector registerMessageTypeClass:[LYRUIFakeTestMessage class]
                                   withSerializerClass:[NSObject class]
                                 contentPresenterClass:[LYRUIFakeTestMessagePresenter class]
                               containerPresenterClass:[LYRUIFakeTestMessageContainerPresenter class]];
                };
            });
            
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                NSString *exceptionReason = @"`serializerClass` must conform to `LYRUIMessageTypeSerializing` protocol.";
                expect(invalidCall).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"when content presenter class is nil", ^{
            __block void(^invalidCall)();
            
            beforeEach(^{
                invalidCall = ^{
                    Class messagePresenterClass = nil;
                    [injector registerMessageTypeClass:[LYRUIFakeTestMessage class]
                                   withSerializerClass:[LYRUIFakeTestMessageSerializer class]
                                 contentPresenterClass:messagePresenterClass
                               containerPresenterClass:[LYRUIFakeTestMessageContainerPresenter class]];
                };
            });
            
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                NSString *exceptionReason = @"`contentPresenterClass` argument can not be nil.";
                expect(invalidCall).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"when content presenter class does not conform to `LYRUIMessageItemContentPresenting` protocol", ^{
            __block void(^invalidCall)();
            
            beforeEach(^{
                invalidCall = ^{
                    [injector registerMessageTypeClass:[LYRUIFakeTestMessage class]
                                   withSerializerClass:[LYRUIFakeTestMessageSerializer class]
                                 contentPresenterClass:[NSObject class]
                               containerPresenterClass:[LYRUIFakeTestMessageContainerPresenter class]];
                };
            });
            
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                NSString *exceptionReason = @"`contentPresenterClass` must conform to `LYRUIMessageItemContentPresenting` protocol.";
                expect(invalidCall).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"when container does not conform to `LYRUIMessageItemContentContainerPresenting` protocol", ^{
            __block void(^invalidCall)();
            
            beforeEach(^{
                invalidCall = ^{
                    [injector registerMessageTypeClass:[LYRUIFakeTestMessage class]
                                   withSerializerClass:[LYRUIFakeTestMessageSerializer class]
                                 contentPresenterClass:[LYRUIFakeTestMessagePresenter class]
                               containerPresenterClass:[NSObject class]];
                };
            });
            
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                NSString *exceptionReason = @"`containerPresenterClass` must conform to `LYRUIMessageItemContentContainerPresenting` protocol.";
                expect(invalidCall).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"when all arguments are valid", ^{
            beforeEach(^{
                [injector registerMessageTypeClass:[LYRUIFakeTestMessage class]
                               withSerializerClass:[LYRUIFakeTestMessageSerializer class]
                             contentPresenterClass:[LYRUIFakeTestMessagePresenter class]
                           containerPresenterClass:[LYRUIFakeTestMessageContainerPresenter class]];
            });
            
            it(@"should register a serializer for proper mime type", ^{
                id<LYRUIMessageTypeSerializing> serializer = [injector serializerForMessagePartMIMEType:@"com.layer.test.fake"];
                expect(serializer).to.beAKindOf([LYRUIFakeTestMessageSerializer class]);
            });
            it(@"should register a presenter for new message type", ^{
                id<LYRUIMessageItemContentPresenting> presenter = [injector presenterForMessageClass:[LYRUIFakeTestMessage class]];
                expect(presenter).to.beAKindOf([LYRUIFakeTestMessagePresenter class]);
            });
            it(@"should register a content presenter for new message type", ^{
                id<LYRUIMessageItemContentContainerPresenting> presenter = [injector containerPresenterForMessageClass:[LYRUIFakeTestMessage class]];
                expect(presenter).to.beAKindOf([LYRUIFakeTestMessageContainerPresenter class]);
            });
        });
        
        context(@"when container presenter class is nil", ^{
            beforeEach(^{
                [injector registerMessageTypeClass:[LYRUIFakeTestMessage class]
                               withSerializerClass:[LYRUIFakeTestMessageSerializer class]
                             contentPresenterClass:[LYRUIFakeTestMessagePresenter class]
                           containerPresenterClass:nil];
            });
            
            it(@"should register a serializer for proper mime type", ^{
                id<LYRUIMessageTypeSerializing> serializer = [injector serializerForMessagePartMIMEType:@"com.layer.test.fake"];
                expect(serializer).to.beAKindOf([LYRUIFakeTestMessageSerializer class]);
            });
            it(@"should register a presenter for new message type", ^{
                id<LYRUIMessageItemContentPresenting> presenter = [injector presenterForMessageClass:[LYRUIFakeTestMessage class]];
                expect(presenter).to.beAKindOf([LYRUIFakeTestMessagePresenter class]);
            });
            it(@"should not register a content presenter for new message type", ^{
                id<LYRUIMessageItemContentContainerPresenting> presenter = [injector containerPresenterForMessageClass:[LYRUIFakeTestMessage class]];
                expect(presenter).to.beNil();
            });
        });
        
        context(@"when overriding an existing mime type", ^{
            beforeEach(^{
                [injector registerMessageTypeClass:[LYRUIFakeImageMessage class]
                               withSerializerClass:[LYRUIFakeTestMessageSerializer class]
                             contentPresenterClass:[LYRUIFakeTestMessagePresenter class]
                           containerPresenterClass:[LYRUIFakeTestMessageContainerPresenter class]];
            });
            
            it(@"should override a serializer for proper mime type", ^{
                id<LYRUIMessageTypeSerializing> serializer = [injector serializerForMessagePartMIMEType:@"application/vnd.layer.image+json"];
                expect(serializer).to.beAKindOf([LYRUIFakeTestMessageSerializer class]);
            });
            it(@"should register a presenter for new message type", ^{
                id<LYRUIMessageItemContentPresenting> presenter = [injector presenterForMessageClass:[LYRUIFakeImageMessage class]];
                expect(presenter).to.beAKindOf([LYRUIFakeTestMessagePresenter class]);
            });
            it(@"should register a content presenter for new message type", ^{
                id<LYRUIMessageItemContentContainerPresenting> presenter = [injector containerPresenterForMessageClass:[LYRUIFakeImageMessage class]];
                expect(presenter).to.beAKindOf([LYRUIFakeTestMessageContainerPresenter class]);
            });
        });
        
        context(@"when overriding an existing message type", ^{
            beforeEach(^{
                [injector registerMessageTypeClass:[LYRUIImageMessage class]
                               withSerializerClass:[LYRUIFakeTestMessageSerializer class]
                             contentPresenterClass:[LYRUIFakeTestMessagePresenter class]
                           containerPresenterClass:[LYRUIFakeTestMessageContainerPresenter class]];
            });
            
            it(@"should override a serializer for proper mime type", ^{
                id<LYRUIMessageTypeSerializing> serializer = [injector serializerForMessagePartMIMEType:@"application/vnd.layer.image+json"];
                expect(serializer).to.beAKindOf([LYRUIFakeTestMessageSerializer class]);
            });
            it(@"should register a presenter for new message type", ^{
                id<LYRUIMessageItemContentPresenting> presenter = [injector presenterForMessageClass:[LYRUIImageMessage class]];
                expect(presenter).to.beAKindOf([LYRUIFakeTestMessagePresenter class]);
            });
            it(@"should register a content presenter for new message type", ^{
                id<LYRUIMessageItemContentContainerPresenting> presenter = [injector containerPresenterForMessageClass:[LYRUIImageMessage class]];
                expect(presenter).to.beAKindOf([LYRUIFakeTestMessageContainerPresenter class]);
            });
        });
    });
    
    describe(@"registerActionHandlerClass:forEvent:messageTypeClass:", ^{
        context(@"when action handler class is nil", ^{
            __block void(^invalidCall)();
            
            beforeEach(^{
                invalidCall = ^{
                    Class actionHandlerClass = nil;
                    [injector registerActionHandlerClass:actionHandlerClass
                                                forEvent:@"test-event"
                                        messageTypeClass:[LYRUIFakeTestMessage class]];
                };
            });
            
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                NSString *exceptionReason = @"`actionHandlerClass` argument can not be nil.";
                expect(invalidCall).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"when action handler class does not conform to `LYRUIActionHandling` protocol", ^{
            __block void(^invalidCall)();
            
            beforeEach(^{
                invalidCall = ^{
                    [injector registerActionHandlerClass:[NSObject class]
                                                forEvent:@"test-event"
                                        messageTypeClass:[LYRUIFakeTestMessage class]];
                };
            });
            
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                NSString *exceptionReason = @"`actionHandlerClass` must conform to `LYRUIActionHandling` protocol.";
                expect(invalidCall).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"when event is nil", ^{
            __block void(^invalidCall)();
            
            beforeEach(^{
                invalidCall = ^{
                    NSString *event = nil;
                    [injector registerActionHandlerClass:[LYRUIFakeTestActionHandler class]
                                                forEvent:event
                                        messageTypeClass:[LYRUIFakeTestMessage class]];
                };
            });
            
            it(@"should throw a NSInvalidArgumentException with proper reason", ^{
                NSString *exceptionReason = @"`event` argument can not be nil.";
                expect(invalidCall).to.raiseWithReason(NSInvalidArgumentException, exceptionReason);
            });
        });
        
        context(@"when all arguments are valid", ^{
            beforeEach(^{
                [injector registerActionHandlerClass:[LYRUIFakeTestActionHandler class]
                                            forEvent:@"test-event"
                                    messageTypeClass:[LYRUIFakeTestMessage class]];
            });
            
            it(@"should register a handler for proper event, and given message type", ^{
                id<LYRUIActionHandling> actionHandler = [injector handlerOfMessageActionWithEvent:@"test-event"
                                                                                   forMessageType:[LYRUIFakeTestMessage class]];
                expect(actionHandler).to.beAKindOf([LYRUIFakeTestActionHandler class]);
            });
            it(@"should not register a handler for proper event, for any message type", ^{
                id<LYRUIActionHandling> actionHandler = [injector handlerOfMessageActionWithEvent:@"test-event"
                                                                                   forMessageType:[NSObject class]];
                expect(actionHandler).to.beNil();
            });
        });
        
        context(@"when message type class is nil", ^{
            beforeEach(^{
                [injector registerActionHandlerClass:[LYRUIFakeTestActionHandler class]
                                            forEvent:@"test-event"
                                    messageTypeClass:nil];
            });
            
            it(@"should register a handler for proper event, for any message type", ^{
                id<LYRUIActionHandling> actionHandler = [injector handlerOfMessageActionWithEvent:@"test-event"
                                                                                   forMessageType:[NSObject class]];
                expect(actionHandler).to.beAKindOf([LYRUIFakeTestActionHandler class]);
            });
        });
        
        context(@"when overriding an existing event type", ^{
            beforeEach(^{
                [injector registerActionHandlerClass:[LYRUIFakeTestActionHandler class]
                                            forEvent:@"open-url"
                                    messageTypeClass:nil];
            });
            
            it(@"should override a handler for proper event, for any message type", ^{
                id<LYRUIActionHandling> actionHandler = [injector handlerOfMessageActionWithEvent:@"open-url"
                                                                                   forMessageType:[NSObject class]];
                expect(actionHandler).to.beAKindOf([LYRUIFakeTestActionHandler class]);
            });
        });
        
        context(@"when overriding an existing event type, for specific message type", ^{
            beforeEach(^{
                [injector registerActionHandlerClass:[LYRUIFakeTestActionHandler class]
                                            forEvent:@"open-url"
                                    messageTypeClass:[LYRUIFakeTestMessage class]];
            });
            
            it(@"should register a handler for proper event, and given message type", ^{
                id<LYRUIActionHandling> actionHandler = [injector handlerOfMessageActionWithEvent:@"open-url"
                                                                                   forMessageType:[LYRUIFakeTestMessage class]];
                expect(actionHandler).to.beAKindOf([LYRUIFakeTestActionHandler class]);
            });
            it(@"should not override a handler for proper event, for any message type", ^{
                id<LYRUIActionHandling> actionHandler = [injector handlerOfMessageActionWithEvent:@"open-url"
                                                                                   forMessageType:[NSObject class]];
                expect(actionHandler).to.beAKindOf([LYRUIMessageOpenURLActionHandler class]);
            });
        });
    });
});

SpecEnd
