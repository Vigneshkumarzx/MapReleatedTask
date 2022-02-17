//
//  Extension.swift
//  MapReleatedTask
//
//  Created by vignesh kumar c on 16/02/22.
//

import Foundation
import GoogleMaps
import GooglePlaces

extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}

extension UIViewController {

    private func present(_ dismissableAlert: UIAlertController) {
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
        dismissableAlert.addAction(dismissAction)
        present(dismissableAlert, animated: true)
    }

    func presentAlert(with message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert)
    }

    func present(_ error: Error) {
        presentAlert(with: error.localizedDescription)
    }
}

let imageCache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func setImage(from url: URL,
                  contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        contentMode = mode
        if let imageCached = imageCache.object(forKey: url.absoluteString as NSString) {
            image = imageCached
            return
        }else{
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                }
            }.resume()
        }
    }
    func setImage(from link: String,
                  contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        setImage(from: url, contentMode: mode)
    }
}

extension UIView {
    func addTapGestureRecognizer(with action: Selector, target: Any, tag: Int = 0) {
        let tapGestureRegcognizer = UITapGestureRecognizer()
        self.tag = tag
        tapGestureRegcognizer.addTarget(target, action: action)
        tapGestureRegcognizer.numberOfTapsRequired = 1
        tapGestureRegcognizer.numberOfTouchesRequired = 1
        addGestureRecognizer(tapGestureRegcognizer)
    }
}

