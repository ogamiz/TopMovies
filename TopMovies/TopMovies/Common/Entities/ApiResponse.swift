//
//  ApiResponse.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit

public enum OperationType
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
    public var iOperationType:OperationType?
    public var iResponseType:ResponseType?
    public var iStatusCode:Int?
    public var iError:Error?
    public var iJsonResults:[[String : Any]]?
    
    required public init(operationType aOperationType:OperationType)
    {
        super.init()
        self.iOperationType = aOperationType
    }
}
