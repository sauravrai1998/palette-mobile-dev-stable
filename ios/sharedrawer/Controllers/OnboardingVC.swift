//
//  OnboardingVC.swift
//  ShareDrawerUI
//
//  Created by Jagdeep Singh on 17/11/21.
//

import UIKit

@available(iOSApplicationExtension 13.0, *)
class OnboardingVC: UIViewController {
  
    var sharedURL: String = ""
    var isObserver: Bool = false
    var isStudent: Bool = false
    var defaults = UserDefaults.init(suiteName: Constants.groupName)!
    
    let toDoContainer = OnboardingContainer(onboardingType: .Todo)
    let chatContainer = OnboardingContainer(onboardingType: .Chat)
    let opportunityContainer = OnboardingContainer(onboardingType: .Opportunity)
    
    var shareLabel: UILabel = {
      let label = UILabel()
      label.text = "Share"
      label.textColor = .black
      label.font = UIFont.preferredFont(forTextStyle: .title2)
      label.font = UIFont.systemFont(ofSize: 24,weight: .bold)
      return label
      }()
    
    let paletteBGImageView = UIImageView(image: UIImage(named: "palette_bg"))
    
  
//  init(sharedUrl :String) {
//    super.init(coder: NSCoder.self)
//    
//  }
//  
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
      
        let role = defaults.string(forKey: "role")
          if role?.lowercased() == "student"{
              isStudent = true
          } else if role?.lowercased() == "observer"{
              isObserver = true
          }
        
        // Do any additional setup after loading the view.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupSubviews()
    self.view.endEditing(true)
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)

    self.extensionContext!.cancelRequest(withError:NSError())
  }
  
    
    func setupSubviews(){
        layoutPaletteBGImageView()
        layoutSharelabel()
      if isObserver {
        layoutChatContainerForOberver()
      }
      else {
        layoutOpportunityContainer()
        layoutTodoContainer()
        layoutChatContainer()
      }
        
    }
  
  private func layoutPaletteBGImageView(){
    view.addSubview(paletteBGImageView)
    paletteBGImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      paletteBGImageView.topAnchor.constraint(equalTo: view.topAnchor),
      paletteBGImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      paletteBGImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40),
      paletteBGImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55)
    ])
  }
  
  private func layoutSharelabel(){
    view.addSubview(shareLabel)
    shareLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        shareLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
        shareLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        shareLabel.heightAnchor.constraint(equalToConstant: 45),
        shareLabel.widthAnchor.constraint(equalToConstant: 70)
    ])
  }
  
  private func layoutOpportunityContainer(){
      view.addSubview(opportunityContainer)
      opportunityContainer.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
          opportunityContainer.topAnchor.constraint(equalTo: shareLabel.bottomAnchor, constant: 35),
          opportunityContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
          opportunityContainer.heightAnchor.constraint(equalToConstant: 145),
          opportunityContainer.widthAnchor.constraint(equalToConstant: 344)
      ])
      let tap = UITapGestureRecognizer(target: self, action: #selector(routeOpportunityPage))
      opportunityContainer.addGestureRecognizer(tap)
      opportunityContainer.isStudent = isStudent
  }
    
    private func layoutTodoContainer(){
        view.addSubview(toDoContainer)
        toDoContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toDoContainer.topAnchor.constraint(equalTo: opportunityContainer.bottomAnchor, constant: 32),
            toDoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            toDoContainer.heightAnchor.constraint(equalToConstant: 145),
            toDoContainer.widthAnchor.constraint(equalToConstant: 344)
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(routeTodoPage))
        toDoContainer.addGestureRecognizer(tap)
        toDoContainer.isStudent = isStudent
    }
    
    private func layoutChatContainer(){
        view.addSubview(chatContainer)
        chatContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chatContainer.topAnchor.constraint(equalTo: toDoContainer.bottomAnchor, constant: 32),
            chatContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            chatContainer.heightAnchor.constraint(equalToConstant: 145),
            chatContainer.widthAnchor.constraint(equalToConstant: 344)
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(routeChatPage))
        chatContainer.addGestureRecognizer(tap)
        chatContainer.isStudent = isStudent
    }
    
  
  private func layoutChatContainerForOberver(){
      view.addSubview(chatContainer)
      chatContainer.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
          chatContainer.topAnchor.constraint(equalTo: shareLabel.topAnchor, constant: 32),
          chatContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
          chatContainer.heightAnchor.constraint(equalToConstant: 145),
          chatContainer.widthAnchor.constraint(equalToConstant: 344)
      ])
      let tap = UITapGestureRecognizer(target: self, action: #selector(routeChatPage))
      chatContainer.addGestureRecognizer(tap)
  }
   

    
    // MARK: - Navigation
    @objc func routeTodoPage(){
      print("something something")
      defaults.set("todo", forKey: Constants.shareDrawerNavigateKey)
      redirectToHostApp()
      //  navigationController?.pushViewController(CreateTodoVC(),animated: true)
    }
    @objc func routeChatPage(){
      defaults.set("chat", forKey: Constants.shareDrawerNavigateKey)
      redirectToHostApp()
       // navigationController?.pushViewController(SendChatVC(),animated: true)
    }
    @objc func routeOpportunityPage(){
      defaults.set("opportunity", forKey: Constants.shareDrawerNavigateKey)
      redirectToHostApp()
      //  navigationController?.pushViewController(CreateOppGuardianVC(), animated: true)

    }
     /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  private func redirectToHostApp() {
    let sharedKey = "ShareKey"
    let type = "text"
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

}
