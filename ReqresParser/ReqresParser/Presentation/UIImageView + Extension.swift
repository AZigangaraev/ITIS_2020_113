//
//  UIImage + Extension.swift
//  ReqresParser
//
//  Created by Руслан Ахмадеев on 01.12.2020.
//

import UIKit

extension UIImageView {
    
    func load(from url: URL) {
        let indicatorReference = setupActivityIndicator()
        let session = URLSession.shared
        session.dataTask(with: url) { data, _, _ in
            var image: UIImage? = nil
            defer {
                DispatchQueue.main.async { [weak self] in
                    indicatorReference.removeFromSuperview()
                    self?.image = image
                }
            }
            
            guard let data = data else { return }
            image = UIImage(data: data)
        }.resume()
    }
    
    private func setupActivityIndicator() -> UIActivityIndicatorView {
        let indicator: UIActivityIndicatorView = {
            let view = UIActivityIndicatorView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.startAnimating()
            return view
        }()
        
        addSubview(indicator)
        NSLayoutConstraint.activate( [
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        return indicator
    }
}
