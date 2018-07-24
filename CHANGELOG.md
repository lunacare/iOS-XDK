# LayerXDK Changelog

## 4.1.0

### Enhancements

* Adds support for audio and video messages, including the large size variants. [IOS-3378], [IOS-3387]

## 4.0.2

### Enhancements

* Added an ability to register message presenters for different size variants. [IOS-3425]

## 4.0.1

### Public API Changes

* Changed the `LYRUIProductMessage` object's `price` property from `double` to `NSNumber` to support null values. This also affects the corresponding `LYRUIProductMessageSerializer` and `LYRUIProductMessageCompositeViewPresenter` classes. [IOS-3420]

### Enhancements

* Support for sending messages with a single link (URL). [IOS-3362]
* Adds sender's name for incoming messages. [IOS-3412]

### Bug fixes

* Fixed message status to display as `sent` instead of `pending` when the current user is the only participant in a conversation. [IOS-3419]
* Fixed image orientation when choosing 'Take Photo' from the compose bar. [IOS-3421]

## 4.0.0

### Enhancements

* Messages are moved to the bottom of messages list
* Added conflict resolution to choice messages and choice buttons
* Improved keyboard hiding and animations in conversation view

### Bug fixes

* Fixed support for legacy message types
* Fixed crash when going out from conversation on iOS 10
* Fixed multiple minor UI issues

## 1.0.0-pre2

### Enhancements

* Added 3d touch preview of message actions
* Added methods for adding custom message types
* Added persistence of selections in Choice Message and Choice Button when selecting offline

### Bug fixes

* Fixed crash in `LYRUIMessageListView` when presenting `LYRConversation` without any messages
* Added selected state to the `LYRUIIdentityListView` items
* Fixed persistence of Carousel message content offset
* Fixed updating message statuses in `LYRUIMessageListView`
* Fixed input field and send button state in `LYRUIConversationView` after sending a message
* Fixed sending message responses
* Fixed multiple UI layout issues

## 1.0.0-pre1

### Initial release
