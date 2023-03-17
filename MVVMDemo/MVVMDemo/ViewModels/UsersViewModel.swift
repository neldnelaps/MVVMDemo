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
    
    func fetchUsers () {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard  let data = data else {
                return
            }
            do {
                let responseData = try JSONDecoder().decode([User].self, from: data)
                let sectionUser = SectionModel(model: "First", items: [User(userID: 3, id: 32, title: "First item", body: "body" )])
                let secondSection = SectionModel(model: "Second", items: responseData)
                self.users.on(.next([sectionUser, secondSection]))
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
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
