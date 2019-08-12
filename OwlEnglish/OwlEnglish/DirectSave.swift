//
//  DirectSave.swift
//  OwlEnglish
//
//  Created by 1 on 12/08/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import Foundation
import UIKit
import SQLite3

class DirectSave:UIViewController{
    
    
    @IBOutlet weak var englishTF: UITextField!
    @IBOutlet weak var koreanTF: UITextField!


    var db: OpaquePointer?
    var dataList = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        opendb()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        insertdb()
    }
    
    
    //Custom Method
    //DB열기
    func saveAlert(){
        let alert = UIAlertController(title: "성공", message: "나의 단어장으로 저장 완료!", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    
    func opendb(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("MyEnglishDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("DB 열기 실패222")
        }
    }
    
    func insertdb(){
        let DB_English = englishTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let DB_Korean = koreanTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        //텍스트 필드의 값이 빈 경우의 처리
        if(DB_English?.isEmpty)!{
            return
        }
        if(DB_Korean?.isEmpty)!{
            return
        }
        
        // 명령 객체 만들기
        var stmt: OpaquePointer?
        
        // 쿼리 집어넣기
        let queryString = "INSERT INTO MyEnglish (DB_English, DB_Korean) Values (?,?)"
        
        // 쿼리 준비
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // 파라미터 바인딩
        //   let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        if sqlite3_bind_text(stmt, 1, DB_English, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 2, DB_Korean, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        //삽입 값 쿼리 실행
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("삽입하는데 실패했다: \(errmsg)")
            return
        }
        
        //displaying a success message
        print("Test saved successfully")
        saveAlert()
    }
}
