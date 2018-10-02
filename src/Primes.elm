module Primes exposing
    ( primes, LazyList
    , take, isPrime
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

{-| Determines if the argument is prime. -}
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
