module Main where

import Test.Hspec
import IHP.Prelude
import qualified Test.CatalogSpec as CatalogSpec
import qualified Test.AcademicSpec as AcademicSpec

main :: IO ()
main = hspec do
    AcademicSpec.spec
    CatalogSpec.spec
