//
//  Data.swift
//  OwlEnglish
//
//  Created by 1 on 06/08/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import Foundation

class Data{
    var id: Int
    var DB_English: String?
    var DB_Korean: String?
    
    init(id: Int, DB_English: String?, DB_Korean: String?){
        self.id = id
        self.DB_English = DB_English
        self.DB_Korean = DB_Korean
    }
}
