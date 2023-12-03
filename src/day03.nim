import std/[strutils, sequtils, enumerate, options]
from std/sugar import `=>`, collect

const
  exampleInput = """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""
  input = staticRead("data/day03.txt")

type
  N = object
    n: int
    y: int
    xs: Slice[int]
  Pos = tuple[x: int, y: int]

iterator neighbours(pos: Pos): Pos =
  for y in (pos.y - 1)..(pos.y + 1):
    if y >= 0:
      for x in (pos.x - 1)..(pos.x + 1):
        if x >= 0:
          yield (x: x, y: y)

func part1(input: string): int =
  let width = input.find('\n')
  var
    grid = newSeqWith(input.countLines(), newSeq[Option[N]](width))
    symbols = newSeq[Pos](0.Natural)


  for y, line in enumerate(input.splitLines(false)):
    var x = 0
    for (tok, isSep) in line.tokenize(PunctuationChars):
      if isSep:
        # there might be some symbols in here
        for (symTok, isDots) in tok.tokenize({'.'}):
          if not isDots:
            add(symbols, (x: x, y: y))
          x += symTok.len
      else: # number
        let n = N(n: parseInt(tok), y: y, xs: x..<(x + tok.len))
        for x in n.xs:
          grid[y][x] = some(n)
        x += tok.len

  for symbol in symbols:
    let ns = collect(newSeqOfCap(9.Natural)):
      for (x, y) in symbol.neighbours:
        let maybeN = grid[y][x]
        if maybeN.isSome:
          maybeN.get()

    for n in ns.deduplicate(true):
      result += n.n

when isMainModule:
  var data = input
  stripLineEnd(data)
  echo "Part 1: ", part1(data)
