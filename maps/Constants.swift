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
        static var shouldReloadData = true
    }
    
    struct Udacity {
        static let sessionURL = "https://www.udacity.com/api/session"
        static let usersURL = "https://www.udacity.com/api/users/"
        static let studentLocationsURL = "https://parse.udacity.com/parse/classes/StudentLocation"
        struct sessionCookie {
            static let headerName = "X-XSRF-TOKEN"
            static let cookieName = "XSRF-TOKEN"
        }
        static var userID = ""
        static let udacitySignUpURLString = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
        static var firstName = ""
        static var lastName = ""
        
    }
    
    enum requestType: String {
        case PUT = "PUT"
        case POST = "POST"
        case GET = "GET"
        case DELETE = "DELETE"
        
        static func isValidRequestType(requestType: String) -> Bool {
            switch requestType {
            case Constants.requestType.GET.rawValue:
                return true
            case Constants.requestType.PUT.rawValue:
                return true
            case Constants.requestType.POST.rawValue:
                return true
            case Constants.requestType.DELETE.rawValue:
                return true
            default:
                return false
            }
        }

    }
    
}
