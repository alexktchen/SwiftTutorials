//: Playground - noun: a place where people can play

import UIKit

@objc protocol UserBase {
    func getName() -> String
}

class Engineer: UserBase {
    @objc func getName() -> String {
        return "Alex"
    }
}

class Finance: UserBase {
    @objc func getName() -> String {
        return "Daisy"
    }
}

class UserFactory<T> {

    static func name () -> String {
        return "\(T.self)".componentsSeparatedByString(".").last!
    }

    static func getUserTitleAndName() -> String {
        let className = "\(T.self)".componentsSeparatedByString(".").last!
        switch className {
        case "Engineer":
            return  Engineer().getName() + " Engineer"
        case "Finance":
            return Finance().getName() + " Finance"
        default:
            return "No user searched"
        }
    }
}

let className = UserFactory<Engineer>.name()

var userTitle = UserFactory<Engineer>.getUserTitleAndName()

userTitle = UserFactory<Finance>.getUserTitleAndName()

userTitle = UserFactory<Int>.getUserTitleAndName()
