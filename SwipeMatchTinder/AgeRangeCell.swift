//
//  AgeRangeCell.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 27/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

final class AgeRangeCell: UITableViewCell {

    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        slider.minimumTrackTintColor = #colorLiteral(red: 0.9692050815, green: 0.3088847697, blue: 0.6212263703, alpha: 1)
        return slider
    }()

    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        slider.minimumTrackTintColor = #colorLiteral(red: 0.9692050815, green: 0.3088847697, blue: 0.6212263703, alpha: 1)
        return slider
    }()
    
    let minLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Min 88"
        return label
    }()

    let maxLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Max 88"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let overallStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel, minSlider]),
            UIStackView(arrangedSubviews: [maxLabel, maxSlider]),
            ])
        overallStackView.axis = .vertical
        
        addSubview(overallStackView)
        let padding: CGFloat = 16
        overallStackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: padding, left: padding, bottom: padding, right: padding)
        )
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
