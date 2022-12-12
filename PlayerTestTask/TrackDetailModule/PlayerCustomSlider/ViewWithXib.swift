//
//  ViewWithXib.swift
//  PlayerTestTask
//
//  Created by Admin on 08.12.2022.
//

import UIKit

class ViewWithXib: UIView {

	func initUI() {}
	
	private func setup() {
		let view = loadViewFromNib()
		view.frame = bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(view)
		initUI()
	}
	
	private func loadViewFromNib() -> UIView {
		let thisName = String(describing: type(of: self))
        if let view = Bundle(for: self.classForCoder)
            .loadNibNamed(thisName, owner: self, options: nil)?.first as? UIView {
            return view
        }
        return UIView()
	}
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

}
