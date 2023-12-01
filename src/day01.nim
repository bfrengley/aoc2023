import std/strutils
from std/sequtils import foldl, mapIt
import std/pegs

from utils import reversed

const
  exampleInputPart1 = """
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
"""
  exampleInputPart2 = """
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
"""
  input = staticRead("data/day01.txt")

func normalizeNum(num: string): string =
  case num
  of "one", "eno": return "1"
  of "two", "owt": return "2"
  of "three", "eerht": return "3"
  of "four", "ruof": return "4"
  of "five", "evif": return "5"
  of "six", "xis": return "6"
  of "seven", "neves": return "7"
  of "eight", "thgie": return "8"
  of "nine", "enin": return "9"
  else: return num

func part1(data: string): int =
  data.splitLines(false).foldl(a + parseInt(b[b.find(Digits)] & b[b.rfind(Digits)]), 0)

func part2(data: string): int =
  for l in splitLines(data, false):
    var numStr = ""
    if l =~ peg"""
S <- (!N .)* {N}
N <- 'one' / 'two' / 'three' / 'four' / 'five' / 'six' / 'seven' / 'eight' / 'nine' / \d""":
      numStr &= normalizeNum(matches[0])

    if l.reversed =~ peg"""
S <- (!N .)* {N}
N <- 'eno' / 'owt' / 'eerht' / 'ruof' / 'evif' / 'xis' / 'neves' / 'thgie' / 'enin' / \d""":
      numStr &= normalizeNum(matches[0])

    result += parseInt(numStr)

when isMainModule:
  var data = input
  stripLineEnd(data)
  echo "Part 1: ", part1(data)
  echo "Part 2: ", part2(data)
