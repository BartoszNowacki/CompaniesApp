//
//  UIViewController.swift
//  CompaniesApp
//
//  Created by Bartosz Nowacki on 20/06/2020.
//  Copyright © 2020 Bartosz Nowacki. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit

public extension UIViewController {
    
    static func instantiate(identifier: String, fromStoryboardNamed storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    static func instantiate(navigationIdentifier: String, fromStoryboardNamed storyboardName: String) -> (UINavigationController, UIViewController) {
        let nc = instantiate(identifier: navigationIdentifier, fromStoryboardNamed: storyboardName) as! UINavigationController
        guard nc.viewControllers.count > 0 else {
            fatalError("Navigation controller \(nc) has no root view controller")
        }
        
        return (nc, nc.viewControllers[0])
    }
    
    func display(message: String, color: UIColor = #colorLiteral(red: 0.4267883301, green: 0.7820414901, blue: 0.857655108, alpha: 1)) {
          var attributes = EKAttributes.topToast
          attributes.entryBackground = .color(color: EKColor(color))
          attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
          attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
          attributes.statusBar = .dark
          attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
          attributes.displayDuration = 4.0
          
          let edgeWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
          attributes.positionConstraints.maxSize = .init(width: .constant(value: edgeWidth), height: .intrinsic)
          
          let titleFont = UIFont(name: "VWAGTheSans-Regular", size: 20.0)!
          let descriptionFont = UIFont(name: "VWAGTheSans-Regular", size: 1.0)!
          let textColor = EKColor(.white)
          
          let title = EKProperty.LabelContent(text: message, style: .init(font: titleFont, color: textColor))
          let description = EKProperty.LabelContent(text: String(), style: .init(font: descriptionFont, color: textColor))
          let image = EKProperty.ImageContent(image: UIImage(named: "xcross")!, size: CGSize(width: 35, height: 35))
          let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
          let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
          
          let contentView = EKNotificationMessageView(with: notificationMessage)
          SwiftEntryKit.display(entry: contentView, using: attributes)
      }
}

