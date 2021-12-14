//
//  MemoDetailViewController.swift
//  MyColorMemoApp
//
//  Created by 申民鐡 on 2021/12/14.
//

import Foundation
import UIKit


class MemoDetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var text: String = ""
    var recordDate : Date = Date()

    //date형식의 데이터들을 내 입맛에 맞게 포맷해주는 메소드.
    var dateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //displaydata 메소드를 실행시켜 상세화면에 데이터들을 띄운다.
        displayData()
        
    }
    
    func displayData(){
        //IBoutlet 버튼의 textview에 memodataModel에서 가져온 text를 집어넣어주어 표시시켜준다.
        textView.text = text
        //상세화면의 타이틀에 표시해준다.
        navigationItem.title = dateFormat.string(from: recordDate)
    }
    
    func config(memo: MemoDataModel){
        text = memo.text
        recordDate = memo.recordDate
        print("データは\(text)と\(recordDate)です！")
    }

}
