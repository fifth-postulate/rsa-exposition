module PrimesTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Primes exposing (isPrime, primes, take)
import Test exposing (..)


suite : Test
suite =
    describe "The Primes module"
        [ describe "primes variable"
            [ test "take 5 primes should result in the first 5 primes" <|
                \_ ->
                    let
                        first5Primes =
                            take 5 primes
                    in
                    Expect.equal first5Primes [ 2, 3, 5, 7, 11 ]
            ]
        , describe "isPrime"
            [ describe "should identify primes" <|
                List.map isItAPrime [ 2, 3, 5, 7 ]
            , describe "should identify non-primes" <|
                List.map isItComposite [ 1, 4, 6, 8 ]
            ]
        ]


isItAPrime : Int -> Test
isItAPrime n =
    let
        descriptionOfN =
            String.fromInt n
    in
    test (descriptionOfN ++ " is a prime") <|
        \_ ->
            Expect.true (descriptionOfN ++ " to be a prime") <| isPrime n


isItComposite : Int -> Test
isItComposite n =
    let
        descriptionOfN =
            String.fromInt n
    in
    test (descriptionOfN ++ " is a composite") <|
        \_ ->
            Expect.false (descriptionOfN ++ " to be composite") <| isPrime n
