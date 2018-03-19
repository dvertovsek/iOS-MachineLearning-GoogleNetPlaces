import UIKit

class SuggestionCell: UICollectionViewCell {

    static let reuseIdentifier = "_suggestionCell"

    private lazy var labelView = UILabel()
    private lazy var bgImageView = UIImageView(image: #imageLiteral(resourceName: "turquoise-clipart-banner"))

    func configure(with text: String) {
        labelView.attributedText = NSAttributedString(string: text, attributes: Theme.Attributes.suggestionText)

        if
            labelView.superview == .none,
            bgImageView.superview == .none
        {
            labelView.translatesAutoresizingMaskIntoConstraints = false
            bgImageView.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(bgImageView)
            contentView.insertSubview(labelView, aboveSubview: bgImageView)

            NSLayoutConstraint.activate([
                bgImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                bgImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                bgImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                bgImageView.topAnchor.constraint(equalTo: contentView.topAnchor),

                labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
                labelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                labelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
                labelView.topAnchor.constraint(equalTo: contentView.topAnchor)
                ])
        }
    }

}
