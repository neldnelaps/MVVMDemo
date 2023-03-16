//
//  ViewController.swift
//  MVVMDemo
//
//  Created by Natalia Pashkova on 15.03.2023.
//

import UIKit
import RxSwift
import RxCocoa

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
        viewModel.users.bind(to: tableView.rx.items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) {
            (row, item, cell) in
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "\(item.id)"
            
        }.disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let alert = UIAlertController(title: "Note", message: "Edit Note", preferredStyle: .alert)
            alert.addTextField { textField in
                
            }
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                let textField = alert.textFields![0] as UITextField
                self.viewModel.editUser(title: textField.text ?? "", index: indexPath.row)
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteUser(index: indexPath.row)
            
        })
    }
}

extension ViewController : UITableViewDelegate {
    
}

class ViewModel {
    var users = BehaviorSubject(value: [User]())
    
    func fetchUsers () {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard  let data = data else {
                return
            }
            do {
                let responseData = try JSONDecoder().decode([User].self, from: data)
                self.users.on(.next(responseData))
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func addUser(user: User){
        guard var users = try? users.value() else {return}
        users.insert(user, at: 0)
        self.users.on(.next(users))
    }
    
    func deleteUser(index: Int) {
        guard var users = try? users.value() else {return}
        users.remove(at: index)
        self.users.on(.next(users))
    }
    func editUser(title: String, index: Int) {
        guard var users = try? users.value() else {return}
        users[index].title = title
        self.users.on(.next(users))
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
