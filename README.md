# Spider

A Flutter project for integrating Google Photos Picker functionality.

---

## Getting Started

Follow these steps:

---

## 1. Google Photos API Scopes

Define the required scopes:

```dart
final List<String> _scopes = [
  'https://www.googleapis.com/auth/photoslibrary.appendonly',
  'https://www.googleapis.com/auth/photoslibrary.readonly',
  'https://www.googleapis.com/auth/photoslibrary',
];

## 2. Request Login

```dart
Authenticate the user with Google Sign-In:

final account = await GoogleSignIn.instance.authenticate(
  scopeHint: _scopes,
);


## 3. Prompt for Google Photos Picker

Request authorization headers and retrieve the access token:

```dart
final headers = await account.authorizationClient.authorizationHeaders(
  _scopes,
  promptIfNecessary: true,
);

final accessToken = headers?['Authorization']?.split(' ').last;

if (accessToken == null) {
  AppLogger.showDebug('Failed to retrieve access token.');
} else {
  AppLogger.showDebug('Google Photos Access Token: $accessToken');
}

return accessToken;


## 4.Create Session

- Request from Backend,  to be in Safe Side for scope mismatch


## 5. Verify Access Token

To verify the access token, use:

GET https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=<your_access_token>


## 6. Redirect Users to Google Photos App

Once you have the pickerUri, you can open the Google Photos native app directly for item selection.



## 7. Poll Session Until Done

Check session status until the user completes their selection:

mediaItemsSet: false — User is still selecting

mediaItemsSet: true — User finished selecting

result.mediaItems[] — Array of selected items