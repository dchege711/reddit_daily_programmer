%include polycode.fmt
---
title: "AoC 2021 Day 08: Seven Segment Search"
date: 2022-03-07
weight: 8
---

{{< citation
    id="AoC2021-08"
    title="Day 8 - Advent of Code 2021"
    url="https://adventofcode.com/2021/day/8"
    accessed="2022-03-07" >}}

\## Part I Description

*You barely reach the safety of the cave when the whale smashes into the cave
mouth, collapsing it. Sensors indicate another exit to this cave at a much
greater depth, so you have no choice but to press on.*

*As your submarine slowly makes its way through the cave system, you notice that
the four-digit seven-segment displays in your submarine are malfunctioning;
they must have been damaged during the escape. You'll be in a lot of trouble
without them, so you'd better figure out what's wrong.*

*Each digit of a seven-segment display is rendered by turning on or off any of
the seven segments named `a` through `g`:*

```md
  0:      1:      2:      3:      4:
 aaaa    ....    aaaa    aaaa    ....
b    c  .    c  .    c  .    c  b    c
b    c  .    c  .    c  .    c  b    c
 ....    ....    dddd    dddd    dddd
e    f  .    f  e    .  .    f  .    f
e    f  .    f  e    .  .    f  .    f
 gggg    ....    gggg    gggg    ....

  5:      6:      7:      8:      9:
 aaaa    aaaa    aaaa    aaaa    aaaa
b    .  b    .  .    c  b    c  b    c
b    .  b    .  .    c  b    c  b    c
 dddd    dddd    ....    dddd    dddd
.    f  e    f  .    f  e    f  .    f
.    f  e    f  .    f  e    f  .    f
 gggg    gggg    ....    gggg    gggg
```

*So, to render a `1`, only segments `c` and `f` would be turned on; the rest
would be off. To render a `7`, only segments `a`, `c`, and `f` would be turned
on.*

*The problem is that the signals which control the segments have been mixed up
on each display. The submarine is still trying to display numbers by producing
output on signal wires `a` through `g`, but those wires are connected to
segments randomly. Worse, the wire/segment connections are mixed un separately
for each four-digit display! (All of the digits within a display use the same
connections, though.)*

*So, you might know that only signal wires `b` and `g` are turned on, but that
doesn't mean segments `b` and `g` are turned on: the only digit that uses two
segments is `1`, so it must mean segments `c` and `f` are meant to be on. With
just that information, you still can't tell which wire (b/g) goes to which
segment (c/f). For that, you'll need to collect more information.*

*For each display, you watch the changing signals for a while, make a note of
all ten unique signal patterns you see, and then write down a single four-digit
output value (your puzzle input). Using the signal patterns, you should be able
to work out which patterns corresponds to which digit.*

*For example, here's what you might see in a single entry in your notes:*

```txt
acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab || cdfeb fcadb cdfeb cdbaf
```

