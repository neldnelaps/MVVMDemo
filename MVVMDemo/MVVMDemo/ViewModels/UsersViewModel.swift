//
//  UserViewModel.swift
//  MVVMDemo
//
//  Created by Natalia Pashkova on 17.03.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class UsersViewModel {
    
    var users = BehaviorSubject(value: [SectionModel(model: "", items: [User]())])
    
    private var apiUser: UserApiProtocol = UserApi()
    
    func fetchUsers() async {
        let users = (try? await apiUser.getUsers()) ?? []
        let sectionUser = SectionModel(model: "First", items: [User(userID: 3, id: 32, title: "First item", body: "body" )])
        let secondSection = SectionModel(model: "Second", items: users)
        self.users.on(.next([sectionUser, secondSection]))
    }
    
    func addUser(user: User){
        guard var sections = try? users.value() else {return}
        var currentSection = sections[0]
        currentSection.items.insert(user, at: 0)
        sections[0] = currentSection
        self.users.onNext(sections)
    }
    
    func deleteUser(indexPath: IndexPath) {
        guard var sections = try? users.value() else {return}
        var currentSection = sections[indexPath.section]
        currentSection.items.remove(at: indexPath.row)
        sections[indexPath.section] = currentSection
        self.users.onNext(sections)
    }
    func editUser(title: String, indexPath: IndexPath) {
        guard var sections = try? users.value() else {return}
        var currentSection = sections[indexPath.section]
        currentSection.items[indexPath.row].title = title
        sections[indexPath.section] = currentSection
        self.users.onNext(sections)
    }
    
}
