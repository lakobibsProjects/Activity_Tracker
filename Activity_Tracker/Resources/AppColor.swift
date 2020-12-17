//
//  AppColor.swift
//  Activity_Tracker
//
//  Created by user166683 on 12/15/20.
//  Copyright © 2020 Lakobib. All rights reserved.
//

import Foundation
import UIKit

public enum AppColor{
    static public let buttonGray =  UIColor(red: 54/255, green: 63/255, blue: 69/255, alpha: 1)
    static public let buttonShadeBlack =  UIColor(red: 242/255, green: 242/255, blue: 244/255, alpha: 1)
    static public let higlightedTextYellow =  UIColor(red: 252/255, green: 186/255, blue: 47/255, alpha: 1)
    static public let white =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static public let white00 =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
    static public let secondaryTextLightyGray =  UIColor(red: 169/255, green: 167/255, blue: 167/255, alpha: 1)
    static public let secondaryTextDullGray =  UIColor(red: 97/255, green: 96/255, blue: 96/255, alpha: 1)
    static public let normalTextBlack =  UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
    static public let black =  UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static public let red =  UIColor(red: 255/255, green: 38/255, blue: 40/255, alpha: 1)
    static public let alertTextRed =  UIColor(red: 243/255, green: 20/255, blue: 49/255, alpha: 1)
    
    static public let tintMudYellow = UIColor(red: 250/255, green: 239/255, blue: 202/255, alpha: 1)
    static public let buttonYellow = UIColor(red: 245/255, green: 210/255, blue: 92/255, alpha: 1)
    
    public static let labelTextColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return white
                } else {
                    return black
                }
            }
        } else {
            return black
        }
    }()
    
    public static let labelBackgroundColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return black
                } else {
                    return white
                }
            }
        } else {
            return white
        }
    }()
    
    public static let textFieldTextColor: UIColor = {
           if #available(iOS 13, *) {
               return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                   if UITraitCollection.userInterfaceStyle == .dark {
                       return white
                   } else {
                       return black
                   }
               }
           } else {
               return black
           }
       }()
       
       public static let textFieldBackgroundColor: UIColor = {
           if #available(iOS 13, *) {
               return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                   if UITraitCollection.userInterfaceStyle == .dark {
                       return black
                   } else {
                       return white
                   }
               }
           } else {
               return white
           }
       }()
    
    public static let buttonsSecondaryTextColor: UIColor = {
           if #available(iOS 13, *) {
               return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                   if UITraitCollection.userInterfaceStyle == .dark {
                       return white
                   } else {
                       return black
                   }
               }
           } else {
               return black
           }
       }()
    
    public static let superviewBackgroundColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return black
                } else {
                    return white
                }
            }
        } else {
            return white
        }
    }()
    
    public static let bordersGeneralColor: UIColor = {
              if #available(iOS 13, *) {
                  return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                      if UITraitCollection.userInterfaceStyle == .dark {
                          return white
                      } else {
                          return black
                      }
                  }
              } else {
                  return black
              }
          }()
}
