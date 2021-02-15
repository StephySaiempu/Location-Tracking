//
//  Contract.swift
//  Telyport_Assignment
//
//  Created by Girira Stephy on 14/02/21.
//

import Foundation



protocol UpdateLocationProtocol: AnyObject {
    
    func updateTime(_ timeValue: String)
    func updateLocationCount(_ value: String)
    func presentError(_ title: String,subHeading: String)
}
