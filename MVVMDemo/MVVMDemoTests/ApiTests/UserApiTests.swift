//
//  UserApiTests.swift
//  MVVMDemoTests
//
//  Created by Natalia Pashkova on 04.04.2023.
//

import XCTest
@testable import MVVMDemo

final class UserApiTests: XCTestCase {
    var sut: UserApiProtocol!
    override func setUpWithError() throws {
        sut = UserApi()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testGetUsers() async throws {
        _ = try await sut.getUsers()
    }
}
