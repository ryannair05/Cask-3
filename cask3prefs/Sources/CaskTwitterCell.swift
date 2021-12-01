import Preferences

class CaskTwitterCell: PSTableCell {

    private var user: String!
    private(set) var avatarImageView: UIImageView!
    private var avatarImage: UIImage! {
        didSet {
            avatarImageView.image = avatarImage

            if avatarImageView.alpha == 0 {
                UIView.animate(
                    withDuration: 0.15,
                    animations: {
                        self.avatarImageView.alpha = 1
                    }
                )
            }
        }
    }

    convenience required init?(coder aDecoder: NSCoder) { 
        self.init(coder: aDecoder) 
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String, specifier: PSSpecifier) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        selectionStyle = UITableViewCell.SelectionStyle.blue
        accessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))

        detailTextLabel!.numberOfLines = 1
        detailTextLabel!.textColor = UIColor.gray

        textLabel!.textColor = UIColor.black
        
        tintColor = UIColor.label

        let size: CGFloat = 29.0

        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, UIScreen.main.scale)
        specifier.properties["iconImage"] = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let avatarView = UIView(frame: imageView!.bounds)
        avatarView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        avatarView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        avatarView.isUserInteractionEnabled = false
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = CGFloat(size / 2)
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.tertiaryLabel.cgColor

        imageView!.addSubview(avatarView)

        avatarImageView = UIImageView(frame: avatarView.bounds)
        avatarImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        avatarImageView.alpha = 0
        avatarImageView.layer.minificationFilter = .trilinear
        avatarView.addSubview(avatarImageView)

        if let user = specifier.properties["accountName"] as? String {
            self.user = user
        }
        else {
            fatalError("User name not provided")
        }
        
        specifier.properties["url"] = _url(forUsername: user)

        detailTextLabel!.text = user

        DispatchQueue.global(qos: .default).async(execute: {
            if let url = URL(string: "https://pbs.twimg.com/profile_images/1161080936836018176/4GUKuGlb_200x200.jpg") {
                let request = URLRequest(url: url) 
                    URLSession.shared.dataTask(with: request, completionHandler: { _data, _response, _error in
                    guard let data = _data, _error == nil else {
                        return
                    }

                    DispatchQueue.main.async(execute: {
                        self.avatarImage = UIImage(data: data)
                    })

                }).resume()
            }
        })
    }

    private func _url(forUsername user: String) -> URL {
        let urls = [
            "tweetbot://\(user)/user_profile/\(user)", // TweetBot
            "twitterrific://current/profile?screen_name=\(user)", // Twitterrific
            "tweetings://user?screen_name=\(user)", // Tweetings
            "fluttr://user/\(user)", // Fluttr
        ]

        for twitterURL in urls {
            if let url = URL(string: twitterURL), UIApplication.shared.canOpenURL(url) {
                return url
            }
        }

        return URL(string: "https://mobile.twitter.com/" + (user))!
    }

    override func setSelected(_ arg1: Bool, animated arg2: Bool) {
        if arg1 {
            UIApplication.shared.open(_url(forUsername: user), options: [:], completionHandler: nil)
        }
    }
}