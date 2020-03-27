//
//  XAlertView.swift
//  DevTool
//
//  Created by TEZWEZ on 2020/3/27.
//  Copyright © 2020 xun. All rights reserved.
//

import UIKit

typealias XAlertViewClickButtonBlock = ((_ alertView: XAlertView, _ buttonIndex: Int) -> Void)?

enum XAlertAnimationOptions {
    case none
    case zoom        // 先放大，再缩小，在还原
    case topToCenter // 从上到中间
}


protocol XAlertViewDelegate {
    // Called when a button is clicked. The view will be automatically dismissed after this call returns
    func alertView(alertView: XAlertView, clickedButtonAtIndex: Int)
}

class XAlertView : UIView{
    
    // MARK: - Public Property
    public var delegate: XAlertViewDelegate?//weak
    public var animationOption: XAlertAnimationOptions = .none
    // background visual
    public var visual = false {
        willSet(newValue){
            if newValue == true {
                effectView.backgroundColor = UIColor.clear
            } else {
                effectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 102.0/255)
            }
        }
        
    }
    // backgroudColor visual
    public var visualBGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 102.0/255) {
        willSet(newValue){
             effectView.backgroundColor = newValue
        }
    }
    
    // MARK: - Private Property
    /** 1.视图的宽高 */
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    private let contentWidth: CGFloat  = 270.0
    private let contentHeight: CGFloat = 88.0
    
    /** 2.视图容器 */
    private var contentView: UIView!
    /** 3.标题视图 */
    private var labelTitle: UILabel!
    /** 4.内容视图 */
    private var labelMessage: UILabel!
    /** 5.处理delegate传值 */
    private var arrayButton: [UIButton] = []
    /** 6.虚化视图 */
    private var effectView: UIVisualEffectView!
    
    /** 7.显示的数据 */
    private var titleString: String!
    private var message: String?
    
    private var cancelButtonTitle: String?
    private var otherButtonTitles: [String] = []
    private var clickButtonBlock: XAlertViewClickButtonBlock?
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = UIView()
        contentView.frame = CGRect(x: 0.0, y: 0.0, width: contentWidth, height: contentHeight)
        contentView.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius  = 10
        contentView.layer.masksToBounds = true
        contentView.autoresizingMask = [.flexibleTopMargin,.flexibleBottomMargin,.flexibleLeftMargin,.flexibleRightMargin]
        
        
        labelTitle = UILabel()
        labelTitle.frame = CGRect(x: 16, y: 22, width: contentWidth-32, height: 0)
        labelTitle.textColor = UIColor.black
        labelTitle.textAlignment = .center
        labelTitle.numberOfLines = 0
        labelTitle.font = UIFont.systemFont(ofSize: 17)
        
        
        labelMessage = UILabel()
        labelMessage.frame = CGRect(x: 16, y: 22, width: contentWidth-32, height: 0)
        labelMessage.textColor = UIColor.black
        labelMessage.textAlignment = .center
        labelMessage.numberOfLines = 0
        labelMessage.font = UIFont.systemFont(ofSize: 13)
        
        effectView = UIVisualEffectView()
        effectView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        effectView.effect = nil
        effectView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    public convenience init(title: String, message: String?, delegate: XAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles:[String]) {
        
        self.init()
        
        arrayButton = [UIButton]()
        
        //标题
        titleString = title
        labelTitle.text = titleString
        
        let labelX:CGFloat = 16
        let labelY:CGFloat = 20
        let labelW:CGFloat = contentWidth - 2*labelX
        labelTitle.sizeToFit()
        
        let size = labelTitle.frame.size
        labelTitle.frame = CGRect(x: labelX, y: labelY, width: labelW, height: size.height)
        
        
        //消息
        self.message = message

        labelMessage.text = message
        labelMessage.sizeToFit()
        let sizeMessage = labelMessage.frame.size
        labelMessage.frame = CGRect(x: labelX, y: labelTitle.frame.maxY+5, width: labelW, height: sizeMessage.height)
        
        
        self.delegate = delegate
        animationOption = .none
        self.cancelButtonTitle = cancelButtonTitle
       
        
        for eachObject in otherButtonTitles{
            self.otherButtonTitles.append(eachObject)
        }
        
        setupDefault()
        setupButton()
        
    }
    
    open class func show(title: String, message: String?, cancelButtonTitle: String?, otherButtonTitles:String ... , clickButtonBlock: XAlertViewClickButtonBlock) {
        let alertView = XAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
        alertView.clickButtonBlock = clickButtonBlock
        alertView.show()
    }
    
    open class func show(title: String,
                         message: String?,
                         cancelButtonTitle: String?,
                         otherButtonTitle: String,
                         clickButtonBlock: XAlertViewClickButtonBlock) {
        let alertView = XAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: [otherButtonTitle])
        alertView.clickButtonBlock = clickButtonBlock
        alertView.show()
    }
    
    // shows popup alert animated.
    open func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        
        switch animationOption {
        case .none:
            contentView.alpha = 0.0
            UIView.animate(withDuration: 0.34, animations: { [unowned self] in
                if self.visual == true {
                    self.effectView.effect = UIBlurEffect(style: .dark)
                }
                self.contentView.alpha = 1.0
            })
        case .zoom:
            self.contentView.layer.setValue(0, forKeyPath: "transform.scale")
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                [unowned self] in
                if self.visual == true {
                    self.effectView.effect = UIBlurEffect(style: .dark)
                }
                self.contentView.layer.setValue(1.0, forKeyPath: "transform.scale")
            }, completion: { _ in
                
            })
        case .topToCenter:
            let startPoint = CGPoint(x: center.x, y: contentView.frame.height)
            contentView.layer.position = startPoint
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: { [unowned self] in
                if self.visual == true {
                    self.effectView.effect = UIBlurEffect(style: .dark)
                }
                self.contentView.layer.position = self.center
            }, completion: { _ in
                
            })
        }
    }
    
    // MARK: - Private Method
    fileprivate func setupDefault() {
        frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        backgroundColor = UIColor.clear
        visual = true
        animationOption = .zoom
        addSubview(effectView)
        addSubview(contentView)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(labelTitle)
        contentView.addSubview(labelMessage)
    }
    
    private func setupButton() {
        let buttonY  = labelMessage.frame.maxY + 20
        var countRow = 0
        
        if cancelButtonTitle?.isEmpty == false {
            countRow = 1;
        }
        countRow += otherButtonTitles.count
        
        switch countRow {
            case 0:
                contentView.addSubview(_button(frame: CGRect(x: 0, y: buttonY, width: contentWidth, height:contentHeight/2), title: "", target: self, action: #selector(_clickCancel(sender:))))
                let height = contentHeight/2 + buttonY
                contentView.frame = CGRect(x: 0, y: 0, width:contentWidth, height: height)
                contentView.center = self.center
            case 2:
                var titleCancel:String
                var titleOther:String
                if cancelButtonTitle?.isEmpty == false {
                    titleCancel = cancelButtonTitle ?? ""
                    titleOther  = otherButtonTitles[0]
                } else {
                    titleCancel = otherButtonTitles[0]
                    titleOther  = otherButtonTitles.last!
                }
               
                let buttonCancel = _button(frame:  CGRect(x: 0, y: buttonY, width: contentWidth/2, height: contentHeight/2), title: titleCancel, target: target, action: #selector(_clickCancel(sender:)))
                let buttonOther = _button(frame: CGRect(x: contentWidth/2, y: buttonY, width: contentWidth/2, height: contentHeight/2), title: titleOther, target: self, action: #selector(_clickOther(sender:)))
                contentView.addSubview(buttonOther)
                contentView.addSubview(buttonCancel)
            
                let height = contentHeight/2 + buttonY
                contentView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: height)
                contentView.center = self.center
        default:
            for number in 0..<countRow {
                var title = ""
                var selector:Selector
                if otherButtonTitles.count > number {
                    title = otherButtonTitles[number]
                    selector = #selector(_clickOther(sender:))
                } else {
                    title = cancelButtonTitle ?? ""
                    selector = #selector(_clickCancel(sender:))
                }
                let button = _button(frame: CGRect(x: 0, y: (CGFloat(number)*contentHeight/2 + buttonY), width: contentWidth, height: contentHeight/2), title: title, target: self, action: selector)
                arrayButton.append(button)
                contentView.addSubview(button)
            }
            
            var height = contentHeight/2 + buttonY
            if countRow > 2 {
                height = CGFloat(countRow) * (contentHeight/2) + buttonY
            }
            contentView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: height)
            contentView.center = self.center
       
            break
        }
    }
    
    private func image(color:UIColor) -> UIImage?{
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func _button(frame:CGRect,title:String,target:Any,action:Selector) -> UIButton{
        let button = UIButton(type: .custom)
        button.frame = frame
        button.setTitleColor(UIColor.init(red: 70.0/255, green: 130.0/255, blue: 233.0/255, alpha: 1.0), for: .normal)
        button.setTitle(title, for: .normal)
        button.setBackgroundImage(image(color: UIColor.init(red: 235.0/255, green: 235.0/255, blue: 235.0/255, alpha: 1.0)), for: .highlighted)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(target, action: action, for: .touchUpInside)
        let lineUp = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 0.5))
        lineUp.backgroundColor = UIColor.init(red: 219.0/255, green: 219.0/255, blue: 219.0/255, alpha: 1.0)
        let lineRight = UIView(frame: CGRect(x: frame.size.width, y:  0, width: 0.5, height: frame.size.height))
        lineRight.backgroundColor = UIColor.init(red: 219.0/255, green: 219.0/255, blue: 219.0/255, alpha: 1.0)
        button.addSubview(lineUp)
        button.addSubview(lineRight)
        return button
    }
    
    private func _remove(){
        switch animationOption {
        case .none:
            UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                if self.visual == true {
                    self.effectView.effect = nil
                }
                self.contentView.alpha = 0.0
            }, completion: { [unowned self] (finished:Bool) in
                self.removeFromSuperview()
            })
        case .zoom:
            UIView.animate(withDuration: 0.3, animations: {
                self.contentView.alpha = 0.0
                if self.visual == true {
                    self.effectView.effect = nil
                }
            }, completion: { [unowned self] (finished:Bool) in
                self.removeFromSuperview()
            })
        case .topToCenter:
            let endPoint = CGPoint(x: center.x, y: frame.height+contentView.frame.height)
            UIView.animate(withDuration: 0.3, animations: {
                if self.visual == true {
                    self.effectView.effect = nil
                }
                self.contentView.layer.position = endPoint
            }, completion: {[unowned self] (finished:Bool)in
                self.removeFromSuperview()
            })
        }
    }
    
    // MARK: - Action
    @objc func _clickOther(sender:UIButton){
        var buttonIndex:Int = 0
        if cancelButtonTitle?.isEmpty == false {
            buttonIndex = 1
        }
        if arrayButton.count > 0 {
            buttonIndex += arrayButton.firstIndex(of: sender) ?? 0
        }
     
        delegate?.alertView(alertView: self, clickedButtonAtIndex: buttonIndex)
        if let aBlock = clickButtonBlock {
            aBlock!(self, buttonIndex)
        }
        _remove()
    }

    @objc func _clickCancel(sender:UIButton){
        delegate?.alertView(alertView: self, clickedButtonAtIndex: 0)
        if let aBlock = clickButtonBlock {
            aBlock!(self, 0)
        }
        _remove()
    }
    
    // MARK: - Life
    deinit {
//        let filename = URL(string:"\(#file)")?.lastPathComponent ?? ""
//        debugPrint("\(filename) 第 \(#line) 行  ,\(#function)")
    }
}
