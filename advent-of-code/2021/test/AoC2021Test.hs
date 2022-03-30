module Main (main) where

import AoC2021InputParser
  (
    parseBinaryDiagnosticInput,
    parseBingoInput,
    parseHydrothermalVents,
    parseLanternfishInternalTimers,
    parseHorizontalCrabPositions,
    parseSevenSegmentsDisplay,
    parseHeightMap
  )
import BinaryDiagnostic.BinaryDiagnostic (lifeSupportRating, powerConsumption)
import Data.String (IsString (fromString))
import Dive.Dive (productOfFinalPosition, productOfFinalPositionWithNewIntepretation)
import GiantSquid (scoreOfFirstWinningBoard, scoreOfLastWinningBoard)
import HydrothermalVenture.HydrothermalVenture
  ( pointsWithAtLeastTwoRightSegmentOverlaps,
    pointsWithAtLeastTwoSegmentOverlaps,
  )
import qualified AoC2021.Lanternfish (numOfFishIn80Days, numOfFishIn256Days)
import qualified AoC2021.TreacheryOfWhales as TreacheryOfWhales
  (
    minFuelForAlignmentWithConstantBurnRate,
    minFuelForAlignmentWithIncreasingBurnRate
  )
import qualified AoC2021.SevenSegmentSearch as SevenSegmentSearch
  (numOf1478AppearancesInOutput, sumOfOutputValues)
import qualified AoC2021.SmokeBasin as SmokeBasin (sumOfRiskLevelsOfLowPoints)
import Paths_advent_of_code_y2021 (getDataFileName)
import SonarSweep ( num3MeasurementIncreases, numIncreases )
import System.IO (IOMode (ReadMode), hGetContents, withFile)
import Test.HUnit (Counts, Test (TestCase, TestLabel, TestList), assertEqual, runTestTT)

testSonarSweep :: Test
testSonarSweep =
  TestCase
    ( do
        fp <- getDataFileName "src/scratchpad/01-sonar-sweep.sample.txt"
        withFile
          fp
          ReadMode
          ( \h -> do
              s <- hGetContents h
              let ls = lines (fromString s)
              assertEqual "numIncreases," 7 (SonarSweep.numIncreases ls)
              assertEqual "numIncreases," 5 (SonarSweep.num3MeasurementIncreases ls)
          )
    )

testDive :: Test
testDive =
  TestCase
    ( do
        fp <- getDataFileName "src/Dive/scratchpad/sample.txt"
        withFile
          fp
          ReadMode
          ( \h -> do
              s <- hGetContents h
              let ls = lines (fromString s)
              assertEqual "Stale Interpretation," 150 (productOfFinalPosition ls)
              assertEqual
                "Correct Interpretation,"
                900
                (productOfFinalPositionWithNewIntepretation ls)
          )
    )

testBinaryDiagnostic :: Test
testBinaryDiagnostic =
  TestCase
    ( do
        input <- parseBinaryDiagnosticInput "src/BinaryDiagnostic/scratchpad/sample.txt"
        assertEqual "Power Consumption," 198 (powerConsumption input)
        assertEqual "Life Support Rating," 230 (lifeSupportRating input)
    )

testGiantSquid :: Test
testGiantSquid =
  TestCase
    ( do
        input <- parseBingoInput "src/scratchpad/04-giant-squid.sample.txt"
        assertEqual
          "Score of First Winning Board,"
          4512
          (scoreOfFirstWinningBoard input)
        assertEqual
          "Score of Last Winning Board,"
          1924
          (scoreOfLastWinningBoard input)
    )

testHydrothermalVenture :: Test
testHydrothermalVenture =
  TestCase
    ( do
        input <- parseHydrothermalVents "src/HydrothermalVenture/scratchpad/sample.txt"
        assertEqual
          "Num Points w/ >= 2 Right Segments Overlapping,"
          5
          (pointsWithAtLeastTwoRightSegmentOverlaps input)
        assertEqual
          "Num Points w/ >= 2 Segments Overlapping,"
          12
          (pointsWithAtLeastTwoSegmentOverlaps input)
    )

testLanternfish :: Test
testLanternfish =
  TestCase
    ( do
        input <- parseLanternfishInternalTimers "src/scratchpad/06-lanternfish.sample.txt"
        assertEqual
          "Num of lantern fish in 80 days,"
          5934
          (AoC2021.Lanternfish.numOfFishIn80Days input)
        assertEqual
          "Num of lantern fish in 256 days,"
          26984457539
          (AoC2021.Lanternfish.numOfFishIn256Days input)
    )

testTreacheryOfWhales :: Test
testTreacheryOfWhales =
  TestCase
    ( do
        input <- parseHorizontalCrabPositions "src/scratchpad/07-treachery-of-whales.sample.txt"
        assertEqual
          "Min fuel needed to align horizontal positions "
          37
          (TreacheryOfWhales.minFuelForAlignmentWithConstantBurnRate input)
        assertEqual
          "Min fuel needed to align horizontal postions under increasing burn rate "
          168
          (TreacheryOfWhales.minFuelForAlignmentWithIncreasingBurnRate input)
    )

testSevenSegmentSearch :: Test
testSevenSegmentSearch =
  TestCase
  ( do
      input <- parseSevenSegmentsDisplay "src/scratchpad/08-seven-segment-search.sample.txt"
      assertEqual
        "Num times 1, 4, 7, or 8 appears in output values "
        26
        (SevenSegmentSearch.numOf1478AppearancesInOutput input)

      assertEqual
        "Sum of output values "
        61229
        (SevenSegmentSearch.sumOfOutputValues input)
  )

testSmokeBasin :: Test
testSmokeBasin =
  TestCase
  ( do
      input <- parseHeightMap "src/scratchpad/09-smoke-basin.sample.txt"
      assertEqual
        "Sum of the risk levels of all low points on heightmap "
        15
        (SmokeBasin.sumOfRiskLevelsOfLowPoints input)
  )

tests :: Test
tests =
  TestList
    [ TestLabel "Day 01: Sonar Sweep" testSonarSweep,
      TestLabel "Day 02: Dive!" testDive,
      TestLabel "Day 03: Binary Diagnostic" testBinaryDiagnostic,
      TestLabel "Day 04: Giant Squid" testGiantSquid,
      TestLabel "Day 05: Hydrothermal Venture" testHydrothermalVenture,
      TestLabel "Day 06: Lanternfish" testLanternfish,
      TestLabel "Day 07: The Treachery Of Whales" testTreacheryOfWhales,
      TestLabel "Day 08: Seven Segment Search" testSevenSegmentSearch,
      TestLabel "Day 09: Smoke Basin" testSmokeBasin
    ]

main :: IO Counts
main = do
  runTestTT tests
