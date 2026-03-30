//
//  ViewController.swift
//  MyWeather
//
//  Created by Prasad Kukkala on 2/13/26.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    var displayStr = ""
    var buttonTapped: (() -> Void)?
    
    init(displayStr: String = "") {
        self.displayStr = displayStr
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let label = UILabel()
        label.text = displayStr
        label.textAlignment = .center
        label.frame = CGRect(x: 10, y: 100, width: 150, height: 30)
        label.layer.backgroundColor = UIColor.purple.cgColor
        view.addSubview(label)
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 10, y: 300, width: 150, height: 30)
        button.setTitle("Ok", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
        
        super.viewDidLoad()
    }
    
    @objc func buttonAction() {
        buttonTapped?()
    }
}
