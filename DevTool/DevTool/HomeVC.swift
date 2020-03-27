//
//  HomeVC.swift
//  DevTool
//
//  Created by lx on 2019/12/25.
//  Copyright © 2019 lx. All rights reserved.
//

import UIKit
import Toast_Swift

class HomeVC: UIViewController {

    @IBOutlet weak var touchLabel: XTouchLabel!
    @IBOutlet weak var intervalTF: XIntervalTFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Touch Label
        let font = UIFont(name: "PingFangSC-Regular", size: 14)!
        let str1 = "《使用条款》"
        let str2 = "《隐私政策》"
        let content = String(format: "点击确定注册即表示同意%@和%@。", str1, str2)
        touchLabel.configContent(aText: content, aFont: font, aColor: UIColor.black, clickTexts: [(str1, font, UIColor.blue), (str2, font, UIColor.blue)])
        touchLabel.textClick = { [weak self] (text: String) in
            self?.view.makeToast(text, position: .center)
        }
        
        //Interval TF
        intervalTF.setupView()
        intervalTF.keyboardUp(true)
    }
    
    @IBAction func goVC(_ sender: Any) {
        intervalTF.keyboardUp(false)
        
        let alertVC = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        [("none", AnimateType.none), ("horizontal", AnimateType.horizontal), ("vertical", AnimateType.vertical), ("fade", AnimateType.fade)].forEach({ (elem) in
            alertVC.addAction(UIAlertAction(title: elem.0, style: .default, handler: { (_) in
                self.present(SecVC.loadNibVC(type: elem.1), animated: true, completion: nil)
            }))
        })
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func alertSheetAction(_ sender: Any) {
        let alert = UIAlertController(title: "Information", message: "sub title", preferredStyle: .actionSheet)
        let type1 = UIAlertAction(title: "type 1", style: .default) { (UIAlertAction) in
            XAlertView.show(title: "type 1", message: nil, cancelButtonTitle: nil, otherButtonTitle: "确定") { (view: XAlertView, index: Int) in
                 print("点击下标是:\(index)")
            }
        }
        let type2 = UIAlertAction(title: "type 2", style: .default) { (UIAlertAction) in
            XAlertView.show(title: "type 2", message: "mssage", cancelButtonTitle: "取消", otherButtonTitles: "1", "2", "3", "4", "5", "6") { (view: XAlertView, index: Int) in
                 print("点击下标是:\(index)")
            }
        }
        let type3 = UIAlertAction(title: "type 3", style: .default) { (UIAlertAction) in
            XAlertView.show(title: "type 3", message: "夜，结束了一天的喧嚣后安静下来，伴随着远处路灯那微弱的光。风，毫无预兆地席卷整片旷野，撩动人的思绪万千。星，遥遥地挂在天空之中，闪烁着它那微微星光，不如阳光般灿烂却如花儿般如痴如醉。夜，结束了一天的喧嚣后安静下来，伴随着远处路灯那微弱的光。风，毫无预兆地席卷整片旷野，撩动人的思绪万千。星，遥遥地挂在天空之中，闪烁着它那微微星光，不如阳光般灿烂却如花儿般如痴如醉。", cancelButtonTitle: "取消", otherButtonTitle: "确定") { (alertV: XAlertView, index: Int) in
                print("点击下标是:\(index)")
            }
        }
        let type4 = UIAlertAction(title: "type 4", style: .default) { (UIAlertAction) in
            let alertV = XAlertView(title: "type 4", message: "取消弹出动画,改变背景颜色", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: ["确定"])
            alertV.visual = false
            alertV.animationOption = .none
            alertV.visualBGColor = UIColor.red
            alertV.show()
        }
        let type5 = UIAlertAction(title: "type 5", style: .default) { (UIAlertAction) in
            //取消模糊背景
            let alertV = XAlertView(title: "type 5", message: "取消模糊背景", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: ["确定"])
            alertV.visual = false
            alertV.show()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            print("you selected cancel")
        }
        alert.addAction(type1)
        alert.addAction(type2)
        alert.addAction(type3)
        alert.addAction(type4)
        alert.addAction(type5)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

// Mark: XAlertViewDelegate
extension HomeVC: XAlertViewDelegate {
    func alertView(alertView: XAlertView, clickedButtonAtIndex: Int) {
        print("点击下标是:\(clickedButtonAtIndex)")
    }
}

