module RSA exposing (PrivateKey, PublicKey, generate, GenerationError, errorString)

import Euler exposing (egcd, gcd)
import Primes exposing (isPrime)


type alias PublicKey =
    { n : Int, e : Int }


type PrivateKey
    = PrivateKey { p : Int, q : Int, d : Int, phi : Int }


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
            in
            Ok ( { n = n, e = e }, PrivateKey { p = p, q = q, d = d, phi = phi } )

        Nothing ->
            Err NoSuitableE


type GenerationError
    = NotPrime Argument
    | NoSuitableE


type Argument
    = P
    | Q
    | Both

errorString : GenerationError -> String
errorString error =
    case error of
        NotPrime argument ->
            case argument of
                P -> "argument P is not a prime"

                Q -> "argument Q is not a prime"

                Both -> "both arguments are not prime"

        NoSuitableE ->
            "can not find a suitable E"
