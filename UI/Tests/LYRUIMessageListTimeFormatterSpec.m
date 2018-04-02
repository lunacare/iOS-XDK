#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <LayerXDK/LYRUIConfiguration+DependencyInjection.h>
#import <LayerXDK/LYRUIMessageListTimeFormatter.h>

SpecBegin(LYRUIMessageListTimeFormatter)

describe(@"LYRUIMessageListTimeFormatter", ^{
    __block LYRUIConfiguration *configurationMock;
    __block id<LYRUIDependencyInjection> injectorMock;
    __block LYRUIMessageListTimeFormatter *formatter;
    
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
        
        formatter = [[LYRUIMessageListTimeFormatter alloc] initWithConfiguration:configurationMock];
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
            
            it(@"should return 'Fri 12:34 PM'", ^{
                expect(returnedString).to.equal(@"Fri 12:34 PM");
            });
        });
        context(@"when the time is two days before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578234096];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Thu 12:34 PM'", ^{
                expect(returnedString).to.equal(@"Thu 12:34 PM");
            });
        });
        context(@"when the time is 6 days before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:577888496];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Sun 12:34 PM'", ^{
                expect(returnedString).to.equal(@"Sun 12:34 PM");
            });
        });
        context(@"when the time is 7 days before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:577802096];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Sat 12:34 PM'", ^{
                expect(returnedString).to.equal(@"Sat 12:34 PM");
            });
        });
        context(@"when the time is 8 days before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:577715696];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Fri, April 22, 12:34 PM'", ^{
                expect(returnedString).to.equal(@"Fri, April 22, 12:34 PM");
            });
        });
        context(@"when the time is 30 days before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:575814896];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Thu, March 31, 12:34 PM'", ^{
                expect(returnedString).to.equal(@"Thu, March 31, 12:34 PM");
            });
        });
        context(@"when the time is two months before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:573136496];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Mon, February 29, 12:34 PM'", ^{
                expect(returnedString).to.equal(@"Mon, February 29, 12:34 PM");
            });
        });
        context(@"when the time is 1 year before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:546784496];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Thu, April 30, 1987, 12:34 PM'", ^{
                expect(returnedString).to.equal(@"Thu, April 30, 1987, 12:34 PM");
            });
        });
        context(@"when the time is 2 years before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:515248496];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Wed, April 30, 1986, 12:34 PM'", ^{
                expect(returnedString).to.equal(@"Wed, April 30, 1986, 12:34 PM");
            });
        });
        context(@"when the time is long before the current time", ^{
            beforeEach(^{
                NSDate *time  = [NSDate dateWithTimeIntervalSince1970:0];
                returnedString = [formatter stringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Thu, January 1, 1970, 12:00 AM'", ^{
                expect(returnedString).to.equal(@"Thu, January 1, 1970, 12:00 AM");
            });
        });
    });
});

SpecEnd


