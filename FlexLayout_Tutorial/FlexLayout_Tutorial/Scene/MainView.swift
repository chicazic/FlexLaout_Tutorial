//
//  MainView.swift
//  FlexLayout_Tutorial
//
//  Created by 송형욱 on 2021/12/22.
//

import UIKit
import FlexLayout
import PinLayout
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
    
    lazy var exampleAnimationView = UIView()
    lazy var exampleAnimationButton = UIButton()

    let disposeBag = DisposeBag()


    let labelText = BehaviorRelay<String?>(value: nil)
    let showAnimation = BehaviorRelay<Bool>(value: false)


    init() {
        super.init(frame: .zero)
        backgroundColor = .white

        // Yoga's C Example
        container.flex.direction(.column).alignItems(.center).define { flex in
            flex.addItem(exampleLabel).minWidth(200).height(60).marginTop(16).backgroundColor(.black)
            flex.addItem(exampleTextfield).width(200).height(60).marginTop(16)
            
            flex.addItem(exampleAnimationView).aspectRatio(1).width(300).marginTop(50).backgroundColor(.orange)
            flex.addItem(exampleAnimationButton).width(300).height(56).marginTop(16).backgroundColor(.green)

        }
        container.backgroundColor = .white

        addSubview(container)

        self.bind()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        container.pin.all(pin.safeArea)
        container.flex.layout()
    }
}

extension MainView {
    
    // MARK: Bind
    fileprivate func bind() {
        self.labelText
            .asDriver()
            .drive(self.exampleLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.exampleLabel
            .rx.observe(String.self, "text") // observe
            .asDriverOnErrorJustComplete()
            .drive(onNext: { _ in
                self.exampleLabel.flex.markDirty()
                self.container.flex.layout()
            })
            .disposed(by: self.disposeBag)
        
        self.exampleAnimationButton
            .rx.tap
            .map { !self.showAnimation.value }
            .bind(to: self.showAnimation)
            .disposed(by: self.disposeBag)
        
        self.showAnimation
            .withUnretained(self)
            .asDriverOnErrorJustComplete()
            .drive(onNext: { `self`, show in
                self.showAnimationView(show: show)
            })
            .disposed(by: self.disposeBag)
    }
    
    // MARK: Action
    fileprivate func showAnimationView(show: Bool) {
//        let width = show ? 300 : 50
//        self.exampleAnimationView.flex.aspectRatio(1).width(50)
        
        if show {
            self.exampleAnimationView.flex.aspectRatio(1).width(300)
        }
        else {
            self.exampleAnimationView.flex.aspectRatio(1).width(50)
        }
        self.exampleAnimationView.flex.markDirty()
        
        self.setNeedsLayout()
        
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
        }
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
