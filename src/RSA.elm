module RSA exposing
    ( generate, PrivateKey, PublicKey
    , encrypt, decrypt
    , GenerationError, errorString
    )

{-| The RSA crypto-system in Elm.


# Constructors

@docs generate, PrivateKey, PublicKey


# Usage

@docs encrypt, decrypt


# Error Handling

@docs GenerationError, errorString


# Usage

    let
        ( public, private ) =
            generate 37 79
    in
    encrypt public value

-}

import Euler exposing (egcd, gcd)
import Primes exposing (isPrime)


{-| The public keys of the RSA crypto-system.

Used to `encrypt` a message.

-}
type alias PublicKey =
    { n : Int, e : Int }


{-| The private keys of the RSA crypto-system.

Uses to `decrypt` a message.

-}
type PrivateKey
    = PrivateKey { p : Int, q : Int, d : Int, phi : Int }


{-| Generates a key-pair for the RSA crypto-system.

The arguments should be two primes. Note that the primes should remain private.

-}
generate : Int -> Int -> Result GenerationError ( PublicKey, PrivateKey )
generate p q =
    case ( isPrime p, isPrime q ) of
        ( True, True ) ->
            generateWithPrimes p q

        ( False, True ) ->
            Err <| NotPrime P

        ( True, False ) ->
            Err <| NotPrime Q

        ( False, False ) ->
            Err <| NotPrime Both


generateWithPrimes : Int -> Int -> Result GenerationError ( PublicKey, PrivateKey )
generateWithPrimes p q =
    let
        n =
            p * q

        phi =
            (p - 1) * (q - 1)

        candidates =
            List.range 2 n

        es =
            List.filter (\e -> gcd e phi == 1) candidates

        e_ =
            List.head es
    in
    case e_ of
        Just e ->
            let
                ( _, d, _ ) =
                    egcd e phi

                positiveD =
                    if d < 0 then
                        d + phi

                    else
                        d
            in
            Ok ( { n = n, e = e }, PrivateKey { p = p, q = q, d = positiveD, phi = phi } )

        Nothing ->
            Err NoSuitableE


{-| The reason why a key-pair generation can go wrong.
-}
type GenerationError
    = NotPrime Argument
    | NoSuitableE


type Argument
    = P
    | Q
    | Both


{-| Returns a `String` detailing why the key-pair generation failed.
-}
errorString : GenerationError -> String
errorString error =
    case error of
        NotPrime argument ->
            case argument of
                P ->
                    "argument P is not a prime"

                Q ->
                    "argument Q is not a prime"

                Both ->
                    "both arguments are not prime"

        NoSuitableE ->
            "can not find a suitable E"


{-| Encrypts a message.
-}
encrypt : PublicKey -> Int -> Int
encrypt { n, e } m =
    powermod n m e


{-| Decrypts a message.
-}
decrypt : PrivateKey -> Int -> Int
decrypt (PrivateKey { p, q, d }) c =
    let
        n =
            p * q
    in
    powermod n c d


{-| Determines base^exponent modulo modulus with the aid of repeated squaring.
-}
powermod : Int -> Int -> Int -> Int
powermod modulus base exponent =
    tailCallPowermod modulus base exponent 1


tailCallPowermod : Int -> Int -> Int -> Int -> Int
tailCallPowermod modulus base exponent accumulator =
    if exponent == 0 then
        accumulator

    else
        let
            square =
                modBy modulus (base * base)

            e =
                exponent // 2
        in
        if modBy 2 exponent == 1 then
            let
                a =
                    modBy modulus (base * accumulator)
            in
            tailCallPowermod modulus square e a

        else
            tailCallPowermod modulus square e accumulator
