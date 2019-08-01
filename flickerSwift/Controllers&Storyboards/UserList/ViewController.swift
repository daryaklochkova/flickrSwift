//
//  ViewController.swift
//  flickerSwift
//
//  Created by Darya Klochkova on 15/07/2019.
//  Copyright © 2019 Darya Klochkova. All rights reserved.
//

import UIKit
import Network


class ViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var usersTableView: UITableView!
    
    //MARK: Users property
    private let usersAccessQueue = DispatchQueue(label: "FlickrSwift.UsersQueue", qos: .background, attributes: .concurrent)
    private var _users = [User]()
    var users: [User] {
        get {
            var usersCopy: [User]!
            usersAccessQueue.sync {
                [weak self] in
                guard let self = self else {
                    return
                }
                usersCopy = self._users
            }
            
            return usersCopy
        }
        
        set {
            usersAccessQueue.async(flags: .barrier) {
                [weak self] in
                guard let self = self else {
                    return
                }
                
                self._users = newValue
            }
        }
    }
    
    func addUser(_ user: User) {
        usersAccessQueue.async(flags: .barrier) {
            [weak self] in
            guard let self = self else {
                return
            }
            
            self._users.append(user)
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToNotifications()
        configureteSearchController()
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Notifications handlers
    fileprivate func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(userUpdated(notification:)), name: .userUpdated, object: nil)
    }

    @objc func userUpdated(notification: Notification) {
        guard let object = notification.object as? User else {
            return
        }
        
        for user in users {
            if user === object {
                reloadUsersTableView()
            }
        }
    }
    
    //MARK: UISearchResultsUpdating implementation
    func updateSearchResults(for searchController: UISearchController) {
        guard let username = searchController.searchBar.text, !username.isEmpty else {
            users = [User]()
            usersTableView.reloadData()
            return
        }
        
        guard !usersListContain(username: username) else {
            return
        }
        
        DataProvider.instance.getUserBy(name: username, completionHandler:
            { [weak self] (user) in
            self?.addUser(user)
            self?.reloadUsersTableView()
        })
    }
    
    //MARK: UITableViewDelegate implementation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCellView
        
        let user = getUserAtIndexPath(indexPath: indexPath)
        if let username = user.username {
            cell.userName = username
        }
        
        if let realName = user.realName {
            cell.photosCount.text = realName
        }
        
        if let iconLocalUrl = user.icon?.localURL {
            do {
                let imageData = try Data(contentsOf: iconLocalUrl)
                cell.photoView?.image = UIImage(data: imageData)
            } catch {
                print("Error loading image : \(error)")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        if let viewController = viewController as? ProfileViewController {
            viewController.user = getUserAtIndexPath(indexPath: indexPath)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    //MARK: private functions
    fileprivate func getUserAtIndexPath(indexPath: IndexPath) -> User {
        return users[users.count - indexPath[1] - 1]
    }
  
    fileprivate func configureteSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search people"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    fileprivate func reloadUsersTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.usersTableView.reloadData()
        }
    }
    
    fileprivate func usersListContain(username: String) -> Bool {
        for user in users {
            if let tmpUsername = user.username,
                tmpUsername.lowercased() == username.lowercased() {
                return true
            }
        }
        
        return false
    }
}

