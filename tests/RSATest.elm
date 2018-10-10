module RSATest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, intRange)
import RSA exposing (decrypt, encrypt, generate)
import Test exposing (..)


suite : Test
suite =
    describe "The RSA module"
        [ describe "encrypt and decrypt"
            [ inverseTest 37 53 ]
        ]


inverseTest : Int -> Int -> Test
inverseTest p q =
    let
        n =
            p * q

        keys =
            generate p q
    in
    case keys of
        Ok ( public, private ) ->
            fuzz (intRange 1 (n-1)) "encrypt and decrypt are inverse operation" <|
                \m ->
                    let
                        c =
                            m
                                |> encrypt public
                                |> decrypt private
                    in
                    Expect.equal m c

        Err _ ->
            test "encrypt and decrypt are inverse operations" <|
                \_ -> Expect.fail "Non primes passed as arguments"
