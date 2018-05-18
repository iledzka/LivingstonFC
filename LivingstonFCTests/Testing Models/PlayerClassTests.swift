//
//  PlayerClassTests.swift
//  LivingstonFCTests
//
//  Created by Iza Ledzka on 10/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import XCTest
@testable import LivingstonFC

class PlayerClassTests: XCTestCase {
    
    var sut: Player?
    
    override func setUp() {
        super.setUp()
        let dictionary: [String:Any] =
            [ "id": "1",
              "squadNo": "2",
              "team": "Livingston FC",
              "firstName": "Aleks",
              "lastName": "Orlov",
              "position": "Striker",
              "dateOfBirth": "1997-01-01",
              "height": "182cm",
              "nationality": "Scottish",
              "imageIcon": "assets/link/to/img",
              "backgroundImg": "assets/link/to/backgroundImg",
              "signed": "2016-01-02",
              "matches": "46",
              "goals": "67",
              "assists": "87",
              "redCards": "55",
              "yellowCards": "12"
        ]
        sut = Player(data: dictionary as NSDictionary)
    }
    
    func testInit_PlayerDoesntEqualNil() {
        XCTAssertNotNil(sut)
    }
    
    func testInit_PlayerId_IsValidString(){
        XCTAssertEqual(sut?.id, "1")
    }
    
    func testInit_PlayerSquadNo_IsValidString(){
        XCTAssertEqual(sut?.squadNo, "2")
    }
    
    func testInit_PlayerFirstName_IsValidString(){
        XCTAssertEqual(sut?.firstName, "Aleks")
    }
    
    func testInit_PlayerLastName_IsValidString(){
        XCTAssertEqual(sut?.lastName, "Orlov")
    }
    
    func testInit_PlayerPosition_IsValidString(){
        XCTAssertEqual(sut?.position, "Striker")
    }
    
    func testInit_PlayerDateOfBirth_IsValidString(){
        XCTAssertEqual(sut?.dateOfBirth, "1997-01-01")
    }
    
    func testInit_PlayerHeight_IsValidString(){
        XCTAssertEqual(sut?.height, "182cm")
    }
    
    func testInit_PlayerNationality_IsValidString(){
        XCTAssertEqual(sut?.nationality, "Scottish")
    }
    func testInit_PlayerImageIcon_IsValidString(){
        XCTAssertEqual(sut?.imageIcon, "assets/link/to/img")
    }
    func testInit_PlayerBackgroundImg_IsValidString(){
        XCTAssertEqual(sut?.backgroundImg, "assets/link/to/backgroundImg")
    }
    func testInit_PlayerImageSigned_IsValidString(){
        XCTAssertEqual(sut?.signed, "2016-01-02")
    }
    func testInit_PlayerImageMatches_IsValidString(){
        XCTAssertEqual(sut?.matches, "46")
    }
    func testInit_PlayerGoals_IsValidString(){
        XCTAssertEqual(sut?.goals, "67")
    }
    func testInit_PlayerAssists_IsValidString(){
        XCTAssertEqual(sut?.assists, "87")
    }
    func testInit_PlayerRedCards_IsValidString(){
        XCTAssertEqual(sut?.redCards, "55")
    }
    func testInit_PlayerYellowCards_IsValidString(){
        XCTAssertEqual(sut?.yellowCards, "12")
    }
}
