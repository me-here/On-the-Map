//
//  Constants.swift
//  maps
//
//  Created by Mihir Thanekar on 7/9/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import Foundation

struct Constants {
    struct Parse {
        struct parameters {
            static let AppID = "X-Parse-Application-Id"
            static let APIKey = "X-Parse-REST-API-Key"
            static let contentType = "Content-Type"
        }
        struct values {
            static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
            static let appID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
            static let contentType = "application/json"
        }
    }
    
    struct Udacity {
        static let sessionURL = "https://www.udacity.com/api/session"
        static let usersURL = "https://www.udacity.com/api/users/"
        static let studentLocationsURL = "https://parse.udacity.com/parse/classes/StudentLocation"
        struct sessionCookie {
            static let headerName = "X-XSRF-TOKEN"
            static let cookieName = "XSRF-TOKEN"
        }
        static let udacitySignUpURLString = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
    }
    
    enum requestType: String {
        case PUT = "PUT"
        case POST = "POST"
        case GET = "GET"
        case DELETE = "DELETE"
    }
    
}
