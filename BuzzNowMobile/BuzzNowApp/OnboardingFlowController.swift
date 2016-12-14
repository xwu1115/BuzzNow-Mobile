//
//  OnboardingFlowController.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 9/26/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//
import Foundation
import UIKit

enum OnboardingState: UInt {
    case Welcome = 0
    case Authorized
    case Register
    case Completed
}

protocol NavigationFlowContainer {
    func pushNext()
    func pop()
    func dismissFlow()
}

class OnboardingFlowController: NSObject, NavigationFlowContainer {
    private let navigationController: UINavigationController
    private var state: OnboardingState = .Welcome
    private let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())

    init(nav: UINavigationController) {
        navigationController = nav
        super.init()
        
        startFlow()
    }

    private func startFlow() {
        if let vc = setupViewController("welcome") {
            navigationController.pushViewController(vc, animated: true)
        }
    }

    func pushNext() {
        var identifier = ""
        switch state {
        case .Welcome:
            identifier = "authorize"
            break
        case .Authorized:
             identifier = "register"
            break
        case .Register:
             identifier = "complete"
            break
        case .Completed:
            dismissFlow()
            return
        }
        guard let vc = setupViewController(identifier) else {
            return
        }
        navigationController.pushViewController(vc, animated: true)
        state = OnboardingState(rawValue: state.rawValue + 1)!
    }

    func pop() {
        if state == .Welcome {
            return
        }
        navigationController.popViewControllerAnimated(true)
        state = OnboardingState(rawValue: state.rawValue - 1)!
    }

    func dismissFlow() {
        navigationController.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    private func setupViewController(identifier:String) -> UIViewController? {
        let vc = storyboard.instantiateViewControllerWithIdentifier(identifier)
        if let vc = vc as? OnboardingBaseViewController {
            vc.flowController = self
            return vc
        }
        return nil
    }
}
