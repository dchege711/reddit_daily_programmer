module Main (main) where

import Data.String (IsString (fromString))
import Paths_advent_of_code_y2021 (getDataFileName)
import SonarSweep.SonarSweep as SonarSweep
  ( num3MeasurementIncreases,
    numIncreases,
  )
import System.IO (IOMode (ReadMode), hGetContents, withFile)
import Test.HUnit (Counts, Test (TestCase, TestLabel, TestList), assertEqual, runTestTT)

testSonarSweep :: Test
testSonarSweep =
  TestCase
    ( do
        fp <- getDataFileName "src/SonarSweep/scratchpad/sample.txt"
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

tests :: Test
tests = TestList [TestLabel "testSonarSweep" testSonarSweep]

main :: IO Counts
main = do
  runTestTT tests