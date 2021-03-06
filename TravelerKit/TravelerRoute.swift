//
//  Route.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-09-05.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import Foundation

enum PassengerRoute {
    case unauthenticated(UnauthPath)
    case authenticated(AuthPath, apiKey: String, token: Token)  //  TODO: Once there is a JWT validator on the gateway we wont need apiKey passed here
    
}

extension PassengerRoute: Route {
    var baseURL: URL {
        return URL(string: "https://guest-traveler-api-develop.guestlogix.io")!
    }

    var urlRequest: URLRequest {
        var urlRequest: URLRequest

        switch self {
        case .unauthenticated(let path):
            urlRequest = path.urlRequest(baseURL: baseURL)
        case .authenticated(let path, let apiKey, let token):
            urlRequest = path.urlRequest(baseURL: baseURL)
            urlRequest.addValue(apiKey, forHTTPHeaderField: "x-api-key")
            urlRequest.addValue("Bearer \(token.value)", forHTTPHeaderField: "Authorization")
        }

        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        urlRequest.addValue(Traveler.shared?.device.identifier ?? "[NO_DEVICE]", forHTTPHeaderField: "x-device-id")
        urlRequest.addValue(Traveler.shared?.device.osVersion ?? "[NO_OS_VERSION]", forHTTPHeaderField: "x-os-version")
        urlRequest.addValue(Locale.current.languageCode ?? "en", forHTTPHeaderField: "x-language")
        urlRequest.addValue(Locale.current.regionCode ?? "US", forHTTPHeaderField: "x-region")
        urlRequest.addValue(Locale.current.identifier, forHTTPHeaderField: "x-locale")
        urlRequest.addValue(Bundle.main.bundleIdentifier ?? "[NO_BUNDLE_IDENTIFIER]", forHTTPHeaderField: "x-application-id")
        urlRequest.addValue(TimeZone.current.identifier, forHTTPHeaderField: "x-timezone")

        return urlRequest
    }

    func error(from error: Error) -> Error {
        return error
    }
}
