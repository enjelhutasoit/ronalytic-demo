//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation

/// An https URL, or nil for empty or invalid text.
func parseEndpoint(_ text: String) -> URL? {
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty,
          let url = URL(string: trimmed),
          url.scheme == "https",
          url.host != nil else { return nil }

    return url
}

enum EndpointSettings {
    private static let key = "demo.endpoint"

    static var text: String {
        get { UserDefaults.standard.string(forKey: key) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }

    static var url: URL? { parseEndpoint(text) }
}
