//
//  OWE_FrontendTests.swift
//  OWE FrontendTests
//
//  Created by Juliann Fields on 10/29/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import XCTest
import Foundation
@testable import OWE_Frontend

class OWE_FrontendTests: XCTestCase {

  func testUser() {
    let user4 = User.getUser(4)
    XCTAssertEqual(user4?.id, 4)
    XCTAssertEqual(user4?.name, "Hannah Jenkins")
    XCTAssertEqual(user4?.email, "hjenkins@gmail.com")
    XCTAssertEqual(user4?.phone, "1029384756")

    let user7 = User.getUser(7)
    XCTAssertEqual(user7?.id, 7)
    XCTAssertEqual(user7?.name, "Amanda Stiegal")
    XCTAssertEqual(user7?.email, "astiegal@gmail.com")
    XCTAssertEqual(user7?.phone, "0123456789")
  }
  
  func testGroupTripViewModel() {
    let viewModel = GroupTripViewModel()
    let group = DispatchGroup()
    group.enter()
    viewModel.refresh ({ [unowned self] in
      DispatchQueue.main.async {
        group.leave()
      }
      }, url: "https://oneworldexchange.herokuapp.com/travel_groups")

    group.notify(queue: .main) {
      XCTAssertEqual(viewModel.groups.count, 3)
      XCTAssertEqual(viewModel.numberOfRows(), 3)
      XCTAssertEqual(viewModel.groups[0].tripName, "European Backpacking")
      XCTAssertEqual(viewModel.groups[2].tripName, "Hawaii Trip")
    }
  }

  func testGroupUsersViewModelUsers() {
    let viewModelUser = GroupUsersViewModel()
    let group = DispatchGroup()
    group.enter()
    viewModelUser.refresh ({ [unowned self] in
      DispatchQueue.main.async {
        group.leave()
      }
      }, url: "https://oneworldexchange.herokuapp.com/users")
    
    group.notify(queue: .main) {
      XCTAssertEqual(viewModelUser.users.count, 8)
      XCTAssertEqual(viewModelUser.numberOfRows(), 8)
      XCTAssertEqual(viewModelUser.users[6].name, "Roy Miao")
      XCTAssertEqual(viewModelUser.users[8].email, "ewalstad@andrew.cmu.edu")
    }
  }
  
  func testGroupUsersViewModelMembers() {
    let viewModelMember = GroupUsersViewModel()
    let group = DispatchGroup()
    group.enter()
    viewModelMember.refresh ({ [unowned self] in
      DispatchQueue.main.async {
        group.leave()
      }
      }, url: "https://oneworldexchange.herokuapp.com/travel_group/1/members")
    
    group.notify(queue: .main) {
      XCTAssertEqual(viewModelMember.users.count, 4)
      XCTAssertEqual(viewModelMember.numberOfRows(), 4)
      XCTAssertEqual(viewModelMember.users[1].name, "Katie Armstrong")
      XCTAssertEqual(viewModelMember.users[0].email, "heram@andrew.cmu.edu")
    }
  }

  func testTransaction() {
    let transactionVM = TransactionViewModel()
    XCTAssertEqual(transactionVM.currToSymbol(currType: "AUD"), "$")
    XCTAssertEqual(transactionVM.currToSymbol(currType: "JPY"), "¥")
    XCTAssertEqual(transactionVM.currToSymbol(currType: "GBP"), "£")

    XCTAssertEqual(transactionVM.convert(currAbrev: "EUR", amount: 25.00), 28.40)
    XCTAssertEqual(transactionVM.convert(currAbrev: "USD", amount: 11.00), 11.00)
    XCTAssertEqual(transactionVM.convert(currAbrev: "MXN", amount: 193.42), 9.51)
}

}
