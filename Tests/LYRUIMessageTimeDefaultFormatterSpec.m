#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <Atlas/LYRUIConfiguration+DependencyInjection.h>
#import <Atlas/LYRUIMessageTimeDefaultFormatter.h>

SpecBegin(LYRUIMessageTimeDefaultFormatter)

describe(@"LYRUIMessageTimeDefaultFormatter", ^{
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block LYRUIMessageTimeDefaultFormatter *formatter;
    
    beforeEach(^{
        configurationMock = mock([LYRUIConfiguration class]);
        injectorMock = mockProtocol(@protocol(LYRUIDependencyInjection));
        [given(configurationMock.injector) willReturn:injectorMock];
        
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        calendar.locale = locale;
        calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [given([injectorMock objectOfType:[NSCalendar class]]) willReturn:calendar];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = locale;
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [given([injectorMock objectOfType:[NSDateFormatter class]]) willReturn:dateFormatter];
        
        formatter = [[LYRUIMessageTimeDefaultFormatter alloc] initWithConfiguration:configurationMock];
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
        
        context(@"when message time is during the same day as current time", ^{
            beforeEach(^{
                NSDate *messageTime = [NSDate dateWithTimeIntervalSince1970:578402553];
                returnedString = [formatter stringForTime:messageTime withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '11:22 AM'", ^{
                expect(returnedString).to.equal(@"11:22 AM");
            });
        });
        context(@"when message time is on the midnight before the current time", ^{
            beforeEach(^{
                NSDate *messageTime = [NSDate dateWithTimeIntervalSince1970:578361600];
                returnedString = [formatter stringForTime:messageTime withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '12:00 AM'", ^{
                expect(returnedString).to.equal(@"12:00 AM");
            });
        });
        context(@"when message time is one second to midnight before the current time", ^{
            beforeEach(^{
                NSDate *messageTime = [NSDate dateWithTimeIntervalSince1970:578361599];
                returnedString = [formatter stringForTime:messageTime withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Apr 29, 1988'", ^{
                expect(returnedString).to.equal(@"Apr 29, 1988");
            });
        });
        context(@"when message time long before the current time", ^{
            beforeEach(^{
                NSDate *messageTime = [NSDate dateWithTimeIntervalSince1970:0];
                returnedString = [formatter stringForTime:messageTime withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Jan 1, 1970'", ^{
                expect(returnedString).to.equal(@"Jan 1, 1970");
            });
        });
    });
});

SpecEnd
