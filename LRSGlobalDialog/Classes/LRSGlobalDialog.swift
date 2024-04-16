//
//  LRSGlobalDialog.swift
//  LRSGlobalDialog
//
//  Created by sama 刘 on 2024/1/29.
//

import UIKit
import ReactiveObjC

@objc
public class LRSGlobalDialog: NSObject {
	@objc public static let `default` = LRSGlobalDialog()
	private var presentedAlert: Set = Set<Int>()
	private typealias AlertView = UIAlertView
	public typealias AlertClickedCallBack = (Int) -> Void

	@objc public func showAlertView(title: String? = "", code: Int, message: String? = "", confirmButtonTitle: String? = "知道了", cancelButtonTitle: String? = "取消", onButtonClicked: AlertClickedCallBack? = { _ in }) {
		guard presentedAlert.contains(code) == false else {
			return
		}
		var alertView: AlertView!
		if let confirmButtonTitle = confirmButtonTitle {
			alertView = AlertView(title: title ?? "", message: message ?? "", delegate: nil, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: confirmButtonTitle)
		} else {
			alertView = AlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle)
		}
		alertView.show()
		alertView.rac_buttonClickedSignal().subscribeNext { (index) in
			self.presentedAlert.remove(code)
			guard let callBack = onButtonClicked, let index = index as? Int else {
				return
			}
			callBack(index)
		}
		self.presentedAlert.insert(code)
	}

	@objc public static func showAlertView(title: String?, code: Int, message: String?, confirmButtonTitle: String? = "知道了") {
		LRSGlobalDialog.default.showAlertView(title: title, code: code, message: message, confirmButtonTitle: confirmButtonTitle)
	}

	@objc public static func debugDialog(title: String?, code: Int, message: String?, confirmButtonTitle: String? = "知道了") {
		#if targetEnvironment(simulator) || DEBUG
		LRSGlobalDialog.default.showAlertView(title: title, code: code, message: message, confirmButtonTitle: confirmButtonTitle)
		#endif
	}

}
