//: Playground - noun: a place where people can play

import UIKit

extension String {
    var getStringLength: Int {
        return self.characters.count
    }
}

extension Double {
    var doubleToString: String {
        return String(format:"%.1f", self)
    }

    func doubleToStringWithDigit(count: Int) -> String {
       return String(format:"%.\(count)f", self)
    }
}

let str = "Test String"

str.getStringLength

let d = 3.14

d.doubleToString

d.doubleToStringWithDigit(10)
