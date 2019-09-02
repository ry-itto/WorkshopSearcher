//
//  EventCell.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/07.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import OpenGraph
import RxCocoa
import RxSwift
import SkeletonView
import UIKit

/// 勉強会検索サービスの列挙型
enum Service {
    case connpass
    case supporterz
    case doorkeeper

    var image: UIImage? {
        switch self {
        case .connpass:
            return UIImage(named: "connpass_logo")
        case .supporterz:
            return UIImage(named: "supporterzcolab_logo_2")
        case .doorkeeper:
            return nil
        }
    }
}

/// イベント情報セル
class EventCell: UITableViewCell {

    private let disposeBag = DisposeBag()
    static let rowHeight: CGFloat = 92.5

    class var cellIdentifier: String {
        return String(describing: type(of: self))
    }

    private var holdDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm"
        return formatter
    }

    @IBOutlet weak var serviceLogoImage: UIImageView! {
        didSet {
            serviceLogoImage.isSkeletonable = true
            serviceLogoImage.showAnimatedSkeleton()
        }
    }
    @IBOutlet weak var eventTitleLabel: UILabel! {
        didSet {
            eventTitleLabel.isSkeletonable = true
            eventTitleLabel.showAnimatedSkeleton()
        }
    }
    @IBOutlet weak var holdDateLabel: UILabel! {
        didSet {
            holdDateLabel.isSkeletonable = true
            holdDateLabel.showAnimatedSkeleton()
        }
    }
    @IBOutlet weak var participantView: UIView! {
        didSet {
            participantView.layer.cornerRadius = 10
            participantView.clipsToBounds = true
            participantView.layer.borderColor = UIColor.lightGray.cgColor
            participantView.layer.borderWidth = 0.4
            participantView.backgroundColor = .white
            participantView.isSkeletonable = true
            participantView.showAnimatedSkeleton()
        }
    }
    @IBOutlet weak var numOfParticipantLabel: UILabel! {
        didSet {
            numOfParticipantLabel.isSkeletonable = true
            numOfParticipantLabel.showAnimatedSkeleton()
        }
    }

    private let viewModel = EventCellViewModel()

    init() {
        super.init(style: .default, reuseIdentifier: EventCell.cellIdentifier)
        viewModel.ogpImageURL
            .bind(to: Binder(self) { cell, url in
                cell.serviceLogoImage.setImage(from: url)
                cell.serviceLogoImage.hideSkeleton()
            }).disposed(by: disposeBag)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewModel.ogpImageURL
            .bind(to: Binder(self) { cell, url in
                cell.serviceLogoImage.setImage(from: url)
                cell.serviceLogoImage.hideSkeleton()
            }).disposed(by: disposeBag)
    }

    /// スケルトンビューを表示する
    func showAllAnimatedSkeleton() {
        serviceLogoImage.showAnimatedSkeleton()
        eventTitleLabel.showAnimatedSkeleton()
        holdDateLabel.showAnimatedSkeleton()
        participantView.showAnimatedSkeleton()
        numOfParticipantLabel.showAnimatedSkeleton()
    }

    /// セルの値を設定する
    ///
    /// - Parameters:
    ///   - service: 勉強会検索サービス
    ///   - event: イベント内容
    func configure(service: Service, event: ConnpassResponse.Event) {
        eventTitleLabel.hideSkeleton()
        holdDateLabel.hideSkeleton()
        participantView.hideSkeleton()
        numOfParticipantLabel.hideSkeleton()

        eventTitleLabel.text = event.title
        holdDateLabel.text = "\(holdDateFormatter.string(from: event.startedAt)) ~ 開催"
        if let limit = event.limit {
            numOfParticipantLabel.text = "\(event.accepted)/\(limit)"
        } else {
            numOfParticipantLabel.text = "\(event.accepted)"
        }

        viewModel.fetchOGPImage.accept(event.eventURL)
    }

    func configure(likeEvent: LikeEvent) {
        serviceLogoImage.hideSkeleton()
        eventTitleLabel.hideSkeleton()
        holdDateLabel.hideSkeleton()
        participantView.hideSkeleton()
        numOfParticipantLabel.hideSkeleton()

        eventTitleLabel.text = likeEvent.title
        holdDateLabel.text = "\(holdDateFormatter.string(from: likeEvent.startedAt)) ~ 開催"
        if likeEvent.limit != 0 {
            numOfParticipantLabel.text = "\(likeEvent.present)/\(likeEvent.limit)"
        } else {
            numOfParticipantLabel.text = "\(likeEvent.present)"
        }

        guard let eventURL = URL(string: likeEvent.urlString) else {
            return
        }

        viewModel.fetchOGPImage.accept(eventURL)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.serviceLogoImage.image = Service.connpass.image
    }
}
