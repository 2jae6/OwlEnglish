//
//  EnglishNoteViewController.swift
//  OwlEnglish
//
//  Created by 1 on 06/08/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import Foundation
import UIKit
import SQLite3

class EnglishNoteViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{
    var db: OpaquePointer?
    var dataList = [Data]()
    var deleteNum: Int?
    @IBOutlet weak var myEnglishTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        opendb()
        readValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        opendb()
        readValues()
    }
    
    
    @IBAction func addVocaButton(_ sender: Any) {
        // 화면을 전환할 뷰 컨트롤러 객체를 스토리보드에서 Storyboard ID 정보를 이용하여 읽어온다
        if let uvc = self.storyboard?.instantiateViewController(withIdentifier: "addVC") {
            // 화면을 전환할 때 애니메이션 정의
            uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            // 인자값으로 받은 뷰 컨트롤러로 화면 이동
            self.present(uvc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        let Data: Data
        Data = dataList[indexPath.row]
        cell.textLabel?.text = Data.DB_English
        cell.detailTextLabel?.text = Data.DB_Korean
        cell.detailTextLabel?.isHidden = true
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.detailTextLabel?.isHidden = false
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let Data: Data
        Data = dataList[indexPath.row]
        deleteNum = Data.id
        
        if editingStyle == UITableViewCell.EditingStyle.delete{
            dataList.remove(at: indexPath.row)
            myEnglishTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            deleteData()
        }
        
    }
    //Custom Method
    //DB열기
    func opendb(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("MyEnglishDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("DB 열기 실패222")
        }
    }
    func deleteData(){
        //first empty the list of Test
        dataList.removeAll()
        //this is our select query
        let queryString = "DELETE FROM MyEnglish WHERE id == \(deleteNum!)"
        //statement pointer
        var stmt:OpaquePointer?
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert:v2 \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let DB_English = String(cString: sqlite3_column_text(stmt, 1))
            let DB_Korean = String(cString: sqlite3_column_text(stmt, 2))
            //adding values to list
            dataList.append(Data(id: Int(id), DB_English: String(describing: DB_English), DB_Korean: String(describing: DB_Korean)))
        }
        readValues()
        
    }
    func readValues(){
        //first empty the list of Test
        dataList.removeAll()
        //this is our select query
        let queryString = "SELECT * FROM MyEnglish"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert:v1 \(errmsg)")
            return
        }
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let DB_English = String(cString: sqlite3_column_text(stmt, 1))
            let DB_Korean = String(cString: sqlite3_column_text(stmt, 2))
            //adding values to list
            dataList.append(Data(id: Int(id), DB_English: String(describing: DB_English), DB_Korean: String(describing: DB_Korean)))
            
        }
        self.myEnglishTableView.reloadData()
    }
}
