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
    
}
