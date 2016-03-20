//: Playground - noun: a place where people can play

import UIKit

protocol UserDelegate {
    func getUserCount(count: Int)
}

class UserService {
    var deleteage: UserDelegate?
    class var sharedInstance: UserService {
        struct Singleton {
            static let instance = UserService()
        }
        return Singleton.instance
    }
    func selectUser() {
        deleteage?.getUserCount(20)
    }
}

class UserClass: UserDelegate {

    init() {
        UserService.sharedInstance.deleteage = self
        UserService.sharedInstance.selectUser()
    }
    func getUserCount(count: Int) {
        _ = count
    }
}

// init UserClass
let user = UserClass()
