//
//  Functions.swift
//  F1Search
//
//  Created by Константин Чернов on 27.01.2021.
//

import Foundation
import PKHUD

enum HUDOptions {
    case stopAnimating
    case lodaing
    case success
    case urlFailure
    case emptySearchResult
}

func showHUD(for hud: HUDOptions) {
    switch hud {
    case .success: HUD.flash(.labeledSuccess(title: "Success", subtitle: nil), delay: 1.0)
    case .urlFailure: HUD.flash(.labeledError(title: "Error during request", subtitle: nil), delay: 2.0)
    case .emptySearchResult: HUD.flash(.label("No data available"), delay: 2.0)
    case .lodaing: HUD.show(.labeledProgress(title: "Loading...", subtitle: nil))
    case .stopAnimating: HUD.hide()
    }
}
