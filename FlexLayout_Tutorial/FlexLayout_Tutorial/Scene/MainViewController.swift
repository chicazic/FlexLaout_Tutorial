//
//  MainViewController.swift
//  FlexLayout_Tutorial
//
//  Created by 송형욱 on 2021/12/22.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

class MainViewController: UIViewController, Stepper {
    
    fileprivate var mainView: MainView {
        return self.view as! MainView
    }
    
    var steps = PublishRelay<Step>()
    let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
    }
}

extension MainViewController {
    private func bind() {
        mainView.exampleTextfield.rx.text
            .bind(to: self.mainView.labelText)
            .disposed(by: self.disposeBag)
    }
}
