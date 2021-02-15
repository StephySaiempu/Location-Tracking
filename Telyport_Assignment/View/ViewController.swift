//
//  ViewController.swift
//  Telyport_Assignment
//
//  Created by Girira Stephy on 13/02/21.
//

import UIKit
import CoreLocation
import Firebase



//*******If the app is not getting launched in the device.Please go to Settings->General->DeviceManagement->Trust The Apple Development*******This is because of
//inadequate entitlements or its profile has not been explicitly trusted by the user.


class ViewController: UIViewController {
    
    var dataUploadsLabel: UILabel!
    var timeLabel: UILabel!
    var viewModel: LocationViewModel!
    var textLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewModel = LocationViewModel(delegateValue: self)
    }
    
    func initViews(){
        dataUploadsLabel = UILabel()
        view.addSubview(dataUploadsLabel)
        dataUploadsLabel.translatesAutoresizingMaskIntoConstraints = false
        dataUploadsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        dataUploadsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        dataUploadsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        dataUploadsLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        dataUploadsLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        dataUploadsLabel.textColor = .black
        dataUploadsLabel.adjustsFontSizeToFitWidth = true
        dataUploadsLabel.numberOfLines = 2
        
        textLabel = UILabel()
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: dataUploadsLabel.bottomAnchor, constant: 32).isActive = true
        textLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        textLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textLabel.textColor = .black
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.numberOfLines = 2
        textLabel.text = "Last Updated Time:"
        textLabel.isHidden = true
        
        timeLabel = UILabel()
        view.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 4).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        timeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        timeLabel.textColor = .blue
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.numberOfLines = 2
    }
    
}

extension ViewController: UpdateLocationProtocol{
    func updateTime(_ timeValue: String) {
        textLabel.isHidden = false
        timeLabel.text = timeValue
    }
    
    func updateLocationCount(_ value: String) {
        dataUploadsLabel.text = value
    }
    
    func presentError(_ title: String,subHeading: String) {
        let alert = UIAlertController.init(title: title, message: subHeading, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Go to Settings", style: .default, handler: { [weak self] (_) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    
                })
            }
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (_) in
            //show error view
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}


