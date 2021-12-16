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
        setDoneButton()
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

    //selector로 view.endEditing 편집모드를 끝내준다
    @objc func tapDoneButton(){
        view.endEditing(true)
    }
    
    func setDoneButton(){
        //keyboard위에 나오는 미리보기?창에 done을 띄워준다
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        //done버튼을 눌렀을 때의 동작
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        //미리보기에는 여러가지 아이템이 들어올 수 있으니 배열로 넣어준다.
        toolBar.items = [commitButton]
        //textview의 악세서리 뷰에 추가를 시켜주어 toolbar로서 표시가 가능하다.
        textView.inputAccessoryView = toolBar
    }
    
}
