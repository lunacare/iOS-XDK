#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Atlas/LYRUIDependencyInjector.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIPresenceView.h>
#import <Atlas/LYRUIPresenceViewDefaultTheme.h>
#import <Atlas/LYRUIPresenceViewConfiguration.h>
#import <Atlas/LYRUIAvatarView.h>
#import <Atlas/LYRUIAvatarViewDefaultTheme.h>
#import <Atlas/LYRUIAvatarViewConfiguration.h>
#import <Atlas/LYRUIImageWithLettersView.h>
#import <Atlas/LYRUIImageWithLettersViewConfiguration.h>
#import <Atlas/LYRUIBaseItemView.h>
#import <Atlas/LYRUIBaseItemViewDefaultTheme.h>
#import <Atlas/LYRUIBaseItemViewLayout.h>
#import <Atlas/LYRUIConversationItemView.h>
#import <Atlas/LYRUIConversationItemViewUnreadTheme.h>
#import <Atlas/LYRUIConversationItemViewLayoutMetrics.h>
#import <Atlas/LYRUIConversationItemViewConfiguration.h>
#import <Atlas/LYRUIConversationItemAccessoryViewProvider.h>
#import <Atlas/LYRUIConversationItemTitleFormatter.h>
#import <Atlas/LYRUIMessageTextDefaultFormatter.h>
#import <Atlas/LYRUIMessageTimeDefaultFormatter.h>
#import <Atlas/LYRUIConversationListView.h>
#import <Atlas/LYRUIConversationListViewConfiguration.h>
#import <Atlas/LYRUIListCellConfiguration.h>
#import <Atlas/LYRUIListHeaderView.h>
#import <Atlas/LYRUIListSupplementaryViewConfiguration.h>
#import <Atlas/LYRUIListLayout.h>
#import <Atlas/LYRUIIdentityItemView.h>
#import <Atlas/LYRUIIdentityItemViewLayoutMetrics.h>
#import <Atlas/LYRUIIdentityItemViewConfiguration.h>
#import <Atlas/LYRUIIdentityItemAccessoryViewProvider.h>
#import <Atlas/LYRUIIdentityNameFormatter.h>
#import <Atlas/LYRUITimeAgoFormatter.h>
#import <Atlas/LYRUIIdentityListView.h>
#import <Atlas/LYRUIIdentityListViewConfiguration.h>
#import <Atlas/LYRUIImageFetcher.h>
#import <Atlas/LYRUIImageFactory.h>
#import <Atlas/LYRUIInitialsFormatter.h>
#import <Atlas/LYRUIDataFactory.h>
#import <Atlas/LYRUIDispatcher.h>
#import <Atlas/NSCache+LYRUIImageCaching.h>

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
    
    describe(@"configurationForViewClass:", ^{
        context(@"for LYRUIPresenceView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector configurationForViewClass:[LYRUIPresenceView class]];
            });
            
            it(@"should return configuration of `LYRUIPresenceViewConfiguration` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIPresenceViewConfiguration class]);
            });
        });
        
        context(@"for LYRUIAvatarView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector configurationForViewClass:[LYRUIAvatarView class]];
            });
            
            it(@"should return configuration of `LYRUIAvatarViewConfiguration` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIAvatarViewConfiguration class]);
            });
        });
        
        context(@"for LYRUIImageWithLettersView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector configurationForViewClass:[LYRUIImageWithLettersView class]];
            });
            
            it(@"should return configuration of `LYRUIImageWithLettersViewConfiguration` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIImageWithLettersViewConfiguration class]);
            });
        });
        
        context(@"for LYRUIConversationItemView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector configurationForViewClass:[LYRUIConversationItemView class]];
            });
            
            it(@"should return configuration of `LYRUIConversationItemViewConfiguration` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIConversationItemViewConfiguration class]);
            });
        });
        
        context(@"for UICollectionViewCell", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector configurationForViewClass:[UICollectionViewCell class]];
            });
            
            it(@"should return configuration of `LYRUIListCellConfiguration` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIListCellConfiguration class]);
            });
        });
        
        context(@"for LYRUIListHeaderView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector configurationForViewClass:[LYRUIListHeaderView class]];
            });
            
            it(@"should return configuration of `LYRUIListSupplementaryViewConfiguration` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIListSupplementaryViewConfiguration class]);
            });
        });
        
        context(@"for LYRUIConversationListView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector configurationForViewClass:[LYRUIConversationListView class]];
            });
            
            it(@"should return configuration of `LYRUIConversationListViewConfiguration` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIConversationListViewConfiguration class]);
            });
        });
        
        context(@"for LYRUIIdentityItemView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector configurationForViewClass:[LYRUIIdentityItemView class]];
            });
            
            it(@"should return configuration of `LYRUIIdentityItemViewConfiguration` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIIdentityItemViewConfiguration class]);
            });
        });
        
        context(@"for LYRUIIdentityListView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector configurationForViewClass:[LYRUIIdentityListView class]];
            });
            
            it(@"should return configuration of `LYRUIIdentityListViewConfiguration` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIIdentityListViewConfiguration class]);
            });
        });
    });
    
    describe(@"layoutForViewClass:", ^{
        context(@"for LYRUIConversationItemView", ^{
            __block id returnedObject;
            
            beforeEach(^{
                returnedObject = [injector layoutForViewClass:[LYRUIConversationItemView class]];
            });
            
            it(@"should return layout conforming to `LYRUIBaseItemViewTheme` protocol", ^{
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
            
            it(@"should return layout conforming to `LYRUIBaseItemViewTheme` protocol", ^{
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
            
            it(@"should return layout conforming to `LYRUIBaseItemViewTheme` protocol", ^{
                expect(returnedObject).to.conformTo(@protocol(LYRUIBaseItemViewLayout));
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
            
            it(@"should return object of `LYRUIConversationItemAccessoryViewProvider` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIConversationItemAccessoryViewProvider class]);
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
            
            context(@"for `LYRUIIdentityItemViewConfiguration` class", ^{
                __block id returnedObject;
                
                beforeEach(^{
                    returnedObject = [injector protocolImplementation:@protocol(LYRUITimeFormatting)
                                                             forClass:[LYRUIIdentityItemViewConfiguration class]];
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
            
            it(@"should return object of `LYRUIIdentityItemAccessoryViewProvider` type", ^{
                expect(returnedObject).to.beAKindOf([LYRUIIdentityItemAccessoryViewProvider class]);
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
    });
});

SpecEnd
