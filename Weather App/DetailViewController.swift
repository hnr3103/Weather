//
//  DetailViewController.swift
//  Weather App
//
//  Created by Ravichandran HN on 3/20/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit

class DetailViewController:UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailDesc: UILabel!
    var weather:Weather?
    override func viewDidLoad() {
        self.titleLabel.text = weather?.main;
        self.detailDesc.text = weather?.wheatherDesc;
    }
}
