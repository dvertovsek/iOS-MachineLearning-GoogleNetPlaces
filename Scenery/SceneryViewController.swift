import UIKit
import Recognizer

class SceneryViewController: UIViewController {

    var recognizer: Recognizer?

    lazy var collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self

        return view
    }()

    lazy var imageView = UIImageView()

    var results = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(SuggestionCell.self,
                                forCellWithReuseIdentifier: SuggestionCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        view.backgroundColor = UIColor.white

        recognizer = Recognizer(modelFile: GoogLeNetPlaces().model)
        recognizer?.delegate = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTouchUpInsideAddBarButtonItem))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)
        view.insertSubview(imageView, belowSubview: collectionView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height/2),

            collectionView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            collectionView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 10)
            ])
    }

    @objc func didTouchUpInsideAddBarButtonItem() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.modalPresentationStyle = .overCurrentContext

        present(imagePicker, animated: true, completion: nil)
    }
}

extension SceneryViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionCell.reuseIdentifier, for: indexPath)
        let result = results[indexPath.row]
        (cell as? SuggestionCell)?.configure(with: result)

        return cell
    }

}

extension SceneryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nsString = results[indexPath.row] as NSString
        let calculatedWidth = nsString.size(withAttributes: Theme.Attributes.suggestionText).width

        return CGSize(width: calculatedWidth + 70, height: 30)
    }
}

extension SceneryViewController: RecognizerDelegate {
    func recognizer(_ recognizer: Recognizer, didFinishRequestWith identifiers: [String]) {
        results = identifiers.map { $0.replacingOccurrences(of: "_", with: " ") }
        collectionView.reloadData()
    }
}

extension SceneryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = pickedImage
        }

        if let url = info[UIImagePickerControllerImageURL] as? URL {
            recognizer?.performRequest(with: url, resultsCount: 5)
        } else if let url = info[UIImagePickerControllerMediaURL] as? URL {
            recognizer?.performRequest(with: url, resultsCount: 5)
        }

        picker.dismiss(animated: true, completion: nil)
    }
}
