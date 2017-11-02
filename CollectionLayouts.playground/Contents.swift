//: Playground - noun: a place where people can play

import UIKit

let gutter: CGFloat = 8

class CollectionLayoutTemplate: Codable {
    let slices: [Slice]

    init(slices: [Slice]) {
        self.slices = slices
    }

    func allCards() -> [Card] {
        return columns().flatMap { $0.cards }
    }

    func columns() -> [SliceColumn] {
        return slices.flatMap { $0.columns }
    }

    var count: Int {
        return slices.reduce(0) { $0 + $1.count }
    }

    func spanForCardAtIndex(index: Int) -> Int {
        var cardCount = 0
        for column in columns() {
            cardCount += column.cards.count
            if (index < cardCount) {
                return column.span
            }
        }
        fatalError()
    }

    func setSize(_ size: CGSize, index: Int) {
        var cardCount = 0;
        for column in columns() {
            for card in column.cards {
                if cardCount == index {
                    card.size = size
                    return
                }
                cardCount += 1
            }
        }
    }

    var height: CGFloat {
        slices.forEach { $0.performLayout() }
        return slices.reduce(0) { $0 + $1.height } + CGFloat(slices.count - 1) * gutter
    }
}

class Slice: Codable {
    let columns: [SliceColumn]

    init(columns: [SliceColumn]) {
        self.columns = columns
    }

    var count: Int {
        return columns.reduce(0) { $0 + $1.cards.count }
    }

    var height: CGFloat {
        return columns.first?.height ?? 0
    }

    func performLayout() {
        var current = 0
        while current + 1 < columns.count {
            // if a column has several cards, make sure cards next to each other have the same height
            // TODO: do not do that for columns that have cards of different style
            if columns[current].cards.count > 1 && columns[current].cards.count == columns[current + 1].cards.count {
                for i in 0..<columns[current].cards.count {
                    let maxHeight = max(columns[current].cards[i].size.height, columns[current + 1].cards[i].size.height)
                    columns[current].cards[i].size.height = maxHeight
                    columns[current + 1].cards[i].size.height = maxHeight
                }
            }
            current += 1
        }

        let maxHeight = columns.reduce(0) { max($0, $1.height) }

        // increase the size of the bottom card
        columns.forEach {
            if $0.height < maxHeight {
                $0.cards.last?.size.height += maxHeight - $0.height
            }
        }
    }
}

class SliceColumn: Codable {
    let offset: Int
    let span: Int
    let cards: [Card]

    init(offset: Int, span: Int, cards: [Card]) {
        self.offset = offset
        self.span = span
        self.cards = cards
    }

    var height: CGFloat {
        return cards.reduce(0) { $0 + $1.size.height } + CGFloat(cards.count - 1) * gutter
    }
}

class Card: Codable {
    init(style: CardStyle) {
        self.style = style
    }
    var size: CGSize = .zero {
        didSet {
            size.height = max(size.height, style.minHeight)
        }
    }
    let style: CardStyle
}

enum CardStyle: String, Codable {
    case compact
    case regular
    case mpu

    var minHeight: CGFloat {
        switch self {
        case .compact: return 100
        case .regular: return 200
        case .mpu: return 400
        }
    }
}

var layouts: [String: CollectionLayoutTemplate] = [:]

let regularSlice = Slice(columns: [
    SliceColumn(offset: 0, span: 6, cards: [Card(style: .regular)]),
    SliceColumn(offset: 6, span: 6, cards: [Card(style: .regular)]),
    SliceColumn(offset: 12, span: 6, cards: [Card(style: .regular)]),
    SliceColumn(offset: 18, span: 6, cards: [Card(style: .regular)])
])

let regularSliceLarge = Slice(columns: [
    SliceColumn(offset: 0, span: 12, cards: [Card(style: .regular)]),
    SliceColumn(offset: 12, span: 6, cards: [Card(style: .regular)]),
    SliceColumn(offset: 18, span: 6, cards: [Card(style: .regular)])
])

let regular3ColumnSlice = Slice(columns: [
    SliceColumn(offset: 0, span: 8, cards: [Card(style: .regular)]),
    SliceColumn(offset: 8, span: 8, cards: [Card(style: .regular)]),
    SliceColumn(offset: 16, span: 8, cards: [Card(style: .regular)])
])

let compactSlice = Slice(columns: [
    SliceColumn(offset: 0, span: 6, cards: [Card(style: .compact)]),
    SliceColumn(offset: 6, span: 6, cards: [Card(style: .compact)]),
    SliceColumn(offset: 12, span: 6, cards: [Card(style: .compact)]),
    SliceColumn(offset: 18, span: 6, cards: [Card(style: .compact)])
])

// "fixed/small/slow-IV"
let fixed_small_slow_IV = CollectionLayoutTemplate(slices: [
    regularSlice
    ])

fixed_small_slow_IV.setSize(CGSize(width: 200, height: 100), index: 0)
fixed_small_slow_IV.setSize(CGSize(width: 200, height: 100), index: 1)
fixed_small_slow_IV.setSize(CGSize(width: 200, height: 100), index: 2)
fixed_small_slow_IV.setSize(CGSize(width: 200, height: 150), index: 3)


// "fixed/medium/fast-XII"
let fixed_medium_fast_XII = CollectionLayoutTemplate(slices: [
    regularSlice,
    compactSlice,
    compactSlice
    ])

// "fixed/small/slow-III"
let fixed_small_slow_III = CollectionLayoutTemplate(slices: [
    regularSliceLarge
    ])


