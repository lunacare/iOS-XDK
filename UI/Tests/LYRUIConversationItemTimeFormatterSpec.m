#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIConversationItemTimeFormatter.h>

SpecBegin(LYRUIConversationItemTimeFormatter)

describe(@"LYRUIConversationItemTimeFormatter", ^{
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block LYRUIConversationItemTimeFormatter *formatter;
    
    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        calendar.locale = locale;
        calendar.timeZone = timeZone;
        [given([injectorMock objectOfType:[NSCalendar class]]) willReturn:calendar];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = locale;
        dateFormatter.timeZone = timeZone;
        [given([injectorMock objectOfType:[NSDateFormatter class]]) willReturn:dateFormatter];
        
        formatter = [[LYRUIConversationItemTimeFormatter alloc] initWithConfiguration:configurationMock];
    });
    
    afterEach(^{
        formatter = nil;
    });
    
    describe(@"stringForTime:withCurrentTime:", ^{
        __block NSDate *currentTimeFixture;
        __block NSString *returnedString;
        
        beforeEach(^{
            currentTimeFixture = [NSDate dateWithTimeIntervalSince1970:578406896];
        });
        
        context(@"when the time is one second before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578406895];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '12:34'", ^{
                expect(returnedString).to.equal(@"12:34 PM");
            });
        });
        context(@"when the time is one min before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578406836];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '12:33'", ^{
                expect(returnedString).to.equal(@"12:33 PM");
            });
        });
        context(@"when the time is two mins before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578406776];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '12:32'", ^{
                expect(returnedString).to.equal(@"12:32 PM");
            });
        });
        context(@"when the time is one hour before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578403296];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '11:34'", ^{
                expect(returnedString).to.equal(@"11:34 AM");
            });
        });
        context(@"when the time is two hours before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578399696];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '10:34'", ^{
                expect(returnedString).to.equal(@"10:34 AM");
            });
        });
        context(@"when the time is one day before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578320496];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Yesterday'", ^{
                expect(returnedString).to.equal(@"Yesterday");
            });
        });
        context(@"when the time is two days before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578234096];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Thu'", ^{
                expect(returnedString).to.equal(@"Thu");
            });
        });
        context(@"when the time is 6 days before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:577888496];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Sun'", ^{
                expect(returnedString).to.equal(@"Sun");
            });
        });
        context(@"when the time is 7 days before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:577802096];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Apr'", ^{
                expect(returnedString).to.equal(@"Apr 23");
            });
        });
        context(@"when the time is 8 days before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:577715696];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Apr'", ^{
                expect(returnedString).to.equal(@"Apr 22");
            });
        });
        context(@"when the time is 30 days before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:575814896];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Mar'", ^{
                expect(returnedString).to.equal(@"Mar 31");
            });
        });
        context(@"when the time is two months before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:573136496];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Feb'", ^{
                expect(returnedString).to.equal(@"Feb 29");
            });
        });
        context(@"when the time is 1 year before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:546784496];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '4/30/87'", ^{
                expect(returnedString).to.equal(@"4/30/87");
            });
        });
        context(@"when the time is 2 years before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:515248496];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '4/30/86'", ^{
                expect(returnedString).to.equal(@"4/30/86");
            });
        });
        context(@"when the time is long before the current time", ^{
            beforeEach(^{
                NSDate *time  = [NSDate dateWithTimeIntervalSince1970:0];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '1/1/70'", ^{
                expect(returnedString).to.equal(@"1/1/70");
            });
        });
    });
});

SpecEnd

