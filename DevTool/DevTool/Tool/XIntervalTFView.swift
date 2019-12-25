//
//  XIntervalTFView.swift
//  Growdex
//
//  Created by lx on 2019/12/2.
//  Copyright © 2019 lx. All rights reserved.
//

import UIKit
import SnapKit

class XIntervalTFView: UIView {
    
    var commitHandle: ((_ code: String) -> Void)?

    private var labs: [UILabel] = []
    private var labInterval: CGFloat = 4
    private var isSecret: Bool = false
    private var labW: CGFloat = 0
    private var labFont: UIFont = UIFont(name: "PingFangSC-Regular", size: 14)!
    private var inputNum: Int = 6
    private lazy var inputTF: UITextField = {
        let tf = UITextField(frame: CGRect.zero)
        tf.textColor = UIColor.clear
        tf.leftViewMode = .always
        tf.leftView = tfIntervalView
        tf.keyboardType = .numberPad
        return tf
    }()
    //tf left view
    private lazy var tfIntervalView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        return v
    }()
    
    //MARK: - life cycle
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initFunc()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initFunc()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labW = (self.frame.size.width - labInterval * CGFloat(labs.count + 1)) / CGFloat(labs.count)
        for (index, value) in labs.enumerated() {
            value.frame = CGRect(x: labInterval * CGFloat(1 + index) + labW * CGFloat(index), y: 0, width: labW, height: self.frame.size.height)
        }
        tfIntervalView.width = labInterval + labW / 2
    }
    
    //MARK: - private func
    private func initFunc() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange(note:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    //MARK: - public func
    public func setupView(num: Int = 6, color: UIColor = UIColor.lightGray, interval: CGFloat = 4, secret: Bool = false, font: UIFont = UIFont(name: "PingFangSC-Regular", size: 14)!) {
        labInterval = interval
        isSecret = secret
        labFont = font
        inputNum = num
        
        for _ in 1...inputNum {
            let lab = UILabel(frame: CGRect.zero)
            lab.textColor = color
            lab.textAlignment = NSTextAlignment.center
            lab.font = labFont
            self.addSubview(lab)
            labs.append(lab)
            
            //添加底部线条
            let line = UIView()
            line.backgroundColor = color
            lab.addSubview(line)
            line.snp.makeConstraints { (make) in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(1)
            }
        }
        
        self.addSubview(inputTF)
        inputTF.font = labFont
        inputTF.snp.makeConstraints { (maker) in
            maker.left.top.right.equalToSuperview()
            maker.bottom.equalTo(1)
        }
    }
    
    /// 弹出键盘
    public func keyboardUp(_ up: Bool = true) {
        up ? inputTF.becomeFirstResponder() : inputTF.resignFirstResponder()
    }

}

extension XIntervalTFView {
    @objc fileprivate func textFieldTextDidChange(note: NSNotification) {
        guard let tf = note.object as? UITextField, tf == self.inputTF else {
            return
        }
        let str = tf.text ?? ""
        var newStr = str
        if str.count > inputNum {
            newStr = String(newStr.prefix(6))
        }
        
        if str != newStr {
            self.inputTF.text = newStr
        }
        
        for (index, value) in labs.enumerated() {
            if index < newStr.count {
                value.text = isSecret ? "*" : newStr.subString(start: index, length: 1)
            } else {
                value.text = ""
            }
        }
        
        if newStr.count < labs.count {
            let textW = getLabWidth(labelStr: newStr, font: labFont, height: 1000)
            tfIntervalView.width = labs[newStr.count].left + labW / 2 - textW
        }
        
        if newStr.count == labs.count {
            if commitHandle != nil {
                commitHandle?(newStr)
            }
        }
    }
}

extension String {
    /// 根据开始位置和长度截取字符串
    public func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
}

/// 获取字符串Label宽度
func getLabWidth(labelStr: String, font: UIFont, height:CGFloat) -> CGFloat {
    let statusLabelText: NSString = labelStr as NSString
    let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: height)
    let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context: nil).size
    return strSize.width
}
/// 获取字符串Label高度
func getLabHeight(labelStr: String, font: UIFont, width:CGFloat) -> CGFloat {
    let statusLabelText: NSString = labelStr as NSString
    let size = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
    let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context: nil).size
    return strSize.height
}
