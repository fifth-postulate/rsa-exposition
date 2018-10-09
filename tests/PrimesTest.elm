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
            [ describe "should identify primes"
                [ test "2 is a prime" <|
                    \_ ->
                        Expect.true "2 to be prime" (isPrime 2)
                , test "3 is a prime" <|
                    \_ ->
                        Expect.true "3 to be prime" (isPrime 3)
                , test "5 is a prime" <|
                    \_ ->
                        Expect.true "5 to be prime" (isPrime 5)
                , test "7 is a prime" <|
                    \_ ->
                        Expect.true "7 to be prime" (isPrime 7)
                ]
            , describe "should identify non-primes"
                [ test "1 is a not prime" <|
                    \_ ->
                        Expect.false "1 to not be prime" (isPrime 1)
                , test "4 is a not prime" <|
                    \_ ->
                        Expect.false "4 to not be prime" (isPrime 4)
                , test "6 is a not prime" <|
                    \_ ->
                        Expect.false "6 to not be prime" (isPrime 6)
                , test "8 is a not prime" <|
                    \_ ->
                        Expect.false "8 to not be prime" (isPrime 8)
                ]
            ]
        ]
