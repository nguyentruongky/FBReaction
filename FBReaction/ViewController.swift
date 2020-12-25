//
//  ViewController.swift
//  FBReaction
//
//  Created by Ky Nguyen on 12/17/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let reactionView = FBReactionPopup()
    override func viewDidLoad() {
        super.viewDidLoad()
        reactionView.setupPopup(in: view)
        reactionView.backgroundColor = .green
        reactionView.frame = CGRect(x: 0, y: 0, width: 48, height: 24)
        view.addSubview(reactionView)
        reactionView.center = view.center
    }

}

