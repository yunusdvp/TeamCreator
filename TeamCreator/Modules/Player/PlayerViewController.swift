//
//  PlayerViewController.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 31.07.2024.
//

import UIKit

class PlayerListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func registerCell(){
        tableView.register(UINib(nibName: "DenemeTableViewCell", bundle: nil), forCellReuseIdentifier: "DenemeTableViewCell")
    }
    

}
extension PlayerListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DenemeTableViewCell", for: indexPath) as! DenemeTableViewCell
        return cell
    }
    
}
