#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIDependencyInjector.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIPresenceView.h>
#import <Atlas/LYRUIPresenceViewDefaultTheme.h>
#import <Atlas/LYRUIPresenceViewPresenter.h>
#import <Atlas/LYRUIAvatarView.h>
#import <Atlas/LYRUIAvatarViewDefaultTheme.h>
#import <Atlas/LYRUIAvatarViewPresenter.h>
#import <Atlas/LYRUIImageWithLettersView.h>
#import <Atlas/LYRUIImageWithLettersViewPresenter.h>
#import <Atlas/LYRUIBaseItemView.h>
#import <Atlas/LYRUIBaseItemViewDefaultTheme.h>
#import <Atlas/LYRUIBaseItemViewLayout.h>
#import <Atlas/LYRUIConversationItemView.h>
#import <Atlas/LYRUIConversationItemViewUnreadTheme.h>
#import <Atlas/LYRUIConversationItemViewPresenter.h>
#import <Atlas/LYRUIConversationItemTitleFormatter.h>
#import <Atlas/LYRUIMessageTextDefaultFormatter.h>
#import <Atlas/LYRUIMessageTimeDefaultFormatter.h>
#import <Atlas/LYRUIConversationListView.h>
#import <Atlas/LYRUIConversationListViewPresenter.h>
#import <Atlas/LYRUIListCellPresenter.h>
#import <Atlas/LYRUIListHeaderView.h>
#import <Atlas/LYRUIListSupplementaryViewPresenter.h>
#import <Atlas/LYRUIListLayout.h>
#import <Atlas/LYRUIIdentityItemView.h>
#import <Atlas/LYRUIIdentityItemViewPresenter.h>
#import <Atlas/LYRUIIdentityNameFormatter.h>
#import <Atlas/LYRUITimeAgoFormatter.h>
#import <Atlas/LYRUIIdentityListView.h>
#import <Atlas/LYRUIIdentityListViewPresenter.h>
#import <Atlas/LYRUIImageFetcher.h>
#import <Atlas/LYRUIImageFactory.h>
#import <Atlas/LYRUIInitialsFormatter.h>
#import <Atlas/LYRUIDataFactory.h>
#import <Atlas/LYRUIDispatcher.h>
#import <Atlas/NSCache+LYRUIImageCaching.h>
#import <Atlas/LYRUIComposeBar.h>
#import <Atlas/LYRUIComposeBarPresenter.h>
#import <Atlas/LYRUIAvatarViewProvider.h>

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
        
        context(@"of LYRUIMessageTextFormatting", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector protocolImplementation:@protocol(LYRUIMessageTextFormatting)
                                                         forClass:[NSObject class]];
            });
            
            it(@"should return object of `LYRUIMessageTextDefaultFormatter` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIMessageTextDefaultFormatter class]);
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
                expect(returnedObject.bundleIdentifier).to.equal(@"org.cocoapods.AtlasResource");
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
    });
});

SpecEnd
