//
//  ViewController.swift
//  Carousel
//
//  Created by Kiroshan Thayaparan on 7/16/22.
//

import UIKit

class ViewController: UIPageViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: "CarouselCollectionViewCell")
        return collectionView
    }()
    
    var counter = 0 {
        didSet {
            changeImageByIndex(index: counter)
        }
    }
    var carouselModel = CarouselModel()
    var dataArray: [Carousel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),

            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizerLeft.direction = .left
        collectionView.addGestureRecognizer(swipeGestureRecognizerLeft)
        
        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizerRight.direction = .right
        collectionView.addGestureRecognizer(swipeGestureRecognizerRight)
        
        addDoneButtonOnKeyboard()
        
        getImageData(search_key: "")
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        searchBar.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        searchBar.resignFirstResponder()
    }
    
    func getImageData(search_key: String) {
        ProgressView.shared.show(view, mainText: nil, detailText: nil)
        carouselModel.getImageData(search_key: search_key, getImageDataCallFinished: { (status) in
            if status {
                print("status_ ", status)
                self.dataArray.append(contentsOf: self.carouselModel.dataArray)
            }
            self.collectionView.reloadData()
            self.collectionView.setContentOffset(.zero, animated: false)
            ProgressView.shared.hide()
        })
    }
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            //print("Left")
            if counter < dataArray.count-1 {
                counter += 1
            }
        case .right:
            //print("Right")
            if counter > 0 {
                counter -= 1
            }
        default:
            break
        }
    }
    
    func changeImageByIndex(index: Int) {
        let indx = IndexPath.init(item: index, section: 0)
        self.collectionView.scrollToItem(at: indx, at: .centeredHorizontally, animated: true)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-50, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCollectionViewCell", for: indexPath) as! CarouselCollectionViewCell
        cell.parent = self
        cell.data = dataArray[indexPath.row]
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        self.dataArray.removeAll()
        getImageData(search_key: text)
        searchBar.resignFirstResponder()
    }
}
