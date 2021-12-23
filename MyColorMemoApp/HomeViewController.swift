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
    let themeColorTypeKey = "themeColorTypeKey"
    
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
        //userdefault로부터 int형을 취득할때 standard 프로퍼티에 포함되는 integer메소드를 사용한다. forkey는 방금전 사용한 key문자열을 사용함
        let themeColorTypeInt = UserDefaults.standard.integer(forKey: themeColorTypeKey)
        //취득한 int형의 데이터를 MycolorType에 초기화 되어있는 rawvalue인수에 대입해주어 저장한다 int를 안건내주면 default로 사용
        let themeColorType = MyColorType(rawValue: themeColorTypeInt) ?? .default
        setThemeColor(type: themeColorType)
   
    }

    //화면을 표시하기 직전 해당메소드를 실행하는 라이프사이클
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMemoData()
        //tableview를 리로드시켜야야한다.
        tableView.reloadData()
        setLeftNavigationBarButton()
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
    
    //왼쪽바에 버튼을만듬
    func setLeftNavigationBarButton(){
        //버튼을 눌렀을 때 셀렉터가 실행된다.
        let buttonActionSelector: Selector = #selector(didTapColorSettingButton)
        //colorSettingIcon을 uiimage에 담아준다.
        let leftButtonImage = UIImage(named: "colorSettingicon")
        //leftbutton은 uibarbuttonitem이고 image는 leftbuttonimge를 지정, .plain과 타겟은 셀프 액션은 buttonactionselector로 지정해놓는다.
        let leftButton = UIBarButtonItem(image: leftButtonImage, style: .plain, target: self, action: buttonActionSelector)
        //누르면은 navigationitem.leftbarbuttonitem이 실행되고 leftbutton이 실제로 담겨있다.
        navigationItem.leftBarButtonItem = leftButton
    }
    //selector이고 누르면 실제 기능이 실행되는 메소드읻.
    @objc func didTapColorSettingButton(){
        
        //UIAlertAction에 .default의 스타일로 handler는 void 아무것도 반환하지않음.
        let defaultAction = UIAlertAction(title: "デフォルト", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .default)
        })
        let orangeAction = UIAlertAction(title: "ORANGE", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .orange)
        })
        let redAction = UIAlertAction(title: "RED", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .red)
        })
        let blueAction = UIAlertAction(title: "BLUE", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .blue)
        })
        let greenAction = UIAlertAction(title: "GREEN", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .green)
        })
        let pinkAction = UIAlertAction(title: "PINK", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .pink)
        })
        let purpleAction = UIAlertAction(title: "PURPLE", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .purple)
        })
        // UIAlertAction의 .cancel로 핸들러는 아무것도 반환하지않아 캔슬됨.
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        //위에서 정의한 alert들을 담아주는 UIAlertContrller에 타이틀, 메세지를 적을 수 있으며,스타일은 액션시트입니다.
        let alert = UIAlertController(title: "chose color", message: "", preferredStyle: .actionSheet)
        //위에서 정의한 alert에 default,orange,red,cancel을 담아주고
        alert.addAction(defaultAction)
        alert.addAction(orangeAction)
        alert.addAction(redAction)
        alert.addAction(blueAction)
        alert.addAction(greenAction)
        alert.addAction(pinkAction)
        alert.addAction(purpleAction)
        alert.addAction(cancelAction)
        //부모가되는건 alert이며 애니메이터는 true
        present(alert, animated: true)
    }
    
    func setThemeColor(type: MyColorType){
        //theme컬러에 따라서 헤더부분이 잘 안보일 수 있다. 이것을 개선하자.
        //isDefault에 타입이 default라는것을 증명하는 상수
        let isDefault = type == .default
        //tintcolor에 uicolor로 isdefault상수가 default가 맞다면 black을 아니면 white를 넣는다.
        let tintColor: UIColor = isDefault ? .black : .white
        //navigation바,tintcolor에 대입한다.
        navigationController?.navigationBar.tintColor = tintColor
        //type. 으로 enum을 사용할 수 잇다.
        navigationController?.navigationBar.barTintColor = type.color
        //detail화면의 header title의 색상도 바꾸어주려면 아래와같이 설정해야한다
        //Dictionary형태의 [key : value] 값으로 nsattributedString.key.foregroundColor에 tintcolor를 넣는다는 의미이다.
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:tintColor]
        saveThemeColor(type: type)
    }
    //themecolor를 저장하는 메소드
    func saveThemeColor(type: MyColorType) {
        //userdefaults 데이터에 standard .setvalue로 저장시켜주는것이다
        //여기서 첫번째는 보존할 값을, 두번재는 데이터의 악세스할수잇는 키 를 넘겨준다.
        UserDefaults.standard.setValue(type.rawValue, forKey: themeColorTypeKey)
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
