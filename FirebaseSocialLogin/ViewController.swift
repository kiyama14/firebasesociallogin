//
//  ViewController.swift
//  FirebaseSocialLogin
//
//  Created by Mauricio Takashi Kiyama on 2/6/18.
//  Copyright © 2018 a+. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFacebookButtons()
        setupGoogleButtons()
        
    }
    
    fileprivate func setupGoogleButtons() {
        
        //add google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 182, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        //add custom google buton
        let customGButton = UIButton()
        customGButton.frame = CGRect(x: 16, y: 248, width: view.frame.width - 32, height: 50)
        customGButton.backgroundColor = .orange
        customGButton.setTitle("Custom Google Login here", for: .normal)
        customGButton.addTarget(self, action: #selector(handleCustomGoogleLogin), for: .touchUpInside)
        customGButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(customGButton)
        
        //add custom google buton
        let customGOutButton = UIButton()
        customGOutButton.frame = CGRect(x: 16, y: 314, width: view.frame.width - 32, height: 50)
        customGOutButton.backgroundColor = .orange
        customGOutButton.setTitle("Custom Google Log out", for: .normal)
        customGOutButton.addTarget(self, action: #selector(handleCustomGoogleLogOut), for: .touchUpInside)
        customGOutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(customGOutButton)
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @objc func handleCustomGoogleLogin() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func handleCustomGoogleLogOut() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    fileprivate func setupFacebookButtons() {
        
        let loginButton = FBSDKLoginButton()
        
        
        view.addSubview(loginButton)
        
        
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        
        //custom FB button
        let customFBButton = UIButton()
        
        view.addSubview(customFBButton)
        
        customFBButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        customFBButton.backgroundColor = .blue
        customFBButton.setTitle("Custom FB Login here", for: .normal)
        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        
    }
    
    @objc func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:", err!)
                return
            }
        
            self.showEmailAddress()
            }
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }

        showEmailAddress()
    }

    func showEmailAddress() {
        
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wront with our FB user: ", error ?? "")
                return
            }
            
            print("Successfully logged in with our user: ", user ?? "")
            
        })
        
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err!)
                return
            }
            
            print(result!)
        }

    }
}

