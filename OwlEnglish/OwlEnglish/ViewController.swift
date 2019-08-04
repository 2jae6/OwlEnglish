//
//  ViewController.swift
//  OwlEnglish
//
//  Created by 1 on 03/08/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var imsi: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var JSON_Text: UITextView!
    @IBOutlet weak var searchText: UITextField!
    @IBAction func searchButton(_ sender: Any) {
        callURL()
    }
    

//Custom method
    func callURL(){
        
        let text = searchText.text!
        let param = "source=ko&target=en&text=\(text)"
        let paramData = param.data(using: .utf8)
        let Naver_URL = URL(string: "https://openapi.naver.com/v1/language/translate")
        //💥💥💥💥본인의 Naver 애플리케이션 정보를 작성!!!💥💥💥💥
        let ClientID = "D2VwCGcCJLXOXYb8dDFB"
        let ClientSecret = "g6aFZkv08R"

        
        
        
       /*
        let addQuery = url1 + "source=ko&target=en&text=" + search
        let encoded = addQuery.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)        //한글 검색어도 사용할 수 있도록 함
 */
        
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
                    self.JSON_Text.text = str
                    ////////////////////////////////////////////////////////////////////////
                    let decoder = JSONDecoder()
                    let data = str.data(using: .utf8)
                    if let data = data, let TransDatas = try? decoder.decode(Welcome.self, from: data) {
                        
                        print("\(TransDatas.message.result.translatedText)")//Zed
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
    
    func decodeMethod(){
       
        
    }
 
}

