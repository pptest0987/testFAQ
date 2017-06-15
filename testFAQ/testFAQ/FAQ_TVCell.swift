//
//  FourthTVCell.swift
//  Hooz App
//
//  Created by Parkhya Solutions on 10/27/16.
//  Copyright © 2016 iOS. All rights reserved.
//

import UIKit

class FAQ_TVCell: UITableViewCell {
    
    @IBOutlet var viewContainer: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var buttonIcon: UIButton!
    @IBOutlet weak var imageIcon: UIImageView!
    var WithDetails: Bool!
    
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet var detailContainerViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.layer.shadowColor = UIColor.lightGray.cgColor
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewContainer.layer.shadowOpacity = 1.5
        viewContainer.layer.shadowRadius = 1.5
        
                
        WithDetails = false
        backgroundView = nil
        detailContainerViewHeightConstraint.constant = 0
        
        
    }
    func setWithDetails(_ withDetails: Bool) {
        self.WithDetails = withDetails
        if withDetails {
            detailContainerViewHeightConstraint.priority = 250
        }
        else {
            detailContainerViewHeightConstraint.priority = 999
        }
    }
    func animateOpen() {
        let originalBackgroundColor: UIColor? = contentView.backgroundColor
        contentView.backgroundColor = UIColor.clear
        detailContainerView.foldOpen(withTransparency: true, withCompletionBlock: {() -> Void in
            // _buttonIcon.imageView.image = [UIImage imageNamed:@"expandGlyphUp"];
            self.contentView.backgroundColor = originalBackgroundColor
            self.imageIcon.image = UIImage(named: "inus.png")
        })
    }
    
    func animateClosed() {
        let originalBackgroundColor: UIColor? = contentView.backgroundColor
        contentView.backgroundColor = UIColor.clear
        detailContainerView.foldClosed(withTransparency: true, withCompletionBlock: {() -> Void in
            //_buttonIcon.imageView.image = [UIImage imageNamed:@"expandGlyph"];
            self.contentView.backgroundColor = originalBackgroundColor
            self.imageIcon.image = UIImage(named: "plusGreen.png")
        })
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
