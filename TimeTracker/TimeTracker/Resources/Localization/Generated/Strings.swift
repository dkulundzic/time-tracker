// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Delete
  internal static let actionDelete = L10n.tr("Localizable", "action_delete", fallback: "Delete")
  /// New entry
  internal static let entryManagementTextFieldPlaceholder = L10n.tr("Localizable", "entry_management_text_field_placeholder", fallback: "New entry")
  /// No entries yet tracked.
  internal static let homeEntryListEmptyMessage = L10n.tr("Localizable", "home_entry_list_empty_message", fallback: "No entries yet tracked.")
  /// Logged time: %@
  internal static func homeEntryListItemLoggedTimeFormat(_ p1: Any) -> String {
    return L10n.tr("Localizable", "home_entry_list_item_logged_time_format", String(describing: p1), fallback: "Logged time: %@")
  }
  /// Home
  internal static let homeTitle = L10n.tr("Localizable", "home_title", fallback: "Home")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
