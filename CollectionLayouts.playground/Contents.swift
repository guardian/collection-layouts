//: Playground - noun: a place where people can play

import UIKit

struct CollectionLayoutTemplate: Codable {
    let cards: [Slice]
}

typealias Slice = [SliceColumn]

struct SliceColumn: Codable {
    let offset: Int
    let span: Int
    let cards: [Card]
}

struct Card: Codable {
    let style: CardStyle
}

enum CardStyle: String, Codable {
    case compact
    case regular
    case mpu
}

var layouts: [String: [Slice]] = [:]

let regularSlice = [
    SliceColumn(offset: 0, span: 6, cards: [Card(style: .regular)]),
    SliceColumn(offset: 6, span: 6, cards: [Card(style: .regular)]),
    SliceColumn(offset: 12, span: 6, cards: [Card(style: .regular)]),
    SliceColumn(offset: 18, span: 6, cards: [Card(style: .regular)])
]

let regularSliceLarge = [
    SliceColumn(offset: 0, span: 12, cards: [Card(style: .regular)]),
    SliceColumn(offset: 12, span: 6, cards: [Card(style: .regular)]),
    SliceColumn(offset: 18, span: 6, cards: [Card(style: .regular)])
]

let regular3ColumnSlice = [
    SliceColumn(offset: 0, span: 8, cards: [Card(style: .regular)]),
    SliceColumn(offset: 8, span: 8, cards: [Card(style: .regular)]),
    SliceColumn(offset: 16, span: 8, cards: [Card(style: .regular)])
]

let compactSlice = [
    SliceColumn(offset: 0, span: 6, cards: [Card(style: .compact)]),
    SliceColumn(offset: 6, span: 6, cards: [Card(style: .compact)]),
    SliceColumn(offset: 12, span: 6, cards: [Card(style: .compact)]),
    SliceColumn(offset: 18, span: 6, cards: [Card(style: .compact)])
]

layouts["fixed/small/slow-IV"] = [
    regularSlice
]

layouts["fixed/medium/fast-XII"] = [
    regularSlice,
    compactSlice,
    compactSlice
]

layouts["fixed/small/slow-III"] = [
    regularSliceLarge
]

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

