//
//  UIImageView+Extension.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setImage(stringUrl: String?, placeholderImage: UIImage? = nil, grayScale: Bool = false) {
        DispatchQueue.main.async {
            if let imageUrl = stringUrl,
               let url = URL(string: imageUrl) {
                self.setImage(url: url, placeholderImage: placeholderImage, grayScale: grayScale)
            } else {
                self.image = placeholderImage
            }
        }
    }

    func setImage(url: URL?, placeholderImage: UIImage? = nil, grayScale: Bool = false) {
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
        var options: KingfisherOptionsInfo = [.processor(processor),
                                              .scaleFactor(UIScreen.main.scale),
                                              .transition(.fade(1)),
                                              .cacheOriginalImage]
        if grayScale {
            options.append(.processor(ColorControlsProcessor(brightness: 0,
                                                             contrast: 1,
                                                             saturation: 0,
                                                             inputEV: -0.5)))
        }
        self.kf.indicatorType = .activity
        DispatchQueue.main.async {
            if let url = url {
                self.kf.setImage(with: url, placeholder: placeholderImage, options: options)
            } else {
                self.image = placeholderImage
            }
        }
    }
}
