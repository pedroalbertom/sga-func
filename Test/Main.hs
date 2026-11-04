module Main where

import Test.Hspec
import IHP.Prelude
import qualified Test.CatalogSpec as CatalogSpec
import qualified Test.AcademicSpec as AcademicSpec
import qualified Test.AdvancedSpec as AdvancedSpec
import qualified Test.SecuritySpec as SecuritySpec

main :: IO ()
main = hspec do
    AcademicSpec.spec
    CatalogSpec.spec
    AdvancedSpec.spec
    SecuritySpec.spec
