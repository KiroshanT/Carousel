//
//  ImagePreviewViewController.swift
//  Carousel
//
//  Created by Kiroshan Thayaparan on 7/16/22.
//

import UIKit
import Kingfisher

class ImagePreviewViewController: UIViewController {
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.tertiarySystemFill.cgColor
        button.layer.borderWidth = 1
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return button
    }()
    var imageView: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    var image_string: String? = nil {
        didSet {
            ProgressView.shared.show(view, mainText: nil, detailText: nil)
            imageView.kf.setImage(with: URL(string: image_string ?? "")) { result in
                switch result {
                case .success(let value):
                    self.imageView.image = value.image
                case .failure(let error):
                    print(error) // The error happens
                }
                ProgressView.shared.hide()
            }
            imageView.contentMode = .scaleAspectFit
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        view.addSubview(imageView)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension ImagePreviewViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
