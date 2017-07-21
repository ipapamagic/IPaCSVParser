//
//  IPaCSVParser.swift
//  Pods
//
//  Created by IPa Chen on 2017/6/22.
//
//

import UIKit

open class IPaCSVParser: NSObject {
    enum IPaCSVParserState {
        case normal
        case lookingForQM
        case lookingForComma
    }
    var csvString:String = ""
    
    public init(csvString:String) {
        super.init()
        self.csvString = csvString
    }
    
    open func parse(_ progress:((Float)->())?) -> [[String]] {
        var result = [[String]]()
        var currentRow = [String]()
        var valueString = ""
        var status = IPaCSVParserState.normal
        
        for index in 0 ..< csvString.characters.count {
            let startIndex = csvString.index(csvString.startIndex, offsetBy: index)
            let endIndex = csvString.index(startIndex, offsetBy: 1)
            let character = self.csvString[startIndex ..< endIndex]
            switch status {
            case .lookingForQM:
                if character == "\"" {
                    currentRow.append(valueString)
                    valueString = ""
                    status = .lookingForComma
                }
                else {
                    valueString += character
                }
            case .lookingForComma:
                if character == "," {
                    status = .normal
                }
            case .normal:
                switch character {
                case ",":
                    currentRow.append(valueString)
                    valueString = ""
                case "\"":
                    status = .lookingForQM
                case "\n","\r\n":
                    currentRow.append(valueString)
                    result.append(currentRow)
                    currentRow = [String]()
                    valueString = ""
                default:
                    valueString += character
                    break
                }
            }
            if let progress = progress {
                progress(Float(index) / Float(csvString.characters.count))
            }
        }
        currentRow.append(valueString)
        result.append(currentRow)
        return result
    }
}
