//
//  IPaCSVParser.swift
//  Pods
//
//  Created by IPa Chen on 2017/6/22.
//
//



open class IPaCSVParser: NSObject {
    public static func read(url:URL ,progress:((Float)->())? = nil) -> [[String]] {
        do {
            let csvString = try String(contentsOf: url)
            return IPaCSVParser.read(csvString: csvString,progress:progress)
        }
        catch let error {
            print(error)
        }
        return [[String]]()
    }
    public static func read(csvString:String ,progress:((Float)->())? = nil) -> [[String]] {
        var result = [[String]]()
        var currentRow = [String]()
        var valueString = ""
        
        let scanner = Scanner(string:csvString)
        scanner.charactersToBeSkipped = CharacterSet.whitespaces
        
        while !scanner.isAtEnd {
            
            var value:NSString?
            //            let firstCharacter = (scanner.string as NSString).substring(with: NSRange(location: scanner.scanLocation, length: 1))
            if scanner.scanString("\"", into: &value) {
                
                while true {
                    scanner.scanUpTo("\"", into: &value)
                    if let value = value {
                        valueString += value.substring(to: value.length - 1) as String
                        
                    }
                    if scanner.scanString("\"", into: &value) {
                        if scanner.scanString(",", into: &value) {
                            currentRow.append(valueString)
                            valueString = ""
                            break
                        }
                        else if scanner.scanString("\r\n", into: &value) {
                            currentRow.append(valueString)
                            valueString = ""
                            
                            result.append(currentRow)
                            currentRow = [String]()
                            break
                        }
                        else {
                            valueString += "\""
                        }
                    }
                    else if scanner.isAtEnd {
                        
                        break
                    }
                    
                }
                
            }
                //            else if firstCharacter == "\n" || firstCharacter == "\r\n" {
            else if scanner.scanString("\r\n", into: &value) {
                currentRow.append(valueString)
                valueString = ""
                result.append(currentRow)
                currentRow = [String]()
            }
            else {
                let endSet = CharacterSet.newlines.union(CharacterSet(charactersIn: ","))
                if scanner.scanUpToCharacters(from: endSet, into: &value) {
                    if let endValue = value {
                        valueString += endValue as String
                        if valueString == "NSD03" {
                            print("ss")
                        }
                        
                        if scanner.scanString(",", into: &value) {
                            currentRow.append(valueString)
                            valueString = ""
                        }
                        else if scanner.scanString("\r\n", into: &value) {
                            currentRow.append(valueString)
                            valueString = ""
                            
                            result.append(currentRow)
                            currentRow = [String]()
                            
                        }
                    }
                }
            }
            
            if let progress = progress {
                progress(Float(csvString.count - scanner.string.count) / Float(csvString.count))
            }
            
        }
        currentRow.append(valueString)
        valueString = ""
        
        result.append(currentRow)
        currentRow = [String]()
        return result
    }
    
}
