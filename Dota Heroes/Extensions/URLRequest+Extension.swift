//
//  URLRequest+Extension.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
//

import Foundation

extension URLRequest {
    /// Returns a cURL command for a request
    /// - return A String object that contains cURL command or "" if an URL is not properly initalized.
    public var cURL: String {
        guard let url = url,
              let httpMethod = httpMethod,
              !url.absoluteString.utf8.isEmpty else { return "" }

        var curlCommand = "curl --verbose "

        // URL
        curlCommand = curlCommand.appendingFormat(" '%@' ", url.absoluteString.removingPercentEncoding!)

        // Method if different from GET
        if httpMethod != "GET" {
            curlCommand = curlCommand.appendingFormat(" -X %@ ", httpMethod)
        }

        // Headers
        if let allHeadersFields = allHTTPHeaderFields {
            let allHeadersKeys = Array(allHeadersFields.keys)
            let sortedHeadersKeys = allHeadersKeys.sorted(by: <)
            for key in sortedHeadersKeys {
                if let value = self.value(forHTTPHeaderField: key) {
                    curlCommand = curlCommand.appendingFormat(" -H '%@: %@' ", key, value)
                }
            }
        }

        // HTTP body
        if let httpBody = httpBody, !httpBody.isEmpty {
            let httpBodyString = String(data: httpBody, encoding: String.Encoding.utf8)!
            let escapedHttpBody = URLRequest.escapeAllSingleQuotes(httpBodyString)
            curlCommand = curlCommand.appendingFormat(" --data '%@' ", escapedHttpBody)
        }

        return curlCommand
    }

    /// Escapes all single quotes for shell from a given string.
    static func escapeAllSingleQuotes(_ value: String) -> String {
        return value.replacingOccurrences(of: "'", with: "'\\''")
    }
}
