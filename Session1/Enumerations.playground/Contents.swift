//: Playground - noun: a place where people can play

import UIKit

// Enumeration Syntax


enum UserType {
    case student
    case engineer
    case accounting
    case administration
}


let user1 = UserType.administration
let user2: UserType = .engineer


// with values
enum UserTypeWhitValue {
    case administration(String, String)
}

let user3 = UserTypeWhitValue.administration("123", "456")

switch user3 {
case .administration("111","222") :
    print("incorrect")
case .administration("123","456"):
    print("correct")
default:
    print("default")
}


// Raw Values
enum UserTypeWithRawValues: String {
    case student = "Eric"
    case engineer = "Alex"
    case accounting = "Vicky"
    case administration = "Daisy"
}

let user4 = UserTypeWithRawValues.administration.rawValue
let user5 = UserTypeWithRawValues.engineer.rawValue

let user6 = UserTypeWithRawValues(rawValue: "Alex")
let user7 = UserTypeWithRawValues(rawValue: "Tracy")







