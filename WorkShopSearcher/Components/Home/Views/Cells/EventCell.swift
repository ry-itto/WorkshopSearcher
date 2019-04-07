//
//  EventCell.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/07.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    static let rowHeight: CGFloat = 92.5
    static let cellIdentifier = String(describing: type(of: self))
    
    @IBOutlet weak var serviceLogoImage: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var holdDateLabel: UILabel!
    @IBOutlet weak var participantView: UIView!
    @IBOutlet weak var numOfParticipantLabel: UILabel!
    
    func configure(event: ConnpassResponse.Event) {
        eventTitleLabel.text = event.title
        holdDateLabel.text = "\(event.startedAt)"
        numOfParticipantLabel.text = "\(event.accepted)/\(event.waiting)"
    }
}
