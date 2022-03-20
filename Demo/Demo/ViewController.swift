//
// Copyright © 2022 An Tran. All rights reserved.
//

import Combine
import UIKit

final class ViewController: UIViewController {
    
    private var appService: AppService
    
    private var bag = Set<AnyCancellable>()
    
    private lazy var label = UILabel()
    
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
        
        let stackView = UIStackView(arrangedSubviews: [label, instructionLabel])
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
    }
    
    private func setupBindings() {
        appService.$darkModeEnabled
            .sink { [weak self] value in
                self?.label.text = "Dark Mode: \(value)"
            }
            .store(in: &bag)
    }
}
