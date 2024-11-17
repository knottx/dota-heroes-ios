//
//  BaseViewController.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
//

import RxSwift
import SimpleHUD
import UIKit

typealias BaseViewController = ViewController & ViewControllerProtocol

protocol ViewControllerProtocol {
    func configureView()
    func bind()
}

class ViewController: UIViewController {
    private var loadingView: SimpleHUD?

    let bag = DisposeBag()

    lazy var refresher = UIRefreshControl()

    lazy var errorToaster = Binder<Error>(self) { s, error in s.alert(title: "Sorry", message: error.localizedDescription) }

    lazy var loadingIndicator = Binder<Bool>(self) { s, isLoading in isLoading ? s.showLoading() : s.hideLoading() }

    lazy var refreshControlBinder = Binder<Bool>(self) { s, isLoading in if !isLoading { s.refresher.endRefreshing() }}

    lazy var viewEndEditing = Binder<Void>(self) { s, _ in s.view.endEditing(true) }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let base = self as? ViewControllerProtocol {
            base.configureView()
            base.bind()
        }
    }

    func alert(title: String? = nil, message: String? = nil,
               actionTitle: String? = nil, handler: ((UIAlertAction) -> Void)? = nil,
               presentCompletion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK",
                                       style: .cancel, handler: handler)
            alertController.addAction(cancel)
            self?.present(alertController, animated: true, completion: presentCompletion)
        }
    }

    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard self.loadingView == nil else { return }
            self.loadingView = .init()
            let tabBarController = self.parent?.tabBarController ?? self.tabBarController
            let navigationController = self.parent?.navigationController ?? self.navigationController
            let bezelsBlurEffect: UIBlurEffect.Style
            if #available(iOS 13, *) {
                bezelsBlurEffect = .systemUltraThinMaterial
            } else {
                bezelsBlurEffect = .prominent
            }
            self.loadingView?.show(at: (tabBarController ?? navigationController ?? self).view,
                                   withBezels: true,
                                   bezelsBlurEffect: bezelsBlurEffect)
        }
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView?.dismiss()
            self?.loadingView = nil
        }
    }
}
