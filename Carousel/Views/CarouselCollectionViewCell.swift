//
//  CarouselCollectionViewCell.swift
//  Carousel
//
//  Created by Kiroshan Thayaparan on 7/16/22.
//

import UIKit
import Kingfisher

class CarouselCollectionViewCell: UICollectionViewCell {
    
    var container: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.borderColor = UIColor.tertiarySystemFill.cgColor
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    var imageView: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()
    var title: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    var desc: UITextView = {
        var view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditable = false
        view.isSelectable = false
        view.backgroundColor = .clear
        return view
    }()
    
    var parent: UIViewController?
    var data: Carousel? = nil {
        didSet {
            print(data?.image_regular)
            imageView.kf.setImage(with: URL(string: data?.image_regular.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""), options: [.forceRefresh])
            imageView.contentMode = .scaleToFill
            title.text = data?.title
            desc.text = data?.description
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(view: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(view: UIView) {
        view.addSubview(container)
        view.addSubview(imageView)
        view.addSubview(title)
        view.addSubview(desc)
        
        NSLayoutConstraint.activate([
            container.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            container.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            container.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            imageView.leftAnchor.constraint(equalTo: container.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: container.rightAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.width-20),

            title.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 10),
            title.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -10),
            title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            title.bottomAnchor.constraint(equalTo: desc.topAnchor, constant: -5),

            desc.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 5),
            desc.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -5),
            desc.topAnchor.constraint(equalTo: title.bottomAnchor),
            desc.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5)
        ])
        container.dropShadow()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imagePreviewAction))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func imagePreviewAction() {
        let controller = ImagePreviewViewController()
        controller.image_string = data?.image_large
        parent?.navigationController?.pushViewController(controller, animated: true)
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.shadowColor = UIColor.quaternarySystemFill.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 5, height: 5) // I made this larger
        layer.shadowRadius = 5
        layer.masksToBounds = false
    }
}
