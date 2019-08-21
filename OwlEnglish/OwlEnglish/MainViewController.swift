//
//  MainViewController.swift
//  OwlEnglish
//
//  Created by 1 on 15/08/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import Foundation
import UIKit



class MainViewController:UIViewController{
    
    @IBOutlet weak var examButtonOutlet: UIButton!
    
    @IBAction func myEnglishButton(_ sender: Any) {
        // 화면을 전환할 뷰 컨트롤러 객체를 스토리보드에서 Storyboard ID 정보를 이용하여 읽어온다
        if let uvc = self.storyboard?.instantiateViewController(withIdentifier: "myEnglish") {
            // 화면을 전환할 때 애니메이션 정의
            uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            // 인자값으로 받은 뷰 컨트롤러로 화면 이동
            self.present(uvc, animated: true)
    }
}

    
}
