//
//  support.swift
//  OwlEnglish
//
//  Created by 1 on 24/08/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import Foundation
import UIKit
class SupportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    var support: [String] = ["개발자에게 문의하기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return support.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = support[indexPath.row]
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: "https://forms.gle/veP6ANBLcn5qnupM9"),
            UIApplication.shared.canOpenURL(url) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    

}
