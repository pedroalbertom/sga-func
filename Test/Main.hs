module Main where

import Test.Hspec
import IHP.Prelude
import qualified Test.AcademicSpec as AcademicSpec

main :: IO ()
main = hspec do
    AcademicSpec.spec
