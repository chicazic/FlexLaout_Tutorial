//
//  MainView.swift
//  FlexLayout_Tutorial
//
//  Created by 송형욱 on 2021/12/22.
//

import UIKit
import KarrotFlex
import Then
import RxCocoa
import RxSwift

class MainView: UIView {
    fileprivate let container = UIView()
    
    lazy var exampleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.textColor = .white
    }
    
    lazy var exampleTextfield = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    let disposeBag = DisposeBag()
    
    
    let labelText = BehaviorRelay<String?>(value: nil)
    

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        
        self.flex.define {
            FlexHStack($0, justifyContent: .center, alignItems: .center) {
                FlexVStack($0) {
                    FlexItem($0, view: exampleLabel)
                    FlexSpacer($0, spacing: 16)
                    FlexItem($0, view: exampleTextfield)
                }
            }
        }
        
        self.bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.flex.layout(mode: .fitContainer)
//        container.pin.all(pin.safeArea)
//        container.flex.layout()
    }
}

extension MainView {
    fileprivate func bind() {
        self.labelText
            .asDriver()
            .drive(self.exampleLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.exampleLabel
            .rx.observe(String.self, "text")
            .asDriverOnErrorJustComplete()
            .drive(onNext: { _ in
                self.exampleLabel.flex.markDirty()
                self.container.flex.layout()
            })
            .disposed(by: self.disposeBag)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MainViewPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let mainView = MainView()
            return mainView
        }.previewLayout(.sizeThatFits)
    }
}
#endif

//
//import UIKit
//import FlexLayout
//import PinLayout
//import Then
//import RxCocoa
//import RxSwift
//
//class MainView: UIView {
//    fileprivate let container = UIView()
//
//    lazy var exampleLabel = UILabel().then {
//        $0.font = .systemFont(ofSize: 16, weight: .bold)
//        $0.layer.cornerRadius = 8
//        $0.layer.masksToBounds = true
//        $0.textColor = .white
//    }
//
//    lazy var exampleTextfield = UITextField().then {
//        $0.borderStyle = .roundedRect
//    }
//
//    let disposeBag = DisposeBag()
//
//
//    let labelText = BehaviorRelay<String?>(value: nil)
//
//
//    init() {
//        super.init(frame: .zero)
//        backgroundColor = .white
//
//        // Yoga's C Example
//        container.flex.direction(.column).alignItems(.center).define { flex in
//            flex.addItem(exampleLabel).minWidth(200).height(60).marginTop(16).backgroundColor(.black)
//            flex.addItem(exampleTextfield).width(200).height(60).marginTop(16)
//
//        }
//        container.backgroundColor = .white
//
//        addSubview(container)
//
//        self.bind()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        container.pin.all(pin.safeArea)
//        container.flex.layout()
//    }
//}
//
//extension MainView {
//    fileprivate func bind() {
//        self.labelText
//            .asDriver()
//            .drive(self.exampleLabel.rx.text)
//            .disposed(by: self.disposeBag)
//
//        self.exampleLabel
//            .rx.observe(String.self, "text")
//            .asDriverOnErrorJustComplete()
//            .drive(onNext: { _ in
//                self.exampleLabel.flex.markDirty()
//                self.container.flex.layout()
//            })
//            .disposed(by: self.disposeBag)
//    }
//}
//
//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct MainViewPreview: PreviewProvider{
//    static var previews: some View {
//        UIViewPreview {
//            let mainView = MainView()
//            return mainView
//        }.previewLayout(.sizeThatFits)
//    }
//}
//#endif
