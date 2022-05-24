//
//  ApiResponse.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit

public enum ResultType
{
    case succes
    case failure
}
public enum ResponseType
{
    case get
    case post
    case delete
}

public class ApiResponse: NSObject
{
    public var iResultType:ResultType?
    public var iResponseType:ResponseType?
    public var iStatusCode:Int?
    public var iError:Error?
    public var iInternalErrorMessage:String?
    public var iDataResults:Data?
    
    required public init(resultType aResultType:ResultType, responseType aResponseType:ResponseType)
    {
        super.init()
        self.iResultType = aResultType
        self.iResponseType = aResponseType
    }
}
