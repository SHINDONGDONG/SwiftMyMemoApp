//
//  HomeViewController.swift
//  MyColorMemoApp
//
//  Created by 申民鐡 on 2021/12/12.
//

import Foundation
import UIKit //UI에 관한 클래스가 격납되어있는 모듈
import RealmSwift

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
       
        setNavigationBarButton()
   
    }

    //화면을 표시하기 직전 해당메소드를 실행하는 라이프사이클
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMemoData()
        //tableview를 리로드시켜야야한다.
        tableView.reloadData()
    }
    
    //realm의 메모데이터를 화면에 표시해주는 메소드를 만든다.
    func setMemoData(){
        //realm을 정의하ㅣ고.
        let realm = try! Realm()
        //realm의 object(memomodel을 가지고와 result에 담아준다,)
        let result = realm.objects(MemoDataModel.self)
        //memoModel의 리스트를 array로 memodatalist에 담아주어 리스트로 만든다
        memoDataList = Array(result)
    }
    
    
    //메모를 셋업해주는 메소드.
//    func setMemoData(){
//        for i in 1...5 {
//            //MemoDataModel의 형태로 memodatamodel에 저장하여 memoDataList에 append해준다.
//            let memoDataModel = MemoDataModel()
//            //memo date의 data를 struct에서 class로 변경해주었기 때문에 아래와 같이 변경하면된다.
//            memoDataModel.text = "このメモは\(i)番目のメモです"
//            memoDataModel.recordDate = Date()
//            memoDataList.append(memoDataModel)
//        }
//    }
//
    //objc로 탭을 누르면 화면이동할곳으로 지정해준다.
    @objc func tapAddButton(){
        //Main 스토리보드를 담아주고
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //storyboard의 controller 의identifier가 memodetailviewcontrooler인 곳으로 이동한다.
        let memoDetailViewController = storyboard.instantiateViewController(withIdentifier: "MemoDetailViewController") as! MemoDetailViewController
        //화면을 push해준다.
        navigationController?.pushViewController(memoDetailViewController, animated: true)
    }
    
    func setNavigationBarButton(){
        //헤더의 버튼을 클릭하면 실행하는 지정하는 클래스 셀렉터는 #뒤에selector 실행대상 이다
        let buttonActionSelector : Selector = #selector(tapAddButton)
        //uibarbuttonitem 은 uinavigation에 배치하는 아이템  systemitem은 아이콘 action은 방금정의한 buttonactionselecotr
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: buttonActionSelector)
        //navigationitem의 바버튼 아이템 종류를 지정한다.s
        navigationItem.rightBarButtonItem = rightBarButton
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
    
    //tableview에 먼저 적용되어있는 메소드를 불러서 삭제할 수 있게만든다
    //이것은 옆으로 슬라이드를하면 삭제가능하게 하는기능이다
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //memodatalist에 있는 indexpath.row를 담아준다(삭제할 메모를)
        let targetMemo = memoDataList[indexPath.row]
        //realm의 데이터 삭제를위하여 try! realm.write 의 realm.delete(targetMemo)로 delete를 해준다.
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(targetMemo)
                }
        //memodataList의 리스트삭제도해주어 리스트에서 빼내준다.
                memoDataList.remove(at: indexPath.row)
        //tableview에서 row를(cell)도 화면에서 삭제해주어야한다.
                tableView.deleteRows(at:[indexPath], with: .automatic)
    }
        
}
