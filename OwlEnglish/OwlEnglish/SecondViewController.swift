//
//  SecondViewController.swift
//  OwlEnglish
//
//  Created by 1 on 11/08/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import Foundation
import UIKit
import SQLite3
class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //변수들
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var resultEnglishText: UITextView!
    var db: OpaquePointer?
    
    
    
    //IBAction
    @IBAction func searchButton(_ sender: Any) {
        callURL()
    }
    @IBAction func saveTextButton(_ sender: Any) {
        //데이터 베이스 생성
        opendb()
        insertdb()
        
        
    }
    
    //Custom method
    
    func saveAlert(){
        let alert = UIAlertController(title: "성공", message: "나의 단어장으로 저장 완료!", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    func insertAlert(){
        let alert = UIAlertController(title: "실패", message: "단어를 입력해주세요!", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "확인", style: .destructive) { (action) in
            
        }
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    //API 불러오기
    func callURL(){
        
        let text = searchText.text!
        let param = "source=ko&target=en&text=\(text)"
        let paramData = param.data(using: .utf8)
        let Naver_URL = URL(string: "https://openapi.naver.com/v1/language/translate")
        //💥💥💥💥본인의 Naver 애플리케이션 정보를 작성!!!💥💥💥💥
        let ClientID = "D2VwCGcCJLXOXYb8dDFB"
        let ClientSecret = "g6aFZkv08R"
        
        
        //Request
        var request = URLRequest(url: Naver_URL!)
        request.httpMethod = "POST"                 //Naver 도서 API는 GET
        request.addValue(ClientID,forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(ClientSecret,forHTTPHeaderField: "X-Naver-Client-Secret")
        request.httpBody = paramData
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        
        
        //Session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        //Task
        let task = session.dataTask(with: request) { (data, response, error) in
            //통신 성공
            if let data = data {
                let str = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? ""
                print(str)
                DispatchQueue.main.async {
                    //self.JSON_Text.text = str JSON 불러오는거
                    ////////////////////////////////////////////////////////////////////////
                    let decoder = JSONDecoder()
                    let data = str.data(using: .utf8)
                    if let data = data, let TransDatas = try? decoder.decode(Welcome.self, from: data) {
                        self.resultEnglishText.text = TransDatas.message.result.translatedText
                    }
                    /////////////////////////////////////////////////////////////////////////////////////
                }
            }
            //////////
            //통신 실패
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    //DB열기
    func opendb(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("MyEnglishDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("DB 열기 실패222")
        }
        print(fileURL)
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS MyEnglish (id INTEGER PRIMARY KEY AUTOINCREMENT, DB_English TEXT, DB_Korean TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    func insertdb(){
        let DB_English = resultEnglishText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let DB_Korean = searchText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        //텍스트 필드의 값이 빈 경우의 처리
        if(DB_English?.isEmpty)!{
            insertAlert()
            return
        }
        if(DB_Korean?.isEmpty)!{
            insertAlert()
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

