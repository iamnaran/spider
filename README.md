# spider

A new Flutter project.

## Getting Started


# Create Session

- POST https://photoslibrary.googleapis.com/v1/picker/createSession



# Create Session



# Redirect Users to Google Photos App

- Once you have pickerUri:
- It automatically opens Google Photos native app

# Poll Session Until Done

- GET https://photoslibrary.googleapis.com/v1/picker/getSession?sessionId=abc123
- mediaItemsSet: false	User still selecting
- mediaItemsSet: true   User finished selecting
- result.mediaItems[]  Array of selected items
- 

![A](files/a.png) ![B](files/b.png)

