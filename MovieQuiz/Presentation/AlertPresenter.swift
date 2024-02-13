//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Паша Шатовкин on 19.10.2023.
//

import Foundation
import UIKit

protocol AlertPresenter{
    func show(alertModel: AlertModel)
}

final class AlertPresenterImp {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}

extension AlertPresenterImp: AlertPresenter {
    func show(alertModel result: AlertModel){
        let alert = UIAlertController(title: result.title,
                                      message: result.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion()
        }
        alert.addAction(action)
        alert.view.accessibilityIdentifier = "Game results"
        viewController?.present(alert, animated: true)
    }
}
