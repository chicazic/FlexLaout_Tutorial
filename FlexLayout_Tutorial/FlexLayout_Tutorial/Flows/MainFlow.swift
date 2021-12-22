//
//  MainFlow.swift
//  FlexLayout_tutorial
//
//  Created by 송형욱 on 2021/12/22.
//

import Foundation
import UIKit
import RxFlow
import RxSwift
import RxCocoa

class MainFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    init() {}

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .showMain:
            return self.showMain()
        }
    }
    
    private func showMain() -> FlowContributors {
        let viewController = MainViewController()
        self.rootViewController.setViewControllers([viewController], animated: false)
        return .one(flowContributor: .contribute(withNext: viewController))
    }
}
