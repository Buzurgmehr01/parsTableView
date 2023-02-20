//
//  ViewController.swift
//  parsWithAlamofire
//
//  Created by Temp on 19/02/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let url = "https://jsonplaceholder.typicode.com/users"

    @IBOutlet var tableView: UITableView!
    var result: [Result]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        
        parsJson(urlString: url)
    }
    private func setUpTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func parsJson(urlString: String){
        AF.request(urlString).responseDecodable(of: [Result].self) { response in
            switch response.result{
            case .success(let value):
                value.map { (_) in
                    self.result = value
                    self.tableView.reloadData()
                }
            case.failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let resultName = result?[indexPath.row]
        cell.textLabel?.text = resultName?.name
        
        return cell
    }
}


struct Result: Decodable{
    let name: String?
    let email: String
    let username: String
}
