module EulerTest exposing (suite)

import Euler exposing (egcd, gcd)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, intRange)
import Test exposing (..)


suite : Test
suite =
    describe "The Euler module"
        [ describe "gcd"
            [ test "of 37 and 51 is 1" <|
                \_ ->
                    let
                        g =
                            gcd 37 51
                    in
                    Expect.equal g 1
            ]
        , describe "egcd"
            [ fuzz2 (intRange 1 100) (intRange 1 100) "egcd calculates coefficients" <|
                \a b ->
                    let
                        ( g, s, t ) =
                            egcd a b
                    in
                    Expect.equal g (s * a + t * b)
            ]
        ]
