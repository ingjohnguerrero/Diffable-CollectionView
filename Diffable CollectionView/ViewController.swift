//
//  ViewController.swift
//  Diffable CollectionView
//
//  Created by John Edwin Guerrero Ayala on 5/7/24.
//

import UIKit
import SnapKit
import Fakery

class ViewController: UIViewController {
    // Define the collection view and the diffable data source
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    // Fakery instance to generate fake data
    private let faker = Faker()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureDataSource()
        applyInitialSnapshots()
    }

    private func setupCollectionView() {
        // Initialize the collection view with a flow layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100) // Set the item size
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 50) // Set header size
        collectionView.backgroundColor = .white

        // Add the collection view to the view hierarchy
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Register cell class
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }

    private func configureDataSource() {
        // Define the data source for cells
                dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
                    (collectionView, indexPath, item) -> UICollectionViewCell? in
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                    cell.backgroundColor = .blue
                    return cell
                }

                // Configure data source for supplementary views (headers)
                dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
                    guard let self = self, kind == UICollectionView.elementKindSectionHeader else {
                        return nil
                    }
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
                    header.backgroundColor = .lightGray
                    return header
                }
    }

    private func applyInitialSnapshots() {
        // Generate fake data
        var items = [Item]()
        for _ in 0..<20 {
            let item = Item(id: faker.internet.username(), value: faker.lorem.sentence())
            items.append(item)
        }

        // Create a snapshot and apply it to the data source
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    // Enum to define sections
    enum Section {
        case main
    }

    // Struct to define item model
    struct Item: Hashable {
        let id: String
        let value: String
        let identifier = UUID()

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }
}


