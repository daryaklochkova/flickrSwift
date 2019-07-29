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
    
    var users = [User]()
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userUpdated(notification:)), name: .userUpdated, object: nil)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search people"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    func usersListContain(username: String) -> Bool {
        for user in users {
            if let tmpUsername = user.username, tmpUsername.lowercased() == username.lowercased() {
                return true
            }
        }
        
        return false
    }
    
    //MARK: Notifications handlers
    @objc func userUpdated(notification: Notification) {
        if let object = notification.object as? User {
            for user in users {
                if user === object {
                    DispatchQueue.main.async { [weak self] in
                        self?.usersTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let username = searchController.searchBar.text, !username.isEmpty else {
            users = [User]()
            usersTableView.reloadData()
            return
        }
        
        guard !usersListContain(username: username) else {
            return
        }
        
        DataProvider.instance.getUserBy(name: username, completionHandler: { [weak self] (user) in
            self?.users.append(user)
            
            DispatchQueue.main.async {
                self?.usersTableView.reloadData()
            }
        })
    }
    
    //MARK: UITableViewDelegate implementation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCellView
        
        let user = users[users.count - indexPath[1] - 1]
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
        if let viewController = storyboard.instantiateInitialViewController() as? ProfileViewController {
            viewController.user = users[users.count - indexPath[1] - 1]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

