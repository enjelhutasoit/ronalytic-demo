# Ronalytic Demo

A SwiftUI app that uses the [Ronalytic SDK](https://github.com/enjelhutasoit-com/ronalytic-sdk)
only through its public API, like a real client would.

![Demo](docs/demo.gif)

## Run it

1. Clone both repos next to each other:
```
   projects/
   ├── ronalytic-sdk/
   └── ronalytic-demo/
```
2. Open `RonalyticDemo.xcodeproj` in Xcode 16 or newer.
3. Pick an iPhone simulator (iOS 16 or newer) and press Run.
4. Optional, to see uploads: open https://webhook.site, copy your unique
   https URL, paste it in Settings, then relaunch the app.
5. Optional, for the widget: replace `DemoShared.groupID` with your own
   App Group (`group.com.<you>.ronalytic-demo`) and add that capability to
   both the app and widget targets.

## What each screen proves

| Screen | SDK feature shown |
|---|---|
| Launch | `iOSDefaults`, `configure`, console destination, verbose logger |
| Track, Screen, Identify | Non-blocking calls, literal properties, user ID on later events |
| Flush | Batch upload and per-event delivery result |
| Diagnostics | Read-only metrics: stored, dropped, retries, delivered |
| Settings, consent | Consent gate. Unknown consent drops events, by design |
| Settings, opt-out | Opt-out applies instantly, in the app and the widget |
| Widget | `RonalyticExtension` writes to the shared App Group queue, the app uploads |

## Try this

1. First launch: tap Track purchase. Diagnostics shows the event dropped, because consent is unknown.
2. Set consent to Granted, track again. The event is stored and printed in the console.
3. Paste a webhook.site URL, relaunch, track, then Flush. The batch appears on webhook.site.
4. Turn on "Stop tracking me". New events are dropped and counted as opt-out.
5. Add the widget, then Flush from the app. The widget's event is in the same batch.

## Limits of this demo

- A new endpoint URL applies after a relaunch, because the SDK configures once.
- The App Group may not work on a physical device with a free Apple ID. The simulator works.
- The SDK is linked by local path until version 1.0.0 is tagged.
