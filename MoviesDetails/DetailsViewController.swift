//
//  DetailsViewController.swift
//  MoviesDetails
//
//  Created by Kumar Utsav on 08/01/19.
//  Copyright © 2019 Kumar Utsav. All rights reserved.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {

    @IBOutlet weak var titleDetails: UILabel!
    @IBOutlet weak var imageDetails: UIImageView!
    @IBOutlet weak var typeDetails: UILabel!
    var titleString: String?
    var imageUrl: ImageResource?
    var typeString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleDetails.text = titleString
        imageDetails.kf.setImage(with: imageUrl)
        typeDetails.text = typeString
    }
    
}
