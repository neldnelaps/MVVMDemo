//
//  ViewController.swift
//  MVVMDemo
//
//  Created by Natalia Pashkova on 15.03.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {

    private var viewModel = ViewModel()
    private var bag = DisposeBag()
    lazy var tableView : UITableView = {
        let tv = UITableView(frame: self.view.frame, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.title = "Users"
        let add = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(onTapAdd))
        self.navigationItem.rightBarButtonItem = add
        viewModel.fetchUsers()
        bindTableView()
    }
    @objc func onTapAdd(){
        let user = User(userID: 1213, id: 214, title: "CodeTest", body: "Rx Swift Mvvm")
        self.viewModel.addUser(user: user)
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, User>>{ _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "\(item.id)"
            return cell
        } titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
        self.viewModel.users.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteUser(indexPath: indexPath)
            
        })
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let alert = UIAlertController(title: "Note", message: "Edit Note", preferredStyle: .alert)
            alert.addTextField { textField in
                
            }
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                let textField = alert.textFields![0] as UITextField
                self.viewModel.editUser(title: textField.text ?? "", indexPath: indexPath)
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: bag)
    }
}

extension ViewController : UITableViewDelegate {
    
}

class ViewModel {
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

struct User: Codable {
    let userID, id: Int
    var title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
