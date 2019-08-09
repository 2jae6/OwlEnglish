//
//  EnglishExam.swift
//  OwlEnglish
//
//  Created by 1 on 09/08/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import Foundation
import UIKit
import SQLite3
class EnglishExam: UIViewController{
    
    //IBOUTLET
    @IBOutlet weak var presentExamText: UILabel!
    var db: OpaquePointer?
    var dataList = [Data]()
    var rowsu: Int?
    var randomsu: Int?
    var naonsu: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        opendb()
        readValues()
        rowsu = dataList.count
        randomsu = Int(arc4random_uniform(UInt32(rowsu!)))
        
        naonsu = randomsu!
        let Data: Data
        Data = dataList[randomsu!]
        presentExamText.text = Data.DB_English
    }
    

    
//IBAction
    @IBAction func knowButton(_ sender: Any) {
        dataList.remove(at: naonsu!)
        rowsu = dataList.count
        
        //////////0일경우
        if rowsu == 0{
            presentExamText.text = "전부 외우셨습니다. 꼭 다시 복습하세요!!!"
        }else{
        ///////////////////// 0이 아닐경우
        randomFunction()
        naonsu = randomsu!
        let Data: Data
        Data = dataList[randomsu!]
        presentExamText.text = Data.DB_English
        }
    }
    @IBAction func dontKnowButton(_ sender: Any) {
        randomFunction()
        naonsu = randomsu!
        let Data: Data
        Data = dataList[randomsu!]
        presentExamText.text = Data.DB_English
    }
    
    @IBAction func tapAction(_ sender: Any) {
        let Data: Data
        Data = dataList[randomsu!]
        presentExamText?.text = ("\(Data.DB_English!)  \(Data.DB_Korean!)")
    }
    
    
    //Custom Method
    func randomFunction(){

        if rowsu! == 2{
            if naonsu == 1{
                randomsu = 0
            }else {
                randomsu = 1
            }
        }else if rowsu! == 1{
            randomsu = 0
        }else if rowsu! == 0{
            print("다 외웠습니다.")
            
        }else{
            while randomsu! == naonsu!{
                randomsu = Int(arc4random_uniform(UInt32(rowsu!)))
            }
        }
        
    }
    //DB열기
    func opendb(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("MyEnglishDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("DB 열기 실패222")
        }
        print(fileURL)
        
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
    }
}
