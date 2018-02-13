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
#import <LayerXDK/LYRUICarouselContentOffsetHandler.h>
#import <LayerXDK/LYRUICarouselContentOffsetsCache.h>

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
        context(@"for LYRUIPresenceView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector themeForViewClass:[LYRUIPresenceView class]];
            });
            
            it(@"should return theme conforming to `LYRUIPresenceViewTheme` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIPresenceViewTheme));
            });
        });
        
        context(@"for LYRUIAvatarView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector themeForViewClass:[LYRUIAvatarView class]];
            });
            
            it(@"should return theme conforming to `LYRUIAvatarViewTheme` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIAvatarViewTheme));
            });
        });
        
        context(@"for LYRUIConversationItemView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector themeForViewClass:[LYRUIConversationItemView class]];
            });
            
            it(@"should return theme conforming to `LYRUIBaseItemViewTheme` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIBaseItemViewTheme));
            });
        });
        
        context(@"for LYRUIIdentityItemView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector themeForViewClass:[LYRUIIdentityItemView class]];
            });
            
            it(@"should return theme conforming to `LYRUIBaseItemViewTheme` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIBaseItemViewTheme));
            });
        });
    });
    
    describe(@"alternativeThemeForViewClass:", ^{
        context(@"for LYRUIConversationItemView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector alternativeThemeForViewClass:[LYRUIConversationItemView class]];
            });
            
            it(@"should return theme conforming to `LYRUIBaseItemViewTheme` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIBaseItemViewTheme));
            });
        });
    });
    
    describe(@"presenterForViewClass:", ^{
        context(@"for LYRUIPresenceView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIPresenceView class]];
            });
            
            it(@"should return presenter of `LYRUIPresenceViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIPresenceViewPresenter class]);
            });
        });
        
        context(@"for LYRUIAvatarView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIAvatarView class]];
            });
            
            it(@"should return presenter of `LYRUIAvatarViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIAvatarViewPresenter class]);
            });
        });
        
        context(@"for LYRUIImageWithLettersView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIImageWithLettersView class]];
            });
            
            it(@"should return presenter of `LYRUIImageWithLettersViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIImageWithLettersViewPresenter class]);
            });
        });
        
        context(@"for LYRUIConversationItemView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIConversationItemView class]];
            });
            
            it(@"should return presenter of `LYRUIConversationItemViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIConversationItemViewPresenter class]);
            });
        });
        
        context(@"for UICollectionViewCell", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[UICollectionViewCell class]];
            });
            
            it(@"should return presenter of `LYRUIListCellPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIListCellPresenter class]);
            });
        });
        
        context(@"for LYRUIListHeaderView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIListHeaderView class]];
            });
            
            it(@"should return presenter of `LYRUIListSupplementaryViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIListSupplementaryViewPresenter class]);
            });
        });
        
        context(@"for LYRUIConversationListView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIConversationListView class]];
            });
            
            it(@"should return presenter of `LYRUIConversationListViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIConversationListViewPresenter class]);
            });
        });
        
        context(@"for LYRUIIdentityItemView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIIdentityItemView class]];
            });
            
            it(@"should return presenter of `LYRUIIdentityItemViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIIdentityItemViewPresenter class]);
            });
        });
        
        context(@"for LYRUIIdentityListView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIIdentityListView class]];
            });
            
            it(@"should return presenter of `LYRUIIdentityListViewPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIIdentityListViewPresenter class]);
            });
        });
        
        context(@"for LYRUIComposeBar", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector presenterForViewClass:[LYRUIComposeBar class]];
            });
            
            it(@"should return presenter of `LYRUIComposeBarPresenter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIComposeBarPresenter class]);
            });
        });
    });
    
    describe(@"layoutForViewClass:", ^{
        context(@"for LYRUIConversationItemView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIConversationItemView class]];
            });
            
            it(@"should return layout conforming to `LYRUIBaseItemViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIBaseItemViewLayout));
            });
        });
        
        context(@"for LYRUIConversationListView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIConversationListView class]];
            });
            
            it(@"should return layout conforming to `LYRUIListViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIListViewLayout));
            });
        });
        
        context(@"for LYRUIConversationItemView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIConversationItemView class]];
            });
            
            it(@"should return layout conforming to `LYRUIBaseItemViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIBaseItemViewLayout));
            });
        });
        
        context(@"for LYRUIIdentityListView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIIdentityListView class]];
            });
            
            it(@"should return layout conforming to `LYRUIListViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIListViewLayout));
            });
        });
        
        context(@"for LYRUIIdentityItemView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIIdentityItemView class]];
            });
            
            it(@"should return layout conforming to `LYRUIBaseItemViewLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIBaseItemViewLayout));
            });
        });
        
        context(@"for LYRUIComposeBar", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIComposeBar class]];
            });
            
            it(@"should return layout conforming to `LYRUIComposeBarLayout` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIComposeBarLayout));
            });
        });
    });
    
    describe(@"protocolImplementation:forClass:", ^{
        context(@"of LYRUIConversationItemAccessoryViewProviding", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIConversationItemAccessoryViewProviding)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIAvatarViewProvider` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIAvatarViewProvider class]);
            });
        });
        
        context(@"of LYRUIConversationItemTitleFormatting", ^{
            __block id returnedObject;
            
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
                __block id returnedObject;
                
                beforeEach(^{
                    returnedObject = [injector protocolImplementation:@protocol(LYRUITimeFormatting)
                                                             forClass:[NSObject class]];
                });
                
                it(@"should return object of `LYRUIMessageTimeDefaultFormatter` type", ^{
                    expect(returnedObject).to.beAKindOf([LYRUIMessageTimeDefaultFormatter class]);
                });
            });
            
            context(@"for `LYRUIIdentityItemViewPresenter` class", ^{
                __block id returnedObject;
                
                beforeEach(^{
                    returnedObject = [injector protocolImplementation:@protocol(LYRUITimeFormatting)
                                                             forClass:[LYRUIIdentityItemViewPresenter class]];
                });
                
                it(@"should return object of `LYRUITimeAgoFormatter` type", ^{
                    expect(returnedObject).to.beAKindOf([LYRUITimeAgoFormatter class]);
                });
            });
        });
        
        context(@"of LYRUIIdentityItemAccessoryViewProviding", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIIdentityItemAccessoryViewProviding)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIAvatarViewProvider` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIAvatarViewProvider class]);
            });
        });
        
        context(@"of LYRUIIdentityNameFormatting", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIIdentityNameFormatting)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIIdentityNameFormatter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIIdentityNameFormatter class]);
            });
        });
        
        context(@"of LYRUIImageFetching", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIImageFetching)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIImageFetcher` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIImageFetcher class]);
            });
        });
        
        context(@"of LYRUIImageCreating", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIImageCreating)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIImageFactory` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIImageFactory class]);
            });
        });
        
        context(@"of LYRUIInitialsFormatting", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIInitialsFormatting)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIInitialsFormatter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIInitialsFormatter class]);
            });
        });
        
        context(@"of LYRUIDataCreating", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIDataCreating)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIDataFactory` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIDataFactory class]);
            });
        });
        
        context(@"of LYRUIDispatching", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIDispatching)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIDispatcher` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIDispatcher class]);
            });
        });
        
        context(@"of LYRUIImageCaching", ^{
            __block id returnedObject;
            
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
    });
    
    describe(@"objectOfType:", ^{
        context(@"for NSCalendar", ^{
            __block id returnedObject;
            
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
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector objectOfType:[NSLocale class]];
            });
            
            it(@"should return current locale", ^{
                expect(returnedObject).to.equal([NSLocale currentLocale]);
            });
        });
        
        context(@"for NSTimeZone", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector objectOfType:[NSTimeZone class]];
            });
            
            it(@"should return system time zone", ^{
                expect(returnedObject).to.equal([NSTimeZone systemTimeZone]);
            });
        });
        
        context(@"for NSURLSession", ^{
            __block id returnedObject;
            
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
});

SpecEnd
