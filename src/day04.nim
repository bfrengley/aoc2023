import std/[sequtils, strutils, strscans]
from std/sugar import `=>`

const
  exampleInput = """
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"""
  input = staticRead("data/day04.txt")

proc number(s: string, start: int, fn: proc (n: int)): int =
  var n = 0
  while result+start < s.len and s[result+start] in {'0'..'9'}:
    n = 10 * n + ord(s[result+start]) - ord('0')
    inc(result)
  if result != 0:
    fn(n)

proc main(data: string, part2 = false): int =
  var cardCounts =
    if part2:
      repeat(1, Natural(countLines(data) + 1))
    else:
      newSeq[int]()

  for line in data.splitLines(false):

    var
      idx = 0
      id = 0
      winningNums: set[int8]
      myNums: set[int8]

    assert scanp(line, idx,
                 "Card", +' ', (number($input, $index, (n: int) => (id = n))), ':', +' ',
                 (number($input, $index, (n: int) => winningNums.incl(int8(n))) ^+ (+' ')),
                 *' ', '|', +' ',
                 (number($input, $index, (n: int) => myNums.incl(int8(n))) ^+ (+' ')))

    let myWinningNums = winningNums * myNums

    if not part2:
      if myWinningNums.card != 0:
        result += 1 shl (myWinningNums.card - 1)
    else:
      result += cardCounts[id]

      for i in countup(1, myWinningNums.card):
        cardCounts[id + i] += cardCounts[id]

when isMainModule:
  var data = input
  stripLineEnd(data)
  echo "Part 1: ", main(data)
  echo "Part 2: ", main(data, true)
