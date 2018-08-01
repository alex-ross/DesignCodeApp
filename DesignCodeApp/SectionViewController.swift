//
//  SectionViewController.swift
//  DesignCodeApp
//
//  Created by Meng To on 12/11/17.
//  Copyright © 2017 Meng To. All rights reserved.
//

import UIKit

class SectionViewController: UIViewController {

    var section: [String: String]!
    var sections: [[String: String]]!
    var indexPath: IndexPath!

    // MARK: - IBOutlets

    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - IBActions

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = section["title"]
        captionLabel.text = section["title"]
        bodyLabel.text = section["body"]
        coverImageView.image = UIImage(named: section["image"]!)
        progressLabel.text = "\(indexPath.row+1) / \(sections.count)"
    }
}
