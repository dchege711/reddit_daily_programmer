{-# OPTIONS_GHC -Wall #-}

module AoC2021 (solution01) where

-- https://cabal.readthedocs.io/en/3.4/cabal-package.html#accessing-data-files-from-package-code
import Paths_advent_of_code_y2021 (getDataFileName)

import Data.String (IsString(fromString))
import System.IO (withFile, IOMode (ReadMode), hGetContents)

import SonarSweep.SonarSweep as SonarSweep
    ( numIncreases, num3MeasurementIncreases )

solution01 :: IO ()
solution01 = do
  -- hGetContents is lazy in that data is only read as the characters are
  -- processed. The lazy evaluation of the string is transparent, and so it can
  -- be passed to pure functions without any issues. However, if we try to hold
  -- onto `s` past the call to `numIncreases`, then we lose the memory
  -- efficiency as the compiler is forced to keep its value in memory for future
  -- use. Note that closing a handle before fully consuming its results will
  -- make you miss on the stream's data that had not been evaluated before the
  -- handle's close. [1] [2]
  --
  -- [1]: http://book.realworldhaskell.org/read/io.html#io.lazy.hGetContents
  -- [2]: https://hackage.haskell.org/package/base-4.16.0.0/docs/System-IO.html#v:hGetContents

  fp <- getDataFileName "src/SonarSweep/scratchpad/input.txt"
  putStrLn "Day 01. Sonar Sweep"
  withFile
    fp
    ReadMode
    ( \h -> do
        s <- hGetContents h
        putStr "\tPart 1: Number of measurements larger than previous measurement: "
        print (SonarSweep.numIncreases (lines (fromString s)))
        putStr "\tPart 2: Number of 3-measurements larger than previous 3-measurement: "
        print (SonarSweep.num3MeasurementIncreases (lines (fromString s)))
    )