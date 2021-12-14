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
    
    //date형식의 데이터들을 내 입맛에 맞게 포맷해주는 메소드.
    var dateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
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
        cell.detailTextLabel?.text = dateFormat.string(from: memoDataModel.recordDate)
        return cell
    }
}

//user가 uitableview를 조작할때 거동하는 메소드임
extension HomeViewController: UITableViewDelegate {
    //uit   able이 탭 되었을 때 탭되어진 셀에 인덱스 번호가 부여되는 메소드이다.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //UIStoryboard를 지정한다 Main*
        let storyboad = UIStoryboard(name: "Main", bundle: nil)
        //memodetailviewcontroller를 컨트롤할 상수에 mainstoryboard의 identity가 MemoDetailViewController인걸 컨트롤한다고 알려준다.
        let memoDetailViewController = storyboad.instantiateViewController(withIdentifier: "MemoDetailViewController")
        as! MemoDetailViewController
        
        //메모 데이터 리스트의 인덱스번호를 차례대로 넣어준다.
        let memoData = memoDataList[indexPath.row]
        //메모 데이터 상세화면에 정의했던 메소드에 memoData를 날려준다.
        memoDetailViewController.config(memo: memoData)
        
        //deselect(탭이 안눌려져있는 상태에서는 선택표시를 하지않는다.)
        tableView.deselectRow(at: indexPath, animated: true)
        
        //cell을 탭하면 navigation으로 이동하게된다
        navigationController?.pushViewController(memoDetailViewController, animated: true)
        
        
        
    }
}
