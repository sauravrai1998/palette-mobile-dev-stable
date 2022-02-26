//
//  PreLoginVC.swift
//  ShareDrawerUI
//
//  Created by Jagdeep Singh on 17/01/22.
//

import UIKit

class PreLoginVC: UIViewController {
  
  var paletteLogoImageView = UIImageView(image: UIImage(named: "palette_logo"))
  var loginImageView = UIImageView(image: UIImage(named: "login_img"))
  var welcomelabel: UILabel = {
    let label = UILabel()
    label.text = "You need to be logged in to share\nan opportunity on the application."
    //label.font = UIFont.preferredFont(forTextStyle: .subheadline)
    label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    label.textColor = Constants.lightBlackLabel
    label.numberOfLines = 2
    label.textColor = .darkText
    return label
  }()
  var loginButton = UIButton(type: .system)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    self.view.endEditing(true)
    // Do any additional setup after loading the view.
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)

    self.extensionContext!.cancelRequest(withError:NSError())
  }
  
  private func configureUI(){
    view.backgroundColor = .white
    layoutPaletteLogo()
    layoutLoginImageView()
    layoutWelcomelabel()
    configureLoginButton()
  }
  
  private func layoutPaletteLogo(){
    view.addSubview(paletteLogoImageView)
    paletteLogoImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      paletteLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
      paletteLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      paletteLogoImageView.heightAnchor.constraint(equalToConstant: 80),
      paletteLogoImageView.widthAnchor.constraint(equalToConstant: 265)
    ])
  }
  
  private func layoutLoginImageView(){
    view.addSubview(loginImageView)
    loginImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loginImageView.topAnchor.constraint(equalTo: paletteLogoImageView.bottomAnchor, constant: 35),
      loginImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loginImageView.heightAnchor.constraint(equalToConstant: 285),
      loginImageView.widthAnchor.constraint(equalToConstant: 285)
    ])
  }
  
  private func layoutWelcomelabel(){
    view.addSubview(welcomelabel)
    welcomelabel.translatesAutoresizingMaskIntoConstraints = false
    welcomelabel.textColor = Constants.lightBlackLabel
    NSLayoutConstraint.activate([
      welcomelabel.topAnchor.constraint(equalTo: loginImageView.bottomAnchor, constant: 35),
      welcomelabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      welcomelabel.heightAnchor.constraint(equalToConstant: 45),
      welcomelabel.widthAnchor.constraint(equalToConstant: 295)
    ])
  }
  private func configureLoginButton(){
    view.addSubview(loginButton)
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loginButton.topAnchor.constraint(equalTo: welcomelabel.bottomAnchor, constant: 35),
      loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loginButton.heightAnchor.constraint(equalToConstant: 45),
      loginButton.widthAnchor.constraint(equalToConstant: 295)
    ])
    
    loginButton.setTitle("LOG IN", for: .normal)
    loginButton.backgroundColor = Constants.pureBlack
    loginButton.setTitleColor(.white, for: .normal)
    loginButton.layer.cornerRadius = 8
    loginButton.addTarget(self, action: #selector(pushToDetailVC), for: .touchUpInside)
  }
  
  @objc func pushToDetailVC() {
    //    let url = URL(string: "pendo-a23d0221://")!
    redirectToHostApp()
  }
  
  private func redirectToHostApp() {
    let sharedKey = "ShareKey"
    let type = "url"
    // ids may not loaded yet so we need loadIds here too
    let url = URL(string: "ShareMedia://dataUrl=\(sharedKey)#\(type)")
    var responder = self as UIResponder?
    let selectorOpenURL = sel_registerName("openURL:")
    
    while (responder != nil) {
      if (responder?.responds(to: selectorOpenURL))! {
        let _ = responder?.perform(selectorOpenURL, with: url)
      }
      responder = responder!.next
    }
    extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
