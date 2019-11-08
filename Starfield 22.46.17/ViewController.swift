//
//  ViewController.swift
//  Starfield
//
//  Created by Влад Свиридов on 13/09/2019.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var starField: StarFieldView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.starField.startAnimation()
    }
        
    private func setup() {
        self.view.backgroundColor = .black
        
        let starFieldView = StarFieldView(frame: CGRect(x: 0, y: 0, width: self.view.frame.height, height: self.view.frame.height))
        starFieldView.center = self.view.center
        self.starField = starFieldView
        self.view.addSubview(starFieldView)
    }
    
}

