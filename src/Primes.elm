module Primes exposing
    ( primes, LazyList
    , take, isPrime
    , IsPrime, isProbablePrime
    )

{-| Provides a lazy, infinite list of primes.


# Definition

@docs primes, LazyList


# Helpers

@docs take, isPrime

The following code snippets will result in the same list. Notice that with the `primes` example we do not need to know the upper bound.

    take 50 primes

returns the same list as

    List.filter isPrime <| List.range 2 230

-}


{-| A lazy list. Makes it possible to create infinite lists.
-}
type LazyList a
    = Empty
    | Promise (() -> LazyList a)
    | Cons a (LazyList a)


{-| Like `List.take` but for `LazyList`.
-}
take : Int -> LazyList a -> List a
take n lazyList =
    if n == 0 then
        []

    else
        case lazyList of
            Empty ->
                []

            Promise generator ->
                take n <| generator ()

            Cons x xs ->
                x :: take (n - 1) xs


integers : LazyList Int
integers =
    integersFrom 0


integersFrom : Int -> LazyList Int
integersFrom head =
    let
        tail =
            Promise (\_ -> integersFrom <| head + 1)
    in
    Cons head tail


filter : (a -> Bool) -> LazyList a -> LazyList a
filter predicate lazyList =
    case lazyList of
        Empty ->
            Empty

        Promise g ->
            let
                generator _ =
                    filter predicate (g ())
            in
            Promise generator

        Cons x xs ->
            if predicate x then
                Cons x <| filter predicate xs

            else
                filter predicate xs


sieve : LazyList Int -> LazyList Int
sieve lazyList =
    case lazyList of
        Empty ->
            Empty

        Promise g ->
            let
                generator _ =
                    sieve (g ())
            in
            Promise generator

        Cons p ps ->
            let
                tail =
                    ps
                        |> filter (\n -> modBy p n /= 0)
                        |> sieve
            in
            Cons p tail


{-| A lazy list of prime numbers.
-}
primes : LazyList Int
primes =
    sieve <| integersFrom 2


{-| Determines if the argument is prime.
-}
isPrime : Int -> Bool
isPrime n =
    let
        candidates =
            List.range 1 n

        divisorOf m d =
            modBy d m == 0

        divisors =
            List.filter (divisorOf n) candidates
    in
    List.length divisors == 2


{-| Type to determine in which category a number falls.

A number is either a `Prime`, a `Composite` number or a `Probable` prime.

-}
type IsPrime
    = Prime
    | Composite Int
    | Probable


type alias Strategy a b =
    a -> b


{-| Determines if the input is a prime, a composite or a probably prime.
-}
isProbablePrime : Strategy Int IsPrime
isProbablePrime n =
    n
        |> compoundStrategy
            [ smallPrimeDivisors
            ]


compoundStrategy : List (Strategy Int IsPrime) -> Strategy Int IsPrime
compoundStrategy strategies =
    \n ->
        let
            ( _, verdict ) =
                strategies
                    |> List.map lift
                    |> List.foldl (<|) ( n, Probable )
        in
        verdict


lift : Strategy Int IsPrime -> Strategy ( Int, IsPrime ) ( Int, IsPrime )
lift strategy =
    \( n, verdict ) ->
        case verdict of
            Prime ->
                ( n, Prime )

            (Composite _) as composite ->
                ( n, composite )

            Probable ->
                ( n, strategy n )


smallPrimeDivisors : Strategy Int IsPrime
smallPrimeDivisors n =
    let
        smallPrimes =
            [ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229 ]

        divisorOfN p =
            modBy p n == 0

        smallDivisor =
            first divisorOfN smallPrimes
    in
    case smallDivisor of
        Just d ->
            if d == n then
                Prime
            else
                Composite d

        Nothing ->
            Probable


first : (a -> Bool) -> List a -> Maybe a
first predicate haystack =
    case haystack of
        [] ->
            Nothing

        x :: xs ->
            if predicate x then
                Just x

            else
                first predicate xs
