# TimeTrackerPersistence

Exposes a persistence API to be consumed by the main app. Currently, only in memory and UserDefaults storage
is supported, but can be easily extended by using a more robust persistence option such as a real database;
using GRDB or CoreData.
