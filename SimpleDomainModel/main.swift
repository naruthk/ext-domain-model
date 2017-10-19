//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Protocol
////////////////////////////////////

protocol CustomStringConvertible {
    var description : String {
        get
    }
}

protocol Mathematics {
    func add(_: Money) -> Money
    func subtract(_: Money) -> Money
}


////////////////////////////////////
// Extension
////////////////////////////////////
extension Double {
    var USD: Money {
        return Money(amount: Int(self), currency: "USD")
    }
    var EUR: Money {
        return Money(amount: Int(self), currency: "EUR")
    }
    var GBP: Money {
        return Money(amount: Int(self), currency: "GBP")
    }
    var CAN: Money {
        return Money(amount: Int(self), currency: "CAN")
    }
}

////////////////////////////////////
// Money
////////////////////////////////////
public struct Money : CustomStringConvertible, Mathematics {
    public var amount : Int
    public var currency : String
    private var exchangeRate: [String: [String : Double]];      // "USD": ["GBP": 0.5...]
    
    public var description: String {
        let amt : Double = Double(self.amount)
        return "\(self.currency)\(amt)"
    }
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
        self.exchangeRate = [
            "USD": ["GBP": 0.5, "EUR": 1.5, "CAN": 1.25],
            "EUR": ["GBP": 0.33, "USD": 0.67, "CAN": 0.83],
            "CAN": ["GBP": 0.4, "USD": 0.8, "EUR": 1.2],
            "GBP": ["CAN": 2.5, "USD": 2.0, "EUR": 3.0]
        ]
    }

    // Convert from one currency to another using a fixed exchange rate
    public func convert(_ to: String) -> Money {
        let newAmount = Int(Double(self.amount) * self.exchangeRate[self.currency]![to]!)
        return Money(amount: newAmount, currency: to)
    }
    
    // Add money from two same/different currencies
    public func add(_ to: Money) -> Money {
        // Convert the currency to the desired new currency, then return a new Money object
        if (self.currency != to.currency) {
            let newlyExchangedMoney = self.convert(to.currency)
            let newAmount = newlyExchangedMoney.amount
            return Money(amount: newAmount + to.amount, currency: to.currency)
        }
        // In the case of the same currency, we just do the addition
        return Money(amount: self.amount + to.amount, currency: self.currency)
    }
    
    // Subtract money from two same/different currencies
    public func subtract(_ from: Money) -> Money {
        if (self.currency != from.currency) {
            let newlyExchangedMoney = from.convert(self.currency)
            let newAmount = newlyExchangedMoney.amount
            return Money(amount: newAmount - self.amount, currency: self.currency)
        }
        // In the case of the same currency, we just do the subtraction
        return Money(amount: self.amount - from.amount, currency: from.currency)
    }

}

//////////////////////////////////
// Job
////////////////////////////////////
open class Job : CustomStringConvertible {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public var description : String {
        var jobType : String
        switch (self.type) {
            case .Salary(let salary): jobType = "\(salary) per year"
            case .Hourly(let hourly): jobType = "\(hourly) an hour"
        }
        return "The job title is \(self.title), earning \(jobType)"
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
        
        // This function retrieves the value based on which ever value the user has assigned
        func get() -> Double {
            switch self {
            case .Hourly(let hourlyRate):
                return hourlyRate
            case .Salary(let yearlyRate):
                return Double(yearlyRate)
            }
        }
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    
    // Calculate the income based on the given number of hours.
    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let hourlyRate):
            return Int(hourlyRate * Double(hours))
        case .Salary(let yearlyRate):
            return yearlyRate
        }
    }
    
    // Raises the total hourly wage by the inserted amount
    open func raise(_ amt : Double) {
        switch self.type {
        case .Hourly(let hourlyRate):
            self.type = JobType.Hourly(hourlyRate + amt)
        case .Salary(let yearlyRate):
            self.type = JobType.Salary(yearlyRate + Int(amt))
        }
    }
}

////////////////////////////////////
// Person
////////////////////////////////////
open class Person : CustomStringConvertible {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0

    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {
            return _job
        }
        set(value) {
            if (self.age >= 16) {
                _job = value
            } else {
                _job = nil
            }
        }
    }

    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            return _spouse
        }
        set(value) {
            if (self.age >= 18) {
                _spouse = value
            } else {
                _spouse = nil
            }
        }
    }

    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    public var description: String {
        return toString();
    }
    
    open func toString() -> String {
        var strJob : String
        if (self.job != nil) {
            strJob = (self.job?.title)!
        } else {
            strJob = "nil"
        }
        var strSpouse : String
        if (self.spouse != nil) {
            strSpouse = (self.spouse?.firstName)!
        } else {
            strSpouse = "nil"
        }
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(strJob) spouse:\(strSpouse)]"
    }
}

////////////////////////////////////
// Family
////////////////////////////////////
open class Family : CustomStringConvertible {
    fileprivate var members : [Person] = []

    public init(spouse1: Person, spouse2: Person) {
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            self.members.append(spouse1)
            self.members.append(spouse2)
        }
    }

    open func haveChild(_ child: Person) -> Bool {
        for member in self.members {
            if (member.age >= 21) {
                self.members.append(child)
                return true
            }
        }
        return false
    }

    open func householdIncome() -> Int {
        var totalIncome:Int = 0
        for member in self.members {
            if (member.job != nil) {
                totalIncome = totalIncome + (member.job?.calculateIncome(2000))!
            }
        }
        return totalIncome
    }
    
    public var description: String {
        var tempStr : String = ""
        for member in self.members {
            tempStr = tempStr + " " + member.description
        }
        return "Family:" + tempStr
    }
}

