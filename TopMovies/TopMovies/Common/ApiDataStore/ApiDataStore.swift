//
//  ApiDataStore.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit
import SwiftHTTP
import Log

class ApiDataStore: NSObject
{
    //MARK: Singleton
    static let sharedInstance = ApiDataStore()
    private override init() {}
    
    let Log = Logger()
    
    //MARK: - Handlers
    typealias CompletionHandler = (ApiResponse) -> Void
}
