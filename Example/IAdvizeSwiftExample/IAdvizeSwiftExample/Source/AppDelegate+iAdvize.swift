//
//  AppDelegate+iAdvize.swift
//  IAdvizeSwiftExample
//
//  Created by Alexandre Karst on 19/09/2018.
//  Copyright © 2018 iAdvize. All rights reserved.
//

import Foundation
import IAdvizeConversationSDK

extension AppDelegate {
    func iAdvizeSetup() {
        // Choose the log level of the SDK from `.verbose` to `.success`.
        IAdvizeManager.shared.logLevel = .verbose

        customiseIAdvizeUI()

        // Register your application ID.
        // This information is available on your app on the iAdvize Administration website.
        IAdvizeManager.shared.registerApplicationId(iAdvizeApplicationID)

        // Switch to false to test without GDPR.
        let shouldActivateGDPR = true

        if shouldActivateGDPR {
            iAdvizeActivateWithGDPR()
        } else {
            iAdvizeActivate()
        }

        // Register user information which will be displayed to your operators or ibbü experts.
        IAdvizeManager.shared.registerUser(User(name: "Alexandra"))
    }

    func customiseIAdvizeUI() {
        var configuration = ConversationViewConfiguration()

        let mainColor = UIColor(red: 0.96, green: 0.49, blue: 0.38, alpha: 1.0)

        configuration.mainColor = mainColor
        configuration.navigationBarBackgroundColor = mainColor
        configuration.navigationBarMainColor = .white
        configuration.navigationBarTitle = NSLocalizedString("Say Hello 👋", comment: "")
        configuration.font = UIFont(name: "HelveticaNeue", size: 11.0)!
        configuration.automaticMessage = NSLocalizedString("Any question? Say Hello to Smart and we will answer you as soon as possible! 😊", comment: "")
        configuration.gdprMessage = NSLocalizedString("As part of the GDPR, we have to ask you to consent to our legal information.", comment: "")

        IAdvizeConversationManager.shared.setupConversationView(configuration: configuration)


        IAdvizeConversationManager.shared.setChatButtonPosition(leftMargin: 15.0, bottomMargin: 15.0)
    }

    func iAdvizeActivate() {
        // Replace "ConnectedUserIdentifier" by your user unique identifier (it should not be
        // a personal information of your user) so they can retrieve their conversation history
        // accross installations and devices.
        //
        // Your `iAdvizeSecret` is available on your app on the iAdvize Administration website.
        // TODO: replace YOURTARGETINGRULEUUID by your own rule.
        IAdvizeManager.shared.activate(jwtOption: .secret(iAdvizeSecret), externalId: "ConnectedUserIdentifier", ruleId: UUID(uuidString: "YOURTARGETINGRULEUUID")!) { success in
            guard success else {
                // Activation fails. You need to retry later to be able to properly activate the iAdvize Conversation SDK.
                return
            }

            // Activation succeeds. You are now able to provide a chat experience to your users now
            // or later by showing the chat button.
            IAdvizeConversationManager.shared.showChatButton()
        }
    }

    func iAdvizeActivateWithGDPR() {
        // To activate GDPR, you have to provide a legal information URL.
        if let legalInfoURL = URL(string: "http://yourlegalinformationurl.com/legal") {
            // TODO: replace YOURTARGETINGRULEUUID by your own rule.
            IAdvizeManager.shared.activate(jwtOption: .secret(iAdvizeSecret), externalId: "ConnectedUserIdentifier", gdprOption: .enabled(legalInformationURL: legalInfoURL), ruleId: UUID(uuidString: "YOURTARGETINGRULEUUID")!) { success in
                guard success else {
                    // Activation fails. You need to retry later to be able to properly activate the iAdvize Conversation SDK.
                    return
                }

                // Activation succeeds. You are now able to provide a chat experience to your users now
                // or later by showing the chat button.
                IAdvizeConversationManager.shared.showChatButton()
            }
        }
    }
}