*Each entry consists of ten unique signal patterns, a `||` delimiter, and
finally the four-digit output value. Within an entry, the same wire/segment
connections are used (but you don't know what the connections actually are). The
unique signal patterns correspond to the ten different ways the submarine tries
to render a digit using the current wire/segment connections. Because `7` is the
only digit that uses three segments, `dab` in the above example means that to
render `7`, signal lines `d`, `a`, and `b` are on. Because `4` is the only digit
that uses four segments, `eafb` means that to render a `4`, signal lines `e`,
`a`, `f`, and `b` are on.*

*Using this information, you should be able to work out which combination of
signal wires corresponds to each of the ten digits. Then, you can decode the
four digit output value. Unfortunately, in the above example, all of the digits
in the output value `cdfeb fcadb cdfeb cdbaf` use five segments and are more
difficult to deduce.*

*For now, focus on the easy digits. Because the digits `1`, `4`, `7`, and `8`
each use a unique number of segments, you should be able to tell which
combinations of signals correspond to those digits.*

***In the output values (the part after the `||` on each line), how many times
do digits `1`, `4`, `7`, or `8` appear?***

\## Input Representation

The line `be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb || fdgacbe
cefdb cefbgd gcbe` has `cfbegad` matching with `fdgacbe` in the output value, so
I need a representation that allows those two to be linked. Sorting the
characters is sufficient as it gives `abcdefg` in both cases.

The ten signal patterns are in no particular order, so a `[String]` will do. The
output values do not need to be in any particular order, so a `[String]` will
also do.

\begin{code}
{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -Wall #-}

module AoC2021.SevenSegmentSearch
    (
        SevenSegmentDisplay(..),
        numOf1478AppearancesInOutput,
    )
where

import qualified Data.IntMap as IntMap
import qualified Data.IntSet as IntSet

data SevenSegmentDisplay = SevenSegmentDisplay{
    uniquePatterns :: [String], outputValues :: [String]} deriving Show

\end{code}

\## Part I Solution

\begin{code}

numActiveSegmentsToDigits :: IntMap.IntMap [Int]
numActiveSegmentsToDigits = IntMap.fromList
    [(6, [0, 6, 9]), (2, [1]), (5, [2, 3, 5]), (4, [4]), (3, [7]), (7, [8])]

nonAmbiguousLengths :: IntSet.IntSet
-- There is also `Map.keysSet` but that returns an
nonAmbiguousLengths = IntSet.fromList $ IntMap.keys $
    IntMap.filter (\t -> length t == 1) numActiveSegmentsToDigits

\end{code}

The `containers` package provides `IntMap` and `IntSet` in addition to the
general `Map` and `Set` data structures. {{% cite containersHaskell %}} This
distinction is motivated by {{% cite Okasaki1998 %}}'s work on finite maps that
are based on {{% cite Morrison1968 %}}'s Patricia trees, instead of the usual
base of balanced binary search trees. While both bases have fast lookups and
inserts, Patricia trees have fast merges of two containers. {{% cite
Okasaki1998 %}}

{{% comment %}}

I've been getting the vibe that Haskell is more explicit in its connection to
academia, e.g. foundational papers being linked from API docs, and library
writers and maintainers being faculty in CS departments.

{{% /comment %}}

\begin{code}

numOf1478AppearancesInOutput :: [SevenSegmentDisplay] -> Int
numOf1478AppearancesInOutput = foldr f 0 where
    f :: SevenSegmentDisplay -> Int -> Int
    f SevenSegmentDisplay{ outputValues=outputValues } prevSum =
        prevSum + length (
            filter (\s -> IntSet.member (length s) nonAmbiguousLengths)
            outputValues)

\end{code}

{{% comment %}}

Compared to other Part I's, this one felt too straightforward. Most of the
difficulty was in using `parsec` to parse the input line.

{{% /comment %}}

\## References

1. {{< citation
    id="containersHaskell"
    title="containers: Assorted concrete container types"
    url="https://hackage.haskell.org/package/containers"
    url_2="https://haskell-containers.readthedocs.io/en/latest/"
    url_3="https://github.com/haskell-perf/sets"
    accessed="2022-03-13" >}}

1. {{< citation
    id="Okasaki1998"
    title="Fast Mergeable Integer Maps"
    authors="Okasaki, Chris; Andy Gill"
    affiliations="Columbia University; Semantic Designs"
    publication="Workshop on ML, pp. 77-86"
    year="1998"
    url="http://ittc.ku.edu/~andygill/papers/IntMap98.pdf"
    url_2="https://scholar.google.com/scholar?hl=en&as_sdt=0%2C48&q=Fast+Mergeable+Integer+Maps+(1998)&btnG="
    cited_by_count="91"
    cited_by_count_last_mod="2022-03-13"
    accessed="2022-03-13" >}}

1. {{< citation
    id="Morrison1968"
    author="Morrison, Donald R."
    title="PATRICIA - practical algorithm to retrieve information coded in alphanumeric."
    publication="Journal of the ACM, Vol. 15, No. 4 (1968): 514-534."
    url="https://scholar.google.com/scholar?hl=en&as_sdt=0%2C48&q=PATRICIA%E2%80%94practical+algorithm+to+retrieve+information+coded+in+alphanumeric&btnG="
    cited_by_count="1370"
    cited_by_count_last_mod="2022-03-13"
    accessed="2022-03-13" >}}
