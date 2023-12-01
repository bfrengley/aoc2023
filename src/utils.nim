from std/algorithm import nil

func toString*(s: seq[char]): string = 
    result = newStringOfCap(s.len)
    for c in s:
        add(result, c)

func reversed*(s: string): string =
    algorithm.reversed(s).toString
