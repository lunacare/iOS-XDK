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

@interface ATLAvatarView (Tests)
@property (nonatomic, readwrite) ATLPresenceStatusView *presenceStatusView;
@end

@interface ATLAvatarViewTest : XCTestCase
@end

@implementation ATLAvatarViewTest {
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

- (void)testPresenceStatusViewStyling
{
    // Offline
    _avatarView.avatarItem = [ATLUserMock userWithMockUserName:ATLMockUserNameAmar presenceStatus:LYRIdentityPresenceStatusOffline];
    expect(_avatarView.presenceStatusView.statusColor).to.equal([UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:156.0/255.0 alpha:1.0]);
    expect(_avatarView.presenceStatusView.mode).to.equal(ATLMPresenceStatusViewModeBordered);

    // Invisible
    _avatarView.avatarItem = [ATLUserMock userWithMockUserName:ATLMockUserNameBlake presenceStatus:LYRIdentityPresenceStatusInvisible];
    expect(_avatarView.presenceStatusView.statusColor).to.equal([UIColor colorWithRed:79.0/255.0 green:191.0/255.0 blue:98.0/255.0 alpha:1.0]);
    expect(_avatarView.presenceStatusView.mode).to.equal(ATLMPresenceStatusViewModeBordered);
    
    // Available
    _avatarView.avatarItem = [ATLUserMock userWithMockUserName:ATLMockUserNameKevin presenceStatus:LYRIdentityPresenceStatusAvailable];
    expect(_avatarView.presenceStatusView.statusColor).to.equal([UIColor colorWithRed:79.0/255.0 green:191.0/255.0 blue:98.0/255.0 alpha:1.0]);
    expect(_avatarView.presenceStatusView.mode).to.equal(ATLMPresenceStatusViewModeFill);

    // Away
    _avatarView.avatarItem = [ATLUserMock userWithMockUserName:ATLMockUserNameKlemen presenceStatus:LYRIdentityPresenceStatusAway];
    expect(_avatarView.presenceStatusView.statusColor).to.equal([UIColor colorWithRed:247.0/255.0 green:202.0/255.0 blue:64.0/255.0 alpha:1.0]);
    expect(_avatarView.presenceStatusView.mode).to.equal(ATLMPresenceStatusViewModeFill);

    // Busy
    _avatarView.avatarItem = [ATLUserMock userWithMockUserName:ATLMockUserNameSteven presenceStatus:LYRIdentityPresenceStatusBusy];
    expect(_avatarView.presenceStatusView.statusColor).to.equal([UIColor colorWithRed:230.0/255.0 green:68.0/255.0 blue:63.0/255.0 alpha:1.0]);
    expect(_avatarView.presenceStatusView.mode).to.equal(ATLMPresenceStatusViewModeFill);
}

- (void)testPresenceStatusViewEnabled
{
    expect(_avatarView.presenceStatusView.isHidden).to.beFalsy();
    
    _avatarView.presenceStatusEnabled = NO;
    expect(_avatarView.presenceStatusView.isHidden).to.beTruthy();
    
    _avatarView.presenceStatusEnabled = YES;
    expect(_avatarView.presenceStatusView.isHidden).to.beFalsy();
}

@end
