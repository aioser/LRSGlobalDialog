//
//  LRSGlobalDialog.swift
//  LRSGlobalDialog
//
//  Created by sama 刘 on 2024/1/29.
//

import UIKit
import ReactiveObjC

@objc class LRSGlobalDialog: NSObject {
	@objc static let `default` = LRSGlobalDialog()
	private var presentedAlert: Set = Set<Int>()
	@objc func showAlertView(title: String?, code: Int, message: String?, confirmButtonTitle: String? = "知道了") {
		guard presentedAlert.contains(code) == false else {
			return
		}
		let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: confirmButtonTitle)
		alert.show()
		alert.rac_buttonClickedSignal().subscribeNext { (index) in
			self.presentedAlert.remove(code)
		}
		self.presentedAlert.insert(code)
	}

	@objc static func showAlertView(title: String?, code: Int, message: String?, confirmButtonTitle: String? = "知道了") {
		LRSGlobalDialog.default.showAlertView(title: title, code: code, message: message, confirmButtonTitle: confirmButtonTitle)
	}
}
