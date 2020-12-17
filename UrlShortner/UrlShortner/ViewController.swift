//
//  ViewController.swift
//  UrlShortner
//
//  Created by The Developer

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textField)
        view.addSubview(button)
        view.addSubview(label)
        button.addTarget(self, action: #selector(Submiting), for: .touchUpInside)
        
    }

    private var textField: UITextField = {
        var field = UITextField()
        field.frame = CGRect(x: 30, y: 200, width: 350, height: 60)
        field.layer.cornerRadius = 12
        field.backgroundColor = .secondarySystemBackground
        field.returnKeyType = .done
        field.placeholder = "Your Full Url Here"
        field.setLeftPaddingPoints(10)
        field.setRightPaddingPoints(10)
        field.autocapitalizationType = .sentences
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftViewMode = .always
        return field
    }()
    
    private var button: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 30, y: 270, width: 350, height: 60)
        button.layer.cornerRadius = 12

        return button
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.text = "Your Url Here"
        label.frame = CGRect(x: 30, y: 340, width: 350, height: 60)
        label.font = UIFont(name: "Arial", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    
    @objc func Submiting() {
        label.text = ShortenURL(URLToShorten: textField.text ?? "No Text")
        UIPasteboard.general.string = label.text
        let alert = UIAlertController(title: "Copied", message: "Your Shortened URL has been copied", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.textField.text = ""
            self.label.text = "Your URL Here"
        }
    }
}

extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textField {
            
        }
       return true
    }
}

extension ViewController {
    
    func ShortenURL(URLToShorten:String) -> String {
        if verifyUrl(urlString:URLToShorten) != false{
            guard let apiEndpoint = URL(string: "http://tinyurl.com/api-create.php?url=\(URLToShorten)")else {
                self.ErrorMessage(error:("Error: doesn't seem to be a valid URL") as String)
                return "" as String
            }
            do {
                let shortURL = try String(contentsOf: apiEndpoint, encoding: String.Encoding.ascii)
                return shortURL as String
            } catch let Error{
                self.ErrorMessage(error:Error.localizedDescription)
                return URLToShorten as String
            }
        }else{
            self.ErrorMessage(error:" This URL doesn't seem to be valid or text is blank")
            return "" as String
        }
    }
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url  = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    func ErrorMessage(error:String) {
        let ErrorMessageAlert = UIAlertController(title:"Error", message: error, preferredStyle: UIAlertController.Style.alert)
        ErrorMessageAlert.addAction((UIAlertAction(title: "OK", style: .default, handler: nil)))
        self.present(ErrorMessageAlert, animated: true, completion: nil)
        print("Error:\(error)")
    }

   
}
