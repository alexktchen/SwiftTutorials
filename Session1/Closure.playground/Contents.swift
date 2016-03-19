//: Playground - noun: a place where people can play

import UIKit
import XCPlayground


// Trailing Closures

// one paramter
func getUserCount(userCount: Int -> ()) {
    userCount(20)
}
//execute
getUserCount { (userCount) -> () in
    let c = userCount
}

// multiple paramter
func getUserInfo(user: (userName: String, userId: Int) -> ()) {

    user(userName: "Alex", userId: 11211)
}
//execute
getUserInfo { (userName, userId) -> () in
    let u = userName
    let d = userId
}

// Closures Return Values
func functionToRunAClosure(someClosure: String -> ()) -> String {
    someClosure("return in closure")
    return "return by func"
}

let f = functionToRunAClosure { (name) -> () in
    let n = name
}


// sort sample
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

func backwards(s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversed = names.sort(backwards)

reversed = names.sort({ (s1: String, s2: String) -> Bool in
    return s1 > s2
})




