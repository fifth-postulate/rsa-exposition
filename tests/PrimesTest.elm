module PrimesTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


import Primes exposing (primes, take)

suite : Test
suite =
    describe "The Primes module" [
        describe "primes variable" [
            test "take 5 primes should result in the first 5 primes" <|
                \_ -> 
                    let
                        first5Primes = take 5 primes
                    in
                        Expect.equal first5Primes [2, 3, 5, 7, 11]
        ]
    ]