// "fixed/small/slow-V-third"
let fixed_small_slow_V_third = CollectionLayoutTemplate(slices: [
    Slice(columns: [
        SliceColumn(offset: 0, span: 6, cards: [Card(style: .regular)]),
        SliceColumn(offset: 6, span: 6, cards: [Card(style: .regular)]),
        SliceColumn(offset: 12, span: 12, cards: [
            Card(style: .compact),
            Card(style: .compact),
            Card(style: .compact)
            ])
        ])
    ])

let t = fixed_small_slow_V_third
t.setSize(CGSize(width: 200, height: 200), index: 0)
t.setSize(CGSize(width: 200, height: 200), index: 1)
t.setSize(CGSize(width: 200, height: 80), index: 2)
t.setSize(CGSize(width: 200, height: 150), index: 3)
t.setSize(CGSize(width: 200, height: 150), index: 4)
let c = t.count
let h = t.height

/*

layouts["fixed/small/slow-V-third"] = [[
    SliceColumn(offset: 0, span: 6, cards: [Card(style: .regular)]),
    SliceColumn(offset: 6, span: 6, cards: [Card(style: .regular)]),
    SliceColumn(offset: 12, span: 12, cards: [
        Card(style: .compact),
        Card(style: .compact),
        Card(style: .compact)
        ])
]]

layouts["fixed/small/slow-I"] = [[
    SliceColumn(offset: 0, span: 24, cards: [Card(style: .regular)])
]]

layouts["fixed/small/slow-I"] = [
    [
        SliceColumn(offset: 0, span: 18, cards: [Card(style: .regular)]),
        SliceColumn(offset: 18, span: 6, cards: [Card(style: .regular)])
    ],
    regularSlice
]

layouts["fixed/large/slow-XIV"] = [
    [
        SliceColumn(offset: 0, span: 18, cards: [Card(style: .regular)]),
        SliceColumn(offset: 18, span: 6, cards: [Card(style: .regular)])
    ],
    regularSlice,
    compactSlice,
    compactSlice
]

layouts["fixed/medium/fast-XI"] = [
    regularSliceLarge,
    compactSlice,
    compactSlice
]

layouts["fixed/medium/slow-XII-mpu"] = [
    regular3ColumnSlice,
    [
        SliceColumn(offset: 0, span: 8, cards: [
            Card(style: .compact),
            Card(style: .compact),
            Card(style: .compact)
            ]),
        SliceColumn(offset: 8, span: 8, cards: [
            Card(style: .compact),
            Card(style: .compact),
            Card(style: .compact)
            ]),
        SliceColumn(offset: 16, span: 8, cards: [Card(style: .mpu)])
    ]
]

layouts["fixed/thrasher"] = [
    [
        SliceColumn(offset: 0, span: 24, cards: [Card(style: .regular)])
    ]
]

layouts["fixed/video"] = [
    regular3ColumnSlice
]

layouts["fixed/medium/slow-VII"] = [
    regularSliceLarge,
    regularSlice
]

layouts["fixed/small/fast-VIII"] = [
    [
        SliceColumn(offset: 0, span: 6, cards: [Card(style: .regular)]),
        SliceColumn(offset: 6, span: 6, cards: [Card(style: .regular)]),
        SliceColumn(offset: 12, span: 6, cards: [Card(style: .compact), Card(style: .compact), Card(style: .compact)]),
        SliceColumn(offset: 18, span: 6, cards: [Card(style: .compact), Card(style: .compact), Card(style: .compact)])
    ]
]

layouts["fixed/small/slow-V-mpu"] = [
    [
        SliceColumn(offset: 0, span: 8, cards: [Card(style: .regular)]),
        SliceColumn(offset: 8, span: 8, cards: [Card(style: .compact), Card(style: .compact), Card(style: .compact)]),
        SliceColumn(offset: 16, span: 8, cards: [Card(style: .mpu)])
    ]
]

layouts["fixed/small/slow-V-half"] = [
    [
        SliceColumn(offset: 0, span: 12, cards: [Card(style: .compact), Card(style: .compact), Card(style: .compact)]),
        SliceColumn(offset: 12, span: 12, cards: [Card(style: .regular)]),
    ]
]

layouts["dynamic/fast"] = [
    [
        SliceColumn(offset: 0, span: 12, cards: [Card(style: .regular)]),
        SliceColumn(offset: 12, span: 6, cards: [Card(style: .regular), Card(style: .compact), Card(style: .compact)]),
        SliceColumn(offset: 12, span: 6, cards: [Card(style: .compact), Card(style: .compact), Card(style: .compact), Card(style: .compact), Card(style: .compact)])
    ]
]

layouts["dynamic/slow"] = [
    [
        SliceColumn(offset: 0, span: 12, cards: [Card(style: .compact), Card(style: .compact), Card(style: .compact)]),
        SliceColumn(offset: 12, span: 12, cards: [Card(style: .regular)]),
    ]
]

layouts["dynamic/package"] = [
    [
        SliceColumn(offset: 0, span: 18, cards: [Card(style: .regular)]),
        SliceColumn(offset: 18, span: 6, cards: [Card(style: .regular), Card(style: .regular)])
    ]
]

layouts["dynamic/slow-mpu"] = [
    [
        SliceColumn(offset: 0, span: 12, cards: [Card(style: .regular)]),
        SliceColumn(offset: 12, span: 12, cards: [Card(style: .regular)])
    ],
    [
        SliceColumn(offset: 0, span: 12, cards: [Card(style: .compact), Card(style: .compact), Card(style: .compact)]),
        SliceColumn(offset: 12, span: 12, cards: [Card(style: .mpu)])
    ]
]
*/
