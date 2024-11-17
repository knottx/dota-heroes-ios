//
//  LoadingOverlayView.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import UIKit

final class LoadingOverlayView: UIView {
    private let indicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.25)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        indicator.startAnimating()
        isUserInteractionEnabled = true
    }
    required init?(coder: NSCoder) { fatalError() }
}
