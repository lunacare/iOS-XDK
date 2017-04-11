//
//  ATLPresenceViewTest.m
//  Atlas
//
//  Created by JP McGlone on 4/11/17.
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

#import <XCTest/XCTest.h>
#import "ATLTestInterface.h"

@interface ATLPresenceStatusViewTest : XCTestCase
@end

@interface ATLAvatarView (Tests)
@property (nonatomic, readwrite) ATLPresenceStatusView *presenceStatusView;
@end

@implementation ATLPresenceStatusViewTest{
    ATLAvatarView *_avatarView;
}

- (void)setUp
{
    [super setUp];
    _avatarView = [[ATLAvatarView alloc] init];
}

- (void)tearDown
{
    _avatarView = nil;
    [super tearDown];
}

- (void)testPresenceStatusView
{
    _avatarView.presenceStatus = LYRIdentityPresenceStatusUnknown;
    expect(_avatarView.presenceStatusView.statusColor).to.equal([UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:156.0/255.0 alpha:1.0]);
    expect(_avatarView.presenceStatusView.mode).to.equal(ATLMPresenceStatusViewModeBordered);

    _avatarView.presenceStatus = LYRIdentityPresenceStatusOffline;
    expect(_avatarView.presenceStatusView.statusColor).to.equal([UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:156.0/255.0 alpha:1.0]);
    expect(_avatarView.presenceStatusView.mode).to.equal(ATLMPresenceStatusViewModeBordered);

    _avatarView.presenceStatus = LYRIdentityPresenceStatusUnset;
    expect(_avatarView.presenceStatusView.statusColor).to.equal([UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:156.0/255.0 alpha:1.0]);
    expect(_avatarView.presenceStatusView.mode).to.equal(ATLMPresenceStatusViewModeBordered);

    _avatarView.presenceStatus = LYRIdentityPresenceStatusIdle;
    expect(_avatarView.presenceStatusView.statusColor).to.equal([UIColor colorWithRed:247.0/255.0 green:202.0/255.0 blue:64.0/255.0 alpha:1.0]);
    expect(_avatarView.presenceStatusView.mode).to.equal(ATLMPresenceStatusViewModeBordered);

    _avatarView.presenceStatus = LYRIdentityPresenceStatusInvisible;
    expect(_avatarView.presenceStatusView.statusColor).to.equal([UIColor colorWithRed:79.0/255.0 green:191.0/255.0 blue:98.0/255.0 alpha:1.0]);
    expect(_avatarView.presenceStatusView.mode).to.equal(ATLMPresenceStatusViewModeBordered);

    _avatarView.presenceStatus = LYRIdentityPresenceStatusAway;
    expect(_avatarView.presenceStatusView.statusColor).to.equal([UIColor colorWithRed:247.0/255.0 green:202.0/255.0 blue:64.0/255.0 alpha:1.0]);
    expect(_avatarView.presenceStatusView.mode).to.equal(ATLMPresenceStatusViewModeFill);

    _avatarView.presenceStatus = LYRIdentityPresenceStatusBusy;
    expect(_avatarView.presenceStatusView.statusColor).to.equal([UIColor colorWithRed:230.0/255.0 green:68.0/255.0 blue:63.0/255.0 alpha:1.0]);
    expect(_avatarView.presenceStatusView.mode).to.equal(ATLMPresenceStatusViewModeFill);

    _avatarView.presenceStatus = LYRIdentityPresenceStatusAvailable;
    expect(_avatarView.presenceStatusView.statusColor).to.equal([UIColor colorWithRed:247.0/255.0 green:202.0/255.0 blue:64.0/255.0 alpha:1.0]);
    expect(_avatarView.presenceStatusView.mode).to.equal(ATLMPresenceStatusViewModeFill);
}

@end
