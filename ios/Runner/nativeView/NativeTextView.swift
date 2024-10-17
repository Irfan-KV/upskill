//
//  NativeTextView.swift
//  Runner
//
//  Created by Irfan on 09/10/24.
//

import Flutter
import UIKit

class NativeTextView: NSObject, FlutterPlatformView {
    private var _view: UILabel

    init(
        frame: CGRect,
        viewId: Int64,
        args: Any?,
        messenger: FlutterBinaryMessenger?
    ) {
        _view = UILabel(frame: frame)
        super.init()
        if let args = args as? [String: Any],
           let text = args["text"] as? String {
            _view.text = text
            _view.font = UIFont.systemFont(ofSize: 20)
            _view.textAlignment = .center
        } else {
            _view.text = "Default Text"
            _view.font = UIFont.systemFont(ofSize: 20)
            _view.textAlignment = .center
        }
    }

    func view() -> UIView {
        return _view
    }
}
