//
//  LayerXDKUI.h
//
//  Created by Kevin Coleman on 10/27/14.
//  Copyright (c) 2015 Layer. All rights reserved.
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

#import <Foundation/Foundation.h>

#import "LYRUIConfiguration.h"

///------------
/// @name Views
///------------

#import "LYRUIViewWithLayout.h"
#import "LYRUIPresenceView.h"
#import "LYRUIAvatarView.h"
#import "LYRUIBaseItemView.h"
#import "LYRUIBaseListView.h"
#import "LYRUIIdentityItemView.h"
#import "LYRUIIdentityListView.h"
#import "LYRUIConversationItemView.h"
#import "LYRUIConversationListView.h"
#import "LYRUIMessageItemView.h"
#import "LYRUIMessageListView.h"
#import "LYRUISendButton.h"
#import "LYRUIComposeBar.h"
#import "LYRUIConversationView.h"
#import "LYRUITextMessageContentView.h"
#import "LYRUIStandardMessageContainerView.h"
#import "LYRUIMessageViewContainer.h"

///----------------
/// @name Utilities
///----------------

#import "LYRUIMessageListTypingIndicatorsController.h"
#import "LYRUIMessageSender.h"
#import "LYRMessage+LYRUIHelpers.h"
#import "LYRMessagePart+LYRUIHelpers.h"
#import "LYRUIReusableViewsQueue.h"

///----------------
/// @name Protocols
///----------------

#import "LYRUIConfigurable.h"
#import "LYRUIViewLayout.h"
#import "LYRUIListView.h"
#import "LYRUIListLayout.h"
#import "LYRUIListDelegate.h"
#import "LYRUIListDataSource.h"
#import "LYRUIPresenceIndicatorTheme.h"
#import "LYRUIParticipantsCountViewTheme.h"
#import "LYRUIParticipantsFiltering.h"
#import "LYRUIParticipantsSorting.h"
#import "LYRUIMessageListActionHandlingDelegate.h"
#import "LYRUIMessageListTypingIndicatorsControlling.h"
#import "LYRUIMessageItemContentPresenting.h"
#import "LYRUIMessageTypeSerializing.h"
#import "LYRUIBaseMessageTypeSerializer.h"
#import "LYRUIIdentityNameFormatting.h"
#import "LYRUITextMessageSerializer.h"
#import "LYRUIMessageItemContentBasePresenter.h"
#import "LYRUITextMessageContentViewPresenter.h"
#import "LYRUIMessageItemContentContainerPresenting.h"
#import "LYRUIStandardMessageContainerViewPresenter.h"

///--------------
/// @name Layouts
///--------------

#import "LYRUIBaseItemViewLayout.h"

///-------------
/// @name Themes
///-------------

#import "LYRUIPresenceIndicatorTheme.h"
#import "LYRUIParticipantsCountViewTheme.h"
#import "LYRUIAvatarViewTheme.h"

///-------------
/// @name Models
///-------------

#import "LYRUIMessageType.h"
#import "LYRUIMessageMetadata.h"
#import "LYRUIMessageAction.h"
#import "LYRUIMessageTypeStatus.h"
#import "LYRUIListSection.h"
#import "LYRUITextMessage.h"

/**
 @abstract Returns the XDK UI version as a string.
 */
extern NSString *const LYRUIVersionString;

