An iOS mobile application in Swift, created to test background task completion.

# Description

In this example, an application will be demonstrated where the user can start a counter that will not be interrupted when the user exits the application but will continue counting in the background. It will stop when the user re-enters the application and clicks the stop button, or removes the application from the App Switcher, which offers additional control mechanisms to the user along with the Background App Refresh setting.

While running in the background, the application will notify the user via local notifications every time the counter reaches a multiple of 10, i.e., 10, 20, 30, etc. This example demonstrates the continuation of the foreground task of the application when it is switched to the background.

When the time assigned by iOS for the background task expires (about 30 seconds), the user will be notified with a notification indicating the counter's current value and that they need to return to the application to continue counting (upon which the application will automatically resume counting until the user stops it by pressing the button).

# Demo

The counting continues in the background even when the user is not in the app, and informs the user whenever the counter has reached a new multiple of 10. At the moment the counter has reached 81, iOS has suspended the background task since it has been about 30 seconds since the app was active, so the app informs the user that the counter has stopped. The user therefore returns to the app so the counting can continue.

<img src="./demo.gif" height="600">
