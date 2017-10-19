//
//  ExtDomainTest.swift
//  SimpleDomainModelTests
//
//  Created by Naruth Kongurai on 10/18/17.
//  Copyright © 2017 Ted Neward. All rights reserved.
//

import XCTest

class ExtDomainTest: XCTestCase {

    // Money Objects
    let tenUSD = Money(amount: 10, currency: "USD")
    let fiveGBP = Money(amount: 5, currency: "GBP")
    let fifteenEUR = Money(amount: 15, currency: "EUR")
    let fifteenCAN = Money(amount: 15, currency: "CAN")
    
    // Job Objects
    let lecturer = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
    let janitor = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
    
    // Person Objects
    let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
    let sam = Person(firstName: "Sam", lastName: "Olson", age: 21)
    let rick = Person(firstName: "Rick", lastName: "Smith", age: 19)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMoneyOutputString() {
        let printMsg1 = tenUSD.description
        XCTAssert(printMsg1 == "USD10.0")
        let printMsg2 = fiveGBP.description
        XCTAssert(printMsg2 == "GBP5.0")
        let printMsg3 = fifteenEUR.description
        XCTAssert(printMsg3 == "EUR15.0")
        let printMsg4 = fifteenCAN.description
        XCTAssert(printMsg4 == "CAN15.0")
    }
    
    func testJobOutputString() {
        let printMsg1 = lecturer.description
        let printMsg2 = janitor.description
        XCTAssert(printMsg1 == "The job title is Guest Lecturer, earning 1000 per year")
        XCTAssert(printMsg2 == "The job title is Janitor, earning 15.0 an hour")
    }
    
    func testPersonOutputString() {
        let printMsg1 = ted.description
        XCTAssert(printMsg1 == "[Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]")
    }
    
    func testFamilyOutputString() {
        let membersInFamily = Family.init(spouse1: sam, spouse2: rick)
        let printMsg = membersInFamily.description
        XCTAssert(printMsg == "Family: [Person: firstName:Sam lastName:Olson age:21 job:nil spouse:Rick] [Person: firstName:Rick lastName:Smith age:19 job:nil spouse:Sam]")
    }
    
    func testMoneyAddition() {
        let total = tenUSD.add(fiveGBP)
        XCTAssert(total.amount == 10)
        XCTAssert(total.currency == "GBP")
    }
    
    func testMoneySubtraction() {
        let total = tenUSD.subtract(fiveGBP)
        XCTAssert(total.amount == 0)
        XCTAssert(total.currency == "USD")
    }
    
    func testExtensionDouble() {
        let fifty : Double = 50.0
        let fiftyUSDTest = fifty.USD
        let printMsg1 = fiftyUSDTest.description
        
        let fiftyUSDActual = Money(amount: 50, currency: "USD")
        let printMsg2 = fiftyUSDActual.description
        XCTAssert(printMsg1 == printMsg2)
    }
    
    

}
