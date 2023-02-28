# Time Tracker

## Important! 

For unknown reasons, running the app with the debugger attached causes inconsistencies with `UserDefaults`, as the 
data is erratically and erronously stored on some occasions. I have yet to determine the cause of this.

Build and run the app once and then detach the debugger.

## Tech stack, architecture and project set-up

The app is built using `SwiftUI` and the `Composable Architecture`, with multiple **local Swift packages** to provide
modularity and define clear API boundaries.

The are no requirements for project set-up, other than opening the `.xcworkspace` is mandatory, as it connects 
all pieces together. 

An `.xcworkspace` was chosen as it's a clean and efficient way of grouping multiple packages and projects together.

In example, if we wanted to add a `macOS` project, we could easily do so by adding it to the `.xcworkspace` and linking
the different packages.

## Features

The app provides the following features:
1. Shows a list of already entered entries.
2. Enables the user to delete an entry by long-pressing the entry.
3. Enables the user to start a new entry. 
4. Enables the user to complete an entry.
5. Persists entries using `UserDefaults`.
6. Persists, tracks and restarts running entries through app launches.
7. Extendable, as everything's modularised.

## Resource handling

Assets and Localization are processed with the industry standard tool for typed resources - [SwiftGen](https://github.com/SwiftGen/SwiftGen).

## Tests

Unit tests are implemented for the `Domain`, as that's where the business logic resides and is the core driver of all
functionality. 

## Potential improvements

The biggest improvement that can be done is to use a robust persistence container, such as `SQLite`, via `GRDB` or `CoreData`. 
My definite preference is `GRDB`, as `CoreData`'s API suffers from `Objective-C` burdens. 
