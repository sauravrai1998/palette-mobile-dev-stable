//
//  OnboardingContainer.swift
//  ShareDrawerUI
//
//  Created by Jagdeep Singh on 17/11/21.
//

import UIKit

@available(iOSApplicationExtension 13.0, *)
class OnboardingContainer: UIView {
    
    var imgName: String = ""
    var ontitle: String = ""
    var ondescription: String = ""
    var iconColor = UIColor(red: 0.424, green: 0.404, blue: 0.949, alpha: 1)
    var onshadowColor = UIColor(red: 0.424, green: 0.404, blue: 0.949, alpha: 0.08).cgColor
    var isStudent: Bool = false
    
    let bgView = UIView()
    let IconbgView = UIView()
    let iconImgView = UIImageView()
    let titleLabel = UILabel()
    let descripationLabel = UILabel()
    let rightArrowIcon = UIImageView(image: UIImage(systemName: "arrow.right.circle"))
  
  var defaults = UserDefaults.init(suiteName: Constants.groupName)!

  
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(onboardingType: Constants.OnboardingType) {
        super.init(frame: .zero)
        configureOnboarding(onboardingType: onboardingType)
        setupView()
    let role = defaults.string(forKey: "role")
        if role?.lowercased() == "student"{
            isStudent = true
        }
    }
    private func setupView(){
        backgroundColor = .white
        setupBGView()
        setupIconbgView()
        setupIconImgView()
        setupTitleLabel()
        setupDescLabel()
        setupRightArrowIcon()
        
    }
    private func configureOnboarding(onboardingType: Constants.OnboardingType){
        switch onboardingType {
        case .Todo:
            imgName = "todo_icon"
            ontitle = "To-do"
            ondescription = isStudent
                          ? "Create a To-Do for yourself, for those in your network."
                          :"Create a to-do for your students."
            iconColor = UIColor(red: 0.424, green: 0.404, blue: 0.949, alpha: 1)
            onshadowColor = UIColor(red: 0.424, green: 0.404, blue: 0.949, alpha: 0.08).cgColor
        break
        case .Opportunity:
            imgName = "opportunity_icon"
            ontitle = "Opportunity"
          ondescription = isStudent
                        ? "Create an opportunity for yourself, for those in your network or your program."
                        :"Create an opportunity for your students or program."
            iconColor = UIColor(red: 0.714, green: 0.161, blue: 0.192, alpha: 1)
            onshadowColor = UIColor(red: 0.714, green: 0.161, blue: 0.192, alpha: 0.08).cgColor
        break
        case .Chat:
            imgName = "chat_icon"
            ontitle = "Chat"
            ondescription = isStudent
                          ? "Chat with people in your network."
                          :"Chat with your students and those in their networks."
            iconColor = UIColor(red: 0.267, green: 0.631, blue: 0.231, alpha: 1)
            onshadowColor = UIColor(red: 0.267, green: 0.631, blue: 0.231, alpha: 0.08).cgColor
        break
        }
    }
    //BGVIEW
    private func setupBGView(){
        addSubview(bgView)
        bgView.frame = CGRect(x: 0, y: 0, width: 344, height: 145)
        let shadows = UIView()
        shadows.frame = bgView.frame
        shadows.clipsToBounds = false
        bgView.addSubview(shadows)
        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 30)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = onshadowColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 10
        layer0.shadowOffset = CGSize(width: -10, height: 14)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)
        let shapes = UIView()
        shapes.frame = bgView.frame
        shapes.clipsToBounds = true
        bgView.addSubview(shapes)
        
        let layer1 = CALayer()
        layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer1.bounds = shapes.bounds
        layer1.position = shapes.center
        shapes.layer.addSublayer(layer1)
        shapes.layer.cornerRadius = 30
    }
    
    
    private func setupIconbgView(){
        IconbgView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        IconbgView.backgroundColor = .white
        IconbgView.addShadow()
        IconbgView.layer.cornerRadius = 16

        bgView.addSubview(IconbgView)
        IconbgView.translatesAutoresizingMaskIntoConstraints = false
        IconbgView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        IconbgView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        IconbgView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 10).isActive = true
        IconbgView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 20).isActive = true


    }
    
    private func setupIconImgView(){
        IconbgView.addSubview(iconImgView)
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImgView.heightAnchor.constraint(equalToConstant: 20),
            iconImgView.widthAnchor.constraint(equalToConstant: 20),
            iconImgView.centerXAnchor.constraint(equalTo: IconbgView.centerXAnchor),
            iconImgView.centerYAnchor.constraint(equalTo: IconbgView.centerYAnchor)
        ])
        iconImgView.image = UIImage(named: imgName)
        iconImgView.contentMode = .scaleAspectFit
    }
    
    private func setupTitleLabel() {
        let titleWidth = ontitle.count * 10
        bgView.addSubview(titleLabel)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: IconbgView.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.widthAnchor.constraint(equalToConstant: CGFloat(titleWidth))
        ])
        titleLabel.text = ontitle
        //titleLabel.font = UIFont(name: "Roboto-Bold", size: 24)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private func setupDescLabel(){
        bgView.addSubview(descripationLabel)
        descripationLabel.textColor = .black
        descripationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descripationLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 24),
            descripationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descripationLabel.heightAnchor.constraint(equalToConstant: 45),
            descripationLabel.widthAnchor.constraint(equalToConstant: 294)
        ])
        descripationLabel.text = ondescription
        //titleLabel.font = UIFont(name: "Roboto-Bold", size: 24)
        descripationLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        descripationLabel.numberOfLines = 0
        descripationLabel.lineBreakMode = .byWordWrapping
    }
    private func setupRightArrowIcon(){
        bgView.addSubview(rightArrowIcon)
        rightArrowIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightArrowIcon.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -20),
            rightArrowIcon.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -20),
            rightArrowIcon.heightAnchor.constraint(equalToConstant: 24),
            rightArrowIcon.widthAnchor.constraint(equalToConstant: 24)
        ])
        rightArrowIcon.tintColor = iconColor
    }
}
