//
//  HomeViewController.swift
//  MyColorMemoApp
//
//  Created by 申民鐡 on 2021/12/12.
//

import Foundation
import UIKit //UI에 관한 클래스가 격납되어있는 모듈

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var memoDataList: [MemoDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        //밑에서 setup해준 setMemoData를 실행.
        setMemoData()
    }
    
    //메모를 셋업해주는 메소드.
    func setMemoData(){
        for i in 1...5 {
            //MemoDataModel의 형태로 memodatamodel에 저장하여 memoDataList에 append해준다.
            let memoDataModel = MemoDataModel(text: "このメモは\(i)番目のメモです。", recordDate: Date())
            memoDataList.append(memoDataModel)
        }
    }
    
    
}



extension HomeViewController: UITableViewDataSource{
    //UItable 의 테이블 개수를 리턴
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoDataList.count
    }
    
    //UI talbe의 실제 Cell별로의 데이터를 리턴
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell을 tableviewcell로 정의
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell") //subtitle을 지정하고 reuseID를 임의로지정
        //memodateModel 형태로 memodatalist를 받아준다. [ indexpath.row ] 의 순서로 (array)
        let memoDataModel: MemoDataModel = memoDataList[indexPath.row]
        //cell textlabel에 저장될 text 는 위에서 memoDataModel의 text를 받아 저장한다.
        cell.textLabel?.text = memoDataModel.text
        //cell의 서브타이틀을 표시하기위해 detailTextlabel.text로 recordDate를 받아온다.
        cell.detailTextLabel?.text = "\(memoDataModel.recordDate)"
        return cell
    }
}
