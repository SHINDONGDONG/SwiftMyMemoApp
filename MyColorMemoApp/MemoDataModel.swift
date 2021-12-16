//
//  MemoDataModel.swift
//  MyColorMemoApp
//
//  Created by 申民鐡 on 2021/12/14.
//

import Foundation
import RealmSwift //RealmSwift의 라이브러리를 import한다.


class MemoDataModel: Object {
    @objc dynamic var id: String = UUID().uuidString //데이터를 식별하기위한 랜덤값부여
    @objc dynamic var text: String = ""
    @objc dynamic var recordDate: Date = Date()

}
