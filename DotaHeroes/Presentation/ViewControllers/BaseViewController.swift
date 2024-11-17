//
//  BaseViewController.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import RxSwift 
import UIKit
 

class BaseViewController: UIViewController {

    let bag = DisposeBag()

    lazy var refresher = UIRefreshControl()

    lazy var errorToaster = Binder<Error>(self) { s, error in
        s.alert(title: "Sorry", message: error.localizedDescription)
    }

    lazy var loadingIndicator = Binder<Bool>(self) { s, isLoading in
        if isLoading {
            s.showLoadingOverlay()
        } else {
            s.hideLoadingOverlay()
            s.refresher.endRefreshing()
        }
    }

    lazy var viewEndEditing = Binder<Void>(self) { s, _ in s.view.endEditing(true) }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
 

    func alert(title: String? = nil, message: String? = nil,
               actionTitle: String? = nil, handler: ((UIAlertAction) -> Void)? = nil,
               presentCompletion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK",
                                       style: .cancel, handler: handler)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: presentCompletion)
        }
    }
    
    func showLoadingOverlay() {
        guard self.view.viewWithTag(999_001) == nil else { return }
        let overlay = LoadingOverlayView(frame: self.view.bounds)
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.tag = 999_001
        self.view.addSubview(overlay)
    }
    func hideLoadingOverlay() {
        self.view.viewWithTag(999_001)?.removeFromSuperview()
    }
}
