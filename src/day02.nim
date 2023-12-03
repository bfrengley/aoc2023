import std/[strscans, strutils, sequtils]
from std/sugar import `=>`

const
  exampleInput = """
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"""
  input = staticRead("data/day02.txt")


type
  Colour = enum red, blue, green
  Reveal = array[Colour, int]

func colour(input: string, clr: var Colour, start: int): int =
  result = 0
  var colourStr = ""
  if scanf(input.substr(start), "$w$.", colourStr):
    case colourStr
    of "red", "blue", "green":
      result = colourStr.len
      clr = parseEnum[Colour](colourStr)
    else: discard

func parseGame(s: string): tuple[n: int, reveals: seq[Reveal]] =
  var rest: string
  assert scanf(s, "Game $i: $*$.", result.n, rest)
  for group in rest.split("; "):
    var reveal: Reveal
    for rv in group.split(", "):
      var
        n: int
        clr: Colour
      assert scanf(rv, "$i ${colour}", n, clr)
      reveal[clr] += n
    add(result.reveals, reveal)

func part1(input: string): int =
  let cubes: array[Colour, int] = [12, 14, 13]
  for line in input.splitLines(false):
    let (id, reveals) = parseGame(line)
    if reveals.all((rv) => rv.pairs.toSeq.all((pair) => pair[1] <= cubes[pair[0]])):
      result += id

func part2(input: string): int =
  for line in input.splitLines(false):
    let (_, reveals) = parseGame(line)
    var cubes: array[Colour, int] = [0, 0, 0]
    for reveal in reveals:
      for c, n in reveal.pairs:
        if cubes[c] < n:
          cubes[c] = n
    result += cubes.items.toSeq.foldl(a * b)

when isMainModule:
  var data = input
  stripLineEnd(data)
  echo "Part 1: ", part1(data)
  echo "Part 2: ", part2(data)
