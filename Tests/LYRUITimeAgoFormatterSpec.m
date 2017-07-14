#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <OCMockito/OCMockito.h>
#import <Atlas/LYRUITimeAgoFormatter.h>

SpecBegin(LYRUITimeAgoFormatter)

describe(@"LYRUITimeAgoFormatter", ^{
    __block LYRUITimeAgoFormatter *formatter;
    
    beforeEach(^{
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        calendar.locale = locale;
        calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        
        formatter = [[LYRUITimeAgoFormatter alloc] initWithCalendar:calendar];
    });
    
    afterEach(^{
        formatter = nil;
    });
    
    describe(@"", ^{
        __block NSDate *currentTimeFixture;
        __block NSString *returnedString;
        
        beforeEach(^{
            currentTimeFixture = [NSDate dateWithTimeIntervalSince1970:578406896];
        });
        
        context(@"when the time is one second before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578406895];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '1 min ago", ^{
                expect(returnedString).to.equal(@"1 min ago");
            });
        });
        context(@"when the time is one min before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578406836];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '1 min ago", ^{
                expect(returnedString).to.equal(@"1 min ago");
            });
        });
        context(@"when the time is 61 sec before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578406835];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '1 min ago", ^{
                expect(returnedString).to.equal(@"1 min ago");
            });
        });
        context(@"when the time is two mins before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578406776];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '2 mins ago", ^{
                expect(returnedString).to.equal(@"2 mins ago");
            });
        });
        context(@"when the time is one hour before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578403296];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '60 mins ago", ^{
                expect(returnedString).to.equal(@"60 mins ago");
            });
        });
        context(@"when the time is one second less than two hours before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578399697];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '119 mins ago", ^{
                expect(returnedString).to.equal(@"119 mins ago");
            });
        });
        context(@"when the time is two hours before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578399696];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '2 hours ago", ^{
                expect(returnedString).to.equal(@"2 hours ago");
            });
        });
        context(@"when the time is two hours and one second before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578399695];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '2 hours ago", ^{
                expect(returnedString).to.equal(@"2 hours ago");
            });
        });
        context(@"when the time is one day before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578320496];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '24 hours ago", ^{
                expect(returnedString).to.equal(@"24 hours ago");
            });
        });
        context(@"when the time is one second less than two days before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578234097];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '47 hours ago", ^{
                expect(returnedString).to.equal(@"47 hours ago");
            });
        });
        context(@"when the time is two days before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578234096];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '2 days ago", ^{
                expect(returnedString).to.equal(@"2 days ago");
            });
        });
        context(@"when the time is two days and one second before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:578234095];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '2 days ago", ^{
                expect(returnedString).to.equal(@"2 days ago");
            });
        });
        context(@"when the time is 30 days before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:575814896];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '30 days ago", ^{
                expect(returnedString).to.equal(@"30 days ago");
            });
        });
        context(@"when the time is one second after midnight of the day two months before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:573177601];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '60 days ago", ^{
                expect(returnedString).to.equal(@"60 days ago");
            });
        });
        context(@"when the time is on the midnight of the day two months before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:573177600];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '60 days ago", ^{
                expect(returnedString).to.equal(@"60 days ago");
            });
        });
        context(@"when the time is one second to the midnight of the day two months before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:573177599];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '2 months ago", ^{
                expect(returnedString).to.equal(@"2 months ago");
            });
        });
        context(@"when the time is two months before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:573136496];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '2 months ago", ^{
                expect(returnedString).to.equal(@"2 months ago");
            });
        });
        context(@"when the time is 1 year before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:546784496];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '1 year ago", ^{
                expect(returnedString).to.equal(@"1 year ago");
            });
        });
        context(@"when the time is 2 years before current time", ^{
            beforeEach(^{
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:515248496];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '2 years ago", ^{
                expect(returnedString).to.equal(@"2 years ago");
            });
        });
        context(@"when the time is long before the current time", ^{
            beforeEach(^{
                NSDate *time  = [NSDate dateWithTimeIntervalSince1970:0];
                returnedString = [formatter timeAgoStringForTime:time withCurrentTime:currentTimeFixture];
            });
            
            it(@"should return '18 years ago'", ^{
                expect(returnedString).to.equal(@"18 years ago");
            });
        });
    });
});

SpecEnd
