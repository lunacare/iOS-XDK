#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <Atlas/LYRUIMessageTimeDefaultFormatter.h>

SpecBegin(LYRUIMessageTimeDefaultFormatter)

describe(@"LYRUIMessageTimeDefaultFormatter", ^{
    __block LYRUIMessageTimeDefaultFormatter *formatter;
    
    beforeEach(^{
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        calendar.locale = locale;
        calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = locale;
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        
        formatter = [[LYRUIMessageTimeDefaultFormatter alloc] initWithCalendar:calendar
                                                                 dateFormatter:dateFormatter];
    });
    
    afterEach(^{
        formatter = nil;
    });
    
    describe(@"stringForMessageTime:withCurrentTime:", ^{
        __block NSDate *currentTimeFixture;
        __block NSString *returnedString;
        
        beforeEach(^{
            currentTimeFixture = [NSDate dateWithTimeIntervalSince1970:578406896];
        });
        
        context(@"when message time is during the same day as current time", ^{
            beforeEach(^{
                NSDate *messageTime = [NSDate dateWithTimeIntervalSince1970:578402553];
                returnedString = [formatter stringForMessageTime:messageTime withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '11:22 AM'", ^{
                expect(returnedString).to.equal(@"11:22 AM");
            });
        });
        context(@"when message time is on the midnight before the current time", ^{
            beforeEach(^{
                NSDate *messageTime = [NSDate dateWithTimeIntervalSince1970:578361600];
                returnedString = [formatter stringForMessageTime:messageTime withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '12:00 AM'", ^{
                expect(returnedString).to.equal(@"12:00 AM");
            });
        });
        context(@"when message time is one second to midnight before the current time", ^{
            beforeEach(^{
                NSDate *messageTime = [NSDate dateWithTimeIntervalSince1970:578361599];
                returnedString = [formatter stringForMessageTime:messageTime withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Apr 29, 1988'", ^{
                expect(returnedString).to.equal(@"Apr 29, 1988");
            });
        });
        context(@"when message time long before the current time", ^{
            beforeEach(^{
                NSDate *messageTime = [NSDate dateWithTimeIntervalSince1970:0];
                returnedString = [formatter stringForMessageTime:messageTime withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return 'Jan 1, 1970'", ^{
                expect(returnedString).to.equal(@"Jan 1, 1970");
            });
        });
    });
});

SpecEnd
