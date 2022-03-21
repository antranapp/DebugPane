//
// Copyright © 2022 An Tran. All rights reserved.
//

import Combine
import UIKit
import Alamofire
import Logging
import Pulse
import LocalConsole
import SwiftUI
import PulseUI

final class ViewController: UIViewController {
    
    private var appService: AppService
    
    private var bag = Set<AnyCancellable>()
    
    private lazy var label = UILabel()
    
    private lazy var logger = Logger(label: "app.antran.debugpane.demo")
    private lazy var networkLogger = NetworkLogger()
    var session: Session!

    init(appService: AppService) {
        self.appService = appService
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        label.text = "Dark Mode: \(appService.darkModeEnabled)"
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        
        let instructionLabel = UILabel()
        instructionLabel.text = "Swipe from the right edge to open the Debug Menu"
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.font = .systemFont(ofSize: 12)
        
        let button = UIButton()
        button.setTitleColor(.tintColor, for: .normal)
        button.setTitle("Trigger Network", for: .normal)
        button.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)

        let pulseButton = UIButton()
        pulseButton.setTitleColor(.tintColor, for: .normal)
        pulseButton.setTitle("Show Pulse UI", for: .normal)
        pulseButton.addTarget(self, action: #selector(self.didTapPulseButton), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [label, instructionLabel, button, pulseButton])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
        ])
        
        let lcMonitor = ClosureEventMonitor()
        lcMonitor.requestDidFinish = { _ in
            LCManager.shared.print("Request Finished")
        }
        
        let networkMonitor = NetworkLoggerEventMonitor(logger: networkLogger)
        session = Session(eventMonitors: [lcMonitor, networkMonitor])
    }
    
    private func setupBindings() {
        appService.$darkModeEnabled
            .sink { [weak self] value in
                self?.label.text = "Dark Mode: \(value)"
            }
            .store(in: &bag)
    }
    
    @objc func didTapButton() {
        session.request("https://httpbin.org/get").responseString { response in
            print(response)
        }
    }

    @objc func didTapPulseButton() {
        present(UIHostingController(rootView: MainView()), animated: true)
    }
}
