<p align="center">
  <img width="150" height="150" src="./assets/countrykit_app_icon.svg">
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.x-orange?logo=swift" alt="Swift 5.x">
    <img src="https://img.shields.io/badge/iOS-14%2B-blue?logo=apple" alt="iOS 14+">
    <img src="https://img.shields.io/badge/License-MIT-lightgrey" alt="MIT License">
</p>

# CountryKit 

CountryKit provides a convenient way to interact with countries, their metadata and comes with a pre-built UI.
<p align="center">
  <img src="./assets/hero_image.gif">
</p>

## Installation (iOS, macCatalyst)

### Swift Package Manager 
Add CountryKit to your project via Swift Package Manager.

`https://github.com/eclypse-tms/CountryKit`

## Usage
```
//in a view controller:
let countryPickerVC = UICountryPickerViewController()
countryPickerVC.delegate = self //to receive callbacks when a country is selected or deselected

//present the view controller according to your UX. this example presents it modally in a navigation controller
let navController = UINavigationController(rootViewController: countryPickerVC)
navController.modalPresentationStyle = .formSheet
present(navController, animated: true)
```
