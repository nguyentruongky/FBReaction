//
//  ReactionView.swift
//  FBReaction
//
//  Created by Ky Nguyen on 12/17/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class FBReactionPopup: UIView {
    private lazy var iconContainerView = createPopup()
    
    private func createPopup() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        let iconHeight: CGFloat = 50
        let padding: CGFloat = 8

        let icons = [
            "reaction_like",
            "reaction_love",
            "reaction_angry",
            "reaction_haha",
            "reaction_sad",
            "reaction_wow"
            ].map({ imageName -> UIView in
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.layer.cornerRadius = iconHeight/2
            imageView.isUserInteractionEnabled = true
            return imageView
        })
        
        let stackView = UIStackView(arrangedSubviews: icons)
        stackView.distribution = .fillEqually
        
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(stackView)
        
        let iconCount = CGFloat(stackView.arrangedSubviews.count)
        let containerW = iconCount*iconHeight + (iconCount+1)*padding
        containerView.frame = CGRect(x: 0, y: 0, width: containerW, height: iconHeight + padding*2)
        containerView.layer.cornerRadius = containerView.frame.height/2

        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)

        stackView.frame = containerView.frame
        return containerView
    }
    private weak var parent: UIView?
    func setupPopup(in view: UIView) {
        parent = view
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        gesture.minimumPressDuration = 0
        addGestureRecognizer(gesture)
    }
}

extension FBReactionPopup {
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
        } else if gesture.state == .ended {
            handleGestureEnded(gesture: gesture)
        } else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
    }
    private func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        guard let view = parent else { return }
        view.addSubview(iconContainerView)
        let pressedLocation = gesture.location(in: view)
        let centerX = (view.frame.width-iconContainerView.frame.width)/2

        iconContainerView.alpha = 0
        iconContainerView.transform = CGAffineTransform(translationX: centerX, y: pressedLocation.y)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            self?.iconContainerView.alpha = 1
            self?.iconContainerView.transform = CGAffineTransform(translationX: centerX, y: pressedLocation.y-40)
        })
    }
    private func handleGestureChanged(gesture: UILongPressGestureRecognizer) {
        let pressedLocation = gesture.location(in: iconContainerView)
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.iconContainerView.frame.height/2)
        let hitTestView = iconContainerView.hitTest(fixedYLocation, with: nil)
        if hitTestView is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: { [weak self] in
                self?.resetIconsAnimation()
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -30)
            })
        }
    }
    private func handleGestureEnded(gesture: UILongPressGestureRecognizer) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: { [weak self] in
            guard let self = self else { return }
            self.resetIconsAnimation()
            self.iconContainerView.transform = self.iconContainerView.transform.translatedBy(x: 0, y: 50)
            self.iconContainerView.alpha = 0
        }, completion: { _ in
            self.iconContainerView.removeFromSuperview()
        })

    }
}

extension FBReactionPopup {
    func resetIconsAnimation() {
        let stackView = iconContainerView.subviews.first
        stackView?.subviews.forEach({ imageView in
            imageView.transform = .identity
        })
    }
}
