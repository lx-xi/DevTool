//
//  XTouchLabel.swift
//  Growdex
//
//  Created by lx on 2019/10/31.
//  Copyright © 2019 lx. All rights reserved.
//

import UIKit

class XTouchLabel: UIView {

    public var textClick: ((_ text: String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = UIColor.clear
        self.addSubview(textView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.frame = self.bounds
    }
    
    public func configContent(aText: String,
                              aFont: UIFont = UIFont(name: "PingFangSC-Regular", size: 12)!,
                              aColor: UIColor = UIColor.lightGray,
                              clickText: String,
                              clickFont: UIFont = UIFont(name: "PingFangSC-Regular", size: 12)!,
                              clickColor: UIColor = UIColor.red) {
        let range: Range = aText.range(of: clickText)!
        let nsRange = NSRange(range, in: aText)
        let attributedStr: NSMutableAttributedString = NSMutableAttributedString(string: aText)
        attributedStr.addAttributes([NSAttributedString.Key.foregroundColor: aColor, NSAttributedString.Key.font: aFont], range: NSRange(location: 0, length: aText.count))
        attributedStr.addAttribute(NSAttributedString.Key.link, value: "click://", range: nsRange)
        attributedStr.addAttributes([NSAttributedString.Key.foregroundColor: clickColor, NSAttributedString.Key.font: clickFont], range: nsRange)
        textView.attributedText = attributedStr
    }
    
    public func configContent(aText: String,
                              aFont: UIFont = UIFont(name: "PingFangSC-Regular", size: 12)!,
                              aColor: UIColor = UIColor.lightGray,
                              clickTexts: [(text: String,
                              font: UIFont,
                              color: UIColor)]) {
        //nomal text
        let attributedStr: NSMutableAttributedString = NSMutableAttributedString(string: aText)
        attributedStr.addAttributes([NSAttributedString.Key.foregroundColor: aColor, NSAttributedString.Key.font: aFont], range: NSRange(location: 0, length: aText.count))
        //click text
        clickTexts.forEach { (arg0) in
            let (text, font, color) = arg0
            let range: Range = aText.range(of: text)!
            let nsRange = NSRange(range, in: aText)
            attributedStr.addAttribute(NSAttributedString.Key.link, value: "click://", range: nsRange)
            attributedStr.addAttributes([NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font], range: nsRange)
        }
        
        textView.attributedText = attributedStr
    }

    // MARK: - Setter / Getter
    private lazy var textView: UITextView = {
        let tView = UITextView.init(frame: CGRect.zero)
        tView.delegate = self
        tView.isEditable = false
        tView.isScrollEnabled = false
        tView.backgroundColor = UIColor.clear
        return tView
    }()

}

extension XTouchLabel: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "click" {
            let abString = textView.attributedText.attributedSubstring(from: characterRange)
            textClick?(abString.string)
            return false
        }
        return true
    }
}
