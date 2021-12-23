//
//  MyColorType.swift
//  MyColorMemoApp
//
//  Created by 申民鐡 on 2021/12/23.
//

import Foundation
import UIKit

enum MyColorType: Int { //Int형으로 enum문을 만들어주어 위에부터 0,1,2,3,....
    //default는 swift에서 먼저 사용하고있는 예약어라 싱글코테이션으로 감싸줘야한다.
    case `default` //#ffffff
    case orange //#8fc165
    case red //#d24141
    case blue //#4187ffa
    case pink //#f064b9
    case green //#50aa41
    case purple //#965ad2
    
    //static 을 사용하고있어서 인스턴스화 시키지않았다.
    var color: UIColor{
        switch self {
        case .default: return .white
        case .orange: return UIColor.rgba(red: 248, green: 193, blue: 101, alpha: 1) //alpha 1 의 의미는 완전불투명
        case .red: return UIColor.rgba(red: 210, green: 65, blue: 65, alpha: 1)           //0의 의미는 완전투명
        case .blue: return UIColor.rgba(red: 65, green: 135, blue: 250, alpha: 1)
        case .pink: return UIColor.rgba(red: 240, green: 100, blue: 185, alpha: 1)
        case .green: return UIColor.rgba(red: 80, green: 170, blue: 65, alpha: 1)
        case .purple: return UIColor.rgba(red: 150, green: 90, blue: 210, alpha: 1)
        }
    }
    
}
//rgba 컬러코드를 변환하는 메소드를 작성. rgba규격을 사용하여 uicolor를 표한한다.
//rgba 는 레드,그린,블루,알파의 각각의 투명도로 색상을 정하는방법이다.
extension UIColor {
    static func rgba(red: Int, green: Int, blue: Int,alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }
}
