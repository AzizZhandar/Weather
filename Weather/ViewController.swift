//
//  ViewController.swift
//  Weather
//
//  Created by Aziz Zhandar on 06.04.2022.
//

import UIKit
import CoreLocation

private struct LocalSpacing {
    static let buttonSizeSmall = CGFloat(44)
    static let buttonSizelarge = CGFloat(120)
}

class ViewController: UIViewController {

    let locationManager = CLLocationManager()

    var weatherService = WeatherService()
    let backgroundView = UIImageView()
//    let searchStackView = UIStackView()
    let locationButton = UIButton()
    let viewArea = UIView()
    let searchButton = UIButton()
    let searchTextField = UITextField()

    let conditionImageView = UIImageView()
    let temperatureLabel = UILabel()
    let cityLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
        style()
        layout()
    }
}

extension ViewController {

    func setup() {
        searchTextField.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherService.delegate = self
    }
    
    func style() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.image = UIImage(named: "background")
        backgroundView.contentMode = .scaleAspectFill
        
//        searchStackView.translatesAutoresizingMaskIntoConstraints = false
//        searchStackView.spacing = 8
//        searchStackView.axis = .horizontal


        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.setBackgroundImage(UIImage(systemName: "location.north.circle.fill"), for: .normal)

        locationButton.addTarget(self, action: #selector(locationPressed(_:)), for: .primaryActionTriggered)
        locationButton.tintColor = .label

        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchPressed(_:)), for: .primaryActionTriggered)
        searchButton.tintColor = .label

        viewArea.translatesAutoresizingMaskIntoConstraints = false
        viewArea.backgroundColor = UIColor(white: 1, alpha: 0.5)
        viewArea.layer.cornerRadius = 25

        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.font = UIFont.preferredFont(forTextStyle: .title1)
        searchTextField.placeholder = "Search"
        searchTextField.textAlignment = .right
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = .systemFill

        conditionImageView.translatesAutoresizingMaskIntoConstraints = false
        conditionImageView.image = UIImage(systemName: "sun.max")
        conditionImageView.tintColor = .label
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.systemFont(ofSize: 65)
        temperatureLabel.attributedText = makeTemperatureText(with: "23.4")

        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.text = "Almaty"
        cityLabel.textColor = .white
        cityLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        cityLabel.font = UIFont.systemFont(ofSize: 45)
    }

    private func makeTemperatureText(with temperature: String) -> NSAttributedString {

        var boldTextAttributes = [NSAttributedString.Key: AnyObject]()
        boldTextAttributes[.foregroundColor] = UIColor.label
        boldTextAttributes[.font] = UIFont.boldSystemFont(ofSize: 65)

        var plainTextAttributes = [NSAttributedString.Key: AnyObject]()
        plainTextAttributes[.font] = UIFont.systemFont(ofSize: 40)

        let text = NSMutableAttributedString(string: temperature, attributes: boldTextAttributes)
        text.append(NSAttributedString(string: "°C", attributes: plainTextAttributes))

        return text
    }

    func layout() {
        view.addSubview(backgroundView)
        view.addSubview(locationButton)
        view.addSubview(viewArea)
        view.addSubview(searchButton)
        view.addSubview(searchTextField)
        viewArea.addSubview(conditionImageView)
        viewArea.addSubview(temperatureLabel)
        view.addSubview(cityLabel)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationButton.widthAnchor.constraint(equalToConstant: 40),
            locationButton.heightAnchor.constraint(equalToConstant: 40),

            viewArea.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            viewArea.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            viewArea.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            viewArea.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -250),
            viewArea.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewArea.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: locationButton.trailingAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -8),

            conditionImageView.topAnchor.constraint(equalTo: viewArea.topAnchor, constant: 44),
            conditionImageView.heightAnchor.constraint(equalToConstant: 130),
            conditionImageView.widthAnchor.constraint(equalToConstant: 130),
            conditionImageView.centerXAnchor.constraint(equalTo: viewArea.centerXAnchor),

            temperatureLabel.bottomAnchor.constraint(equalTo: viewArea.bottomAnchor, constant: -24),
            temperatureLabel.centerXAnchor.constraint(equalTo: viewArea.centerXAnchor),
            
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 56),
            
        ])
    }
}

// MARK: - UITextField Delegate

extension ViewController: UITextFieldDelegate {
    
    @objc func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherService.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
    
}

extension ViewController: CLLocationManagerDelegate {
    
    @objc func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
//            weatherService.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - WeatherManagerDelegate

extension ViewController: WeatherServiceDelegate {
    
    func didFetchWeather(_ weatherService: WeatherService, _ weather: WeatherModel) {
        self.temperatureLabel.attributedText = self.makeTemperatureText(with: weather.temperatureString)
        self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        self.cityLabel.text = weather.cityName
    }
    
    func didFailWithError(_ weatherService: WeatherService, _ error: ServiceError) {
        let message: String
        
        switch error {
        case .network(statusCode: let statusCode):
            message = "Networking error. Status code: \(statusCode)."
        case .parsing:
            message = "JSON weather data could not be parsed."
        case .general(reason: let reason):
            message = reason
        }
        showErrorAlert(with: message)
    }
    
    func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error fetching weather",
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
