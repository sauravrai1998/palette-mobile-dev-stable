//
//  ShareViewController.swift
//  sharedrawer
//
//  Created by Jagdeep Singh on 18/01/22.
//

import UIKit
import Social
import MobileCoreServices

@objc(ShareExtensionViewController)
class ShareViewController: UIViewController {
  
  let urlContentType = kUTTypeURL as String
  var sharedText: [String] = []
  let accessTokkenKey = "accessToken"
  let sharedKey = "ShareKey"
  
  var urlString: String = ""
  
  

  
  var defaults = UserDefaults.init(suiteName: Constants.groupName)!
  
  override func viewDidLoad() {
    if #available(iOSApplicationExtension 13.0, *) {
      // TODO hack to disable cursor
              
      
      let accessTokken: String? = defaults.string(forKey: accessTokkenKey)
      let isLoggedIn: Bool = !(accessTokken?.isEmpty ?? true)
    
      if isLoggedIn {
        navigationController?.present(OnboardingVC(), animated: true)
      } else {
        navigationController?.present(PreLoginVC(), animated: true)
      }
//      let navController = UINavigationController(rootViewController: OnboardingVC())
//      self.present(navController, animated: true)
      
    } else {
      // Fallback on earlier versions
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    self.view.endEditing(true)
//    textView.isUserInteractionEnabled = false
//    textView.textColor = UIColor(white: 0.5, alpha: 1)
//    textView.tintColor = UIColor.clear
//    textView.endEditing(true)
//    self.view.endEditing(true)
//    textView.isHidden = true
//    textView.resignFirstResponder()
    
    if let extensionItem = extensionContext?.inputItems[0] as? NSExtensionItem {
    let contentTypeURL = kUTTypeURL as String
    
    for attachment in extensionItem.attachments! {
          if attachment.hasItemConformingToTypeIdentifier(contentTypeURL) {
            attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil, completionHandler: { (results, error) in
              let url = results as! URL?
              self.urlString = url!.absoluteString
              self.defaults.set(self.urlString, forKey: Constants.sharedURLString)
            })
          }
        }
      }
  }
  
  
  private func handleUrl (content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
         attachment.loadItem(forTypeIdentifier: urlContentType, options: nil) { [weak self] data, error in

             if error == nil, let item = data as? URL, let this = self {

                 this.sharedText.append(item.absoluteString)

                 // If this is the last item, save imagesData in userDefaults and redirect to host app
                 if index == (content.attachments?.count)! - 1 {
                   self?.defaults.set(this.sharedText, forKey: this.sharedKey)
                   self?.defaults.synchronize()
                     //this.redirectToHostApp()
                 }

             } else {
                // self?.dismissWithError()
             }
         }
     }
  
  
  

//    override func isContentValid() -> Bool {
//        // Do validation of contentText and/or NSExtensionContext attachments here
//        return true
//    }
//
//    override func didSelectPost() {
//        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
//
//        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
//    }
//
//    override func configurationItems() -> [Any]! {
//        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
//        return []
//    }

}
